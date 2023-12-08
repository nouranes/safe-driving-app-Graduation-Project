import 'package:final_project/_pages/home_view.dart';
import 'package:final_project/_pages/profile_view.dart';
import 'package:final_project/_pages/setting_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class Home_Screen extends StatefulWidget {
  static const String routeName = 'home';

  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  int selected_index = 0;

  List<Widget> Pages = [
    Home_View(),
    Setting_View(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          //showModalBottomSheet(context: context, builder:(context) => Container(),);
          Navigator.pushNamed(context, Profile_View.routeName);
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          padding: EdgeInsets.all(4),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF083663),
            ),
            child: Icon(PhosphorIcons.user),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,

      //backgroundColor: Color(0xFF083663),
      appBar: AppBar(
          backgroundColor: Color(0xFF083663),
          title: Text('Safe Journey'),
          titleTextStyle: Theme.of(context).textTheme.bodyMedium),
      body: Pages[selected_index],
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF083663),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: selected_index,
          onTap: (value) {
            //selected_index = value;
            setState(() {
              selected_index = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                selected_index == 0
                    ? PhosphorIcons.house_fill
                    : PhosphorIcons.house,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                selected_index == 1
                    ? PhosphorIcons.gear_fill
                    : PhosphorIcons.gear,
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
