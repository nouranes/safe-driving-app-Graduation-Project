import 'package:final_project/_pages/camera.dart';
import 'package:final_project/_pages/nearest_places(map).dart';
import 'package:final_project/widgets/buttom_home_widget.dart';
import 'package:flutter/material.dart';

class Home_View extends StatelessWidget {
  static const String routeName = 'home_view';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Buttons_Home_Widget(
          task: 'Start Journey ?',
          details: 'Use a camera feature to ensure safe journey',
          onClick: () {
            Navigator.pushNamed(context, MainScreen.routeName);
          },
        ),
        Buttons_Home_Widget(
          task: 'Nearest Places',
          details: 'Use the map to locate nearest places',
          onClick: () {
            Navigator.pushNamed(context, Nearest_places.routeName);
          },
        ),
      ],
    );
  }
}