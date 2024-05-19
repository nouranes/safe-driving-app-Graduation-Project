import 'package:final_project/login&regisrer/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../focus/focus.dart';

class Setting_View extends StatefulWidget {
  static const String routeName = 'setting';

  @override
  State<Setting_View> createState() => _Setting_ViewState();
}

class _Setting_ViewState extends State<Setting_View> {
  void logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    Navigator.pushReplacementNamed(context, Login_screen.routeName);
  }

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  // FlutterLocalNotificationsPlugin();
  // final List<String> installedApps = [];
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _getInstalledApps();
  //   _initializeNotifications();
  // }
  // Future<void> _initializeNotifications() async {
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //   AndroidInitializationSettings('@mipmap/ic_launcher');
  //   final InitializationSettings initializationSettings =
  //   InitializationSettings(android: initializationSettingsAndroid);
  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }
  //
  // Future<void> _getInstalledApps() async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   setState(() {
  //     installedApps.add(packageInfo.appName);
  //   });
  // }
  // Future<void> _cancelNotifications(String appName) async {
  //   await flutterLocalNotificationsPlugin.cancel(0, tag: appName);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text('Settings',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InstalledAppsList(),
                ),
              );
            },
            child: Text('Manage Notifications'),
          ),
          Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red)),
              onPressed: () {
                logout(context);
              },
              child: Text(
                "Log out",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
