import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class InstalledAppsList extends StatefulWidget {
  @override
  State<InstalledAppsList> createState() => _InstalledAppsListState();
}

class _InstalledAppsListState extends State<InstalledAppsList> {
  Map<String, bool> notificationStatus = {};
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage notification'),
      ),
      body: FutureBuilder<List<Application>>(
        future: DeviceApps.getInstalledApplications(
          includeAppIcons: true,
          includeSystemApps: false,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Application> installedApps = snapshot.data!;
            return ListView.builder(
              itemCount: installedApps.length,
              itemBuilder: (context, index) {
                final Application app = installedApps[index];
                return ListTile(
                  leading: app is ApplicationWithIcon
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(app.icon),
                        )
                      : null,
                  title: Text(app.appName),
                  subtitle: Text(app.packageName),
                  trailing: Switch(
                    value: notificationStatus.containsKey(app.packageName)
                        ? notificationStatus[app.packageName]!
                        : false,
                    onChanged: (bool value) {
                      setState(() {
                        // Update the notification status
                        notificationStatus[app.packageName] = value;
                      });
                      // Call the method to toggle notifications
                      toggleNotifications(app.packageName, value);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> toggleNotifications(String packageName, bool value) async {
    if (value) {
      // Disable notifications from other apps
      await flutterLocalNotificationsPlugin.cancelAll();
      print('Notifications disabled for other apps while running your app.');
    } else {
      // Enable notifications from other apps
      await SystemChannels.platform.invokeMethod<void>(
        'flutter_local_notifications_cancel_notification',
        packageName,
      );
      print('Notifications enabled for other apps while running your app.');
    }
  }

  Future<void> sendNotification(
      String packageName, String title, String body) async {
    // Create a AndroidNotificationDetails for the channel
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'driver_protection_channel', // معرف قناة الإشعارات
      'Driver Protection', // اسم قناة الإشعارات
      importance: Importance.max,
      priority: Priority.high,
      visibility: NotificationVisibility.secret,
    );

    // Create a NotificationDetails
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Show notification
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: packageName,
    );
  }
}
