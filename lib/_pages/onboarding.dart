import 'package:final_project/login&regisrer/login.dart';
import 'package:flutter/material.dart';

class OnboardingScreens extends StatefulWidget {
  static String routeName = 'dcnfv';

  @override
  _OnboardingScreensState createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              buildOnboardingPage(
                imagePath: 'assets/images/accident-car.png',
                title: 'Stay Safe and Secure',
                description:
                    'Use our live camera feed to monitor if you\'re sleeping, seatbelted, or distracted while driving to protect against accidents and minimize financial consequences.',
                isLastPage: false,
              ),
              buildOnboardingPage(
                imagePath: 'assets/images/nearest places.jpg',
                title: 'Find Nearest Places',
                description:
                    'Use the map to navigate and find your destination easily. Need help? Check out the nearest hospitals or gas stations nearby!',
                isLastPage: false,
              ),
              buildOnboardingPage(
                imagePath: 'assets/images/history.jpg',
                title: 'Explore Your Journey History',
                description:
                    'Trace back your adventures and relive your favorite trips with our history feature.',
                isLastPage: true,
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                if (_currentPage == 2)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Login_screen.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.yellow, // background color
                      onPrimary: Colors.black, // text color
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'GET STARTED!',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.0),
                      width: 20.0, // width of the dash
                      height: 4.0, // height of the dash
                      decoration: BoxDecoration(
                        color: _currentPage == 0 ? Colors.yellow : Colors.grey,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.0),
                      width: 20.0, // width of the dash
                      height: 4.0, // height of the dash
                      decoration: BoxDecoration(
                        color: _currentPage == 1 ? Colors.yellow : Colors.grey,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.0),
                      width: 20.0, // width of the dash
                      height: 4.0, // height of the dash
                      decoration: BoxDecoration(
                        color: _currentPage == 2 ? Colors.yellow : Colors.grey,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOnboardingPage({
    required String imagePath,
    required String title,
    required String description,
    required bool isLastPage,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Spacer(), // Add Spacer to push the content to the center
          ClipOval(
            child: Image.asset(imagePath,
                height: 250, width: 250, fit: BoxFit.cover),
          ),
          SizedBox(height: 30),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
