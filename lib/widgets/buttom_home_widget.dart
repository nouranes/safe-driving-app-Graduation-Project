import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Buttons_Home_Widget extends StatelessWidget {
  String task;

  String details;
  VoidCallback? onClick;

  Buttons_Home_Widget(
      {required this.task, required this.details, this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick?.call();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFFDBE4ED),
        ),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            //margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            width: 400,
            height: 115,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFDBE4ED)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task,
                  style: TextStyle(
                      color: Color(0xFF083663),
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  details,
                  style: TextStyle(color: Color(0xFF083663), fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )),
      ),
    );
  }
}
