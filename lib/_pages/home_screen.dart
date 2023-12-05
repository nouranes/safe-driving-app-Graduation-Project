import 'package:final_project/_pages/home_view.dart';
import 'package:final_project/_pages/profile_view.dart';
import 'package:flutter/material.dart';

class Home_Screen extends StatefulWidget {
  static const String routeName = 'home';

  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  int selected_index = 0;

  List<Widget> screens = [
    Home_View(),
    Profile_View(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Safe Journey'),
          titleTextStyle: Theme.of(context).textTheme.bodyMedium),
      body: screens[selected_index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        currentIndex: selected_index,
        onTap: (value) {
          selected_index = value;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/home_icon.png')),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/profile_icon.png'),
              ),
              label: 'Profile')
        ],
      ),
    );
  }
}
