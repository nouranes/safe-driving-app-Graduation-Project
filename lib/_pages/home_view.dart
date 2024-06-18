import 'package:final_project/_pages/camera.dart';
import 'package:final_project/_pages/user_provider.dart';
import 'package:final_project/widgets/buttom_home_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mapwNearplaces.dart';

class Home_View extends StatelessWidget {
  static const String routeName = 'home_view';

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    String userName = userProvider.user?.fullName ?? "";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Hi, $userName",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              AssetImage('assets/images/photo_splash.jpg'),
                          radius: 20,
                        ),
                      ],
                    )),
              ),
              SizedBox(height: 12),
              Container(
                margin: EdgeInsets.only(left: 20, right: 10),
                child: Text(
                  'You can choose any feature to maintain and ensure your safety',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
              SizedBox(height: 8),
              Buttons_Home_Widget(
                imagePath: 'assets/images/photo_2024-02-07_15-53-50.jpg',
                //assets/images/cameraa.png
                task: 'Start Journey ?',
                details: 'Click to use a camera feature',
                onClick: () {
                  Navigator.pushNamed(context, RealTimeDetection.routeName);
                },
              ),
              Buttons_Home_Widget(
                imagePath: 'assets/images/photo_2024-02-07_15-53-57.jpg',
                task: 'Nearest Places',
                details: 'Use the map to locate nearest places',
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapWidget(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}