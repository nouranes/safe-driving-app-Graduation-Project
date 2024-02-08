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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(190, 190, 190, 0.2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Image.asset(
              imagePath,
              fit: BoxFit
                  .cover, // Adjust height based on your design requirements
            ),
          ],
        ),
      ),
    );
  }
}