import 'package:final_project/_pages/camera.dart';
import 'package:final_project/_pages/nearest_places(map).dart';
import 'package:final_project/widgets/buttom_home_widget.dart';
import 'package:flutter/material.dart';

class Home_View extends StatelessWidget {
  static const String routeName = 'home_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text("welcome",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold))),
            ),
            SizedBox(height: 8),
            Container(
              margin: EdgeInsets.only(left: 20, right: 10),
              child: Text(
                'There are many features that will help you ensure a safe journey for you',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            SizedBox(height: 8),
            Buttons_Home_Widget(
              imagePath: 'assets/images/camera_icon.jpg',
              task: 'Start Journey ?',
              details: 'Click to use a camera feature',
              onClick: () {
                Navigator.pushNamed(context, MainScreen.routeName);
              },
            ),
            Buttons_Home_Widget(
              imagePath: 'assets/images/location_icon.png',
              task: 'Nearest Places',
              details: 'Use the map to locate nearest places',
              onClick: () {
                Navigator.pushNamed(context, Nearest_places.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}