import 'package:final_project/_pages/dashboard.dart';
import 'package:final_project/_pages/history.dart';
import 'package:final_project/_pages/home_view.dart';
import 'package:final_project/_pages/profile_view.dart';
import 'package:final_project/_pages/setting_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String? userEmail;
  bool showFullNavBar = false;

  @override
  void initState() {
    super.initState();
    getCurrentUserEmail();
  }

  void getCurrentUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userEmail = user?.email;
      showFullNavBar = isUberEmail(userEmail);
    });
  }

  bool isUberEmail(String? email) {
    return email != null && email.endsWith('@uber.com');
  }

  List<Widget> getPages() {
    List<Widget> pages = [
      Home_View(),
      HistoryScreen(),
    ];

    if (showFullNavBar) {
      pages.add(DashboardScreen());
    }

    pages.addAll([
      Profile_View(),
      Setting_View(),
    ]);

    return pages;
  }

  List<BottomNavigationBarItem> getNavBarItems() {
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon: _buildIcon(PhosphorIcons.house, 0),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: _buildIcon(PhosphorIcons.clock, 1),
        label: '',
      ),
    ];

    if (showFullNavBar) {
      items.add(BottomNavigationBarItem(
        icon: _buildIcon(PhosphorIcons.graph, 2),
        label: '',
      ));
    }

    items.addAll([
      BottomNavigationBarItem(
        icon: _buildIcon(PhosphorIcons.user, showFullNavBar ? 3 : 2),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: _buildIcon(PhosphorIcons.gear, showFullNavBar ? 4 : 3),
        label: '',
      ),
    ]);

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getPages()[selected_index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        items: getNavBarItems(),
        currentIndex: selected_index,
        onTap: (index) {
          setState(() {
            selected_index = index;
          });
        },
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    return selected_index == index
        ? CircleAvatar(
            radius: 25,
            backgroundColor: Colors.black,
            child: Icon(icon, color: Colors.white, size: 32),
          )
        : Icon(icon, color: Colors.black, size: 26);
  }
}
