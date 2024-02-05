import 'package:flutter/material.dart';

class Buttons_Home_Widget extends StatelessWidget {
  String task;
  final String imagePath;
  String details;
  VoidCallback? onClick;

  Buttons_Home_Widget({
    required this.task,
    required this.details,
    this.onClick,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick?.call();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          width: 400,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromRGBO(190, 190, 190, 0.2),
          ),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 100,
                height: 120,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      details,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
