import 'dart:async';

import 'package:final_project/login&regisrer/login.dart';
import 'package:flutter/material.dart';

class Splash_Screen extends StatelessWidget {
  static const String routeName = 'splash';

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, Login_screen.routeName);
    });
    return Scaffold(
      body: Image.asset('assets/images/splashscreen.png'),
    );
  }
}
