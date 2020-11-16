import 'package:flutter/material.dart';
import 'package:admin_pro/screens/taskview.dart';

class TaskContainer extends StatelessWidget {
  final String title;
  final String subtitle,tutor;
  final Color boxColor;
  final int price;
  final String id;
  
  TaskContainer({
    this.title, this.subtitle, this.boxColor, this.price, this.tutor, this.id
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
          onPressed: () {
            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TaskView(id:id)));
          },
          child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        padding: EdgeInsets.all(20.0),
        height:100.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),

            Column(
              children: [
                Text("Tutor : "+tutor),
                Padding(child: Text(price.toString()+" \$",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0
                  ),
                ),
                padding:EdgeInsets.only(top: 10.0),),
              ],
            )

          ],
        ),
        decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }
}