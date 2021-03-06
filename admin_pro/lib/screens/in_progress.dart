import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:admin_pro/theme/colors/light_colors.dart';
import 'package:intl/intl.dart';
import 'package:admin_pro/widgets/task_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

// FirebaseApp secondaryApp = Firebase.app('adminpro');
// FirebaseFirestore firestore = FirebaseFirestore.instanceFor(app: secondaryApp);

// class InProgress extends StatelessWidget {
//   const InProgress({Key key}) : super(key: key);

// }

int weekNumber(DateTime date) {
  int dayOfYear = int.parse(DateFormat("D").format(date));
  return ((dayOfYear - date.weekday + 10) / 7).floor();
}

DateTime firstDay(DateTime d){
  DateTime newd = DateTime.parse("${d.year}-${d.month}-${d.day} 00:00:00Z");
  return newd.subtract(new Duration(days: d.weekday));
}

DateTime  lastDay(DateTime d){
  DateTime newd = DateTime.parse("${d.year}-${d.month}-${d.day} 00:00:00Z");
  return newd.add(new Duration(days: 7-d.weekday));
}

class InProgress extends StatefulWidget {
  InProgress({Key key}) : super(key: key);

  @override
  _InProgressState createState() => _InProgressState();
}

class _InProgressState extends State<InProgress> {


  Widget _buildListItem(
    BuildContext context,
    DocumentSnapshot doc,
  ) {
    return TaskContainer(
      title: doc['student'],
      subtitle: "Due " + doc['due_date'].toDate().toString(),
      boxColor: LightColors.kLightYellow2,
      price: doc['price'],
      tutor: doc['tutor'],
      id: doc.id,
      // a:assignments[index]
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime  t = DateTime.now();

    CollectionReference assgs =
        FirebaseFirestore.instance.collection('assignments');
    return Scaffold(
      body: SafeArea(
        child: Expanded(
                  child: Container(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 15.0),
                    Text(
                      "Upcoming Tasks",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    ),
                    SizedBox(height: 15.0),
                    ExpandablePanel(
                      header: Text(
                        "This Week",
                        style: GoogleFonts.play(
                            textStyle: TextStyle(fontSize: 25.0)),
                      ),
                      expanded: StreamBuilder(
                        stream: assgs.where('due_date',isGreaterThan: firstDay(t)).where('due_date',isLessThanOrEqualTo: lastDay(t)).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) return Text("Loading.......");
                          return Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (BuildContext context, int index) {

                                return _buildListItem(
                                  context,
                                  snapshot.data.documents[index],
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                              physics: const NeverScrollableScrollPhysics(),
                            ),
                          );
                        },
                      ),
                      tapHeaderToExpand: true,
                      hasIcon: true,
                    ),
                    ExpandablePanel(
                      header: Text(
                        " After This Week",
                        style: GoogleFonts.play(
                            textStyle: TextStyle(fontSize: 25.0)),
                      ),
                      expanded: StreamBuilder(
                        stream: assgs.where('due_date',isGreaterThanOrEqualTo: lastDay(t)).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) return Text("Loading.......");
                          return Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (BuildContext context, int index) {
                                // var date = assignments[index].dueDate;
                                // var formattedDate =
                                //     "${date.day}-${date.month}-${date.year}";
                                return _buildListItem(
                                  context,
                                  snapshot.data.documents[index],
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                              physics: const NeverScrollableScrollPhysics(),
                            ),
                          );
                        },
                      ),
                      tapHeaderToExpand: true,
                      hasIcon: true,
                    ),
                    Divider(
                      color: Colors.black12,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
