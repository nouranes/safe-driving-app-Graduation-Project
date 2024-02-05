import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:final_project/_pages/home_view.dart';
import 'package:final_project/_pages/profile_view.dart';
import 'package:final_project/_pages/setting_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class Home_Screen extends StatefulWidget {
  static const String routeName = 'home';

  const Home_Screen({Key? key}) : super(key: key);

  @override
  State<Home_Screen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home_Screen> {
  int selected_index = 0;

  List<Widget> pages = [
    Home_View(),
    Profile_View(),
    Setting_View(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selected_index],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        // Set background color to white
        color: Colors.black,
        buttonBackgroundColor: Colors.black,
        height: 50,
        items: [
          Icon(
            PhosphorIcons.house_fill,
            size: 30,
            color: Colors.white, // Set icon color to black
          ),
          Icon(
            PhosphorIcons.user,
            color: Colors.white, // Set icon color to black
          ),
          Icon(
            PhosphorIcons.gear_fill,
            size: 30,
            color: Colors.white, // Set icon color to white
          ),
        ],
        onTap: (index) {
          setState(() {
            selected_index = index;
          });
        },
      ),
    );
  }
}
