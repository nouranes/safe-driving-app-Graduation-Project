import 'dart:async';

import 'package:final_project/_pages/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Splash_Screen extends StatefulWidget {
  static const String routeName = 'splash';

  @override
  _Splash_ScreenState createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/images/سبلاش.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        Navigator.pushReplacementNamed(context, OnboardingScreens.routeName);
      }
    });

    Timer(Duration(seconds: 50), () {
      if (_controller.value.isInitialized) {
        Navigator.pushReplacementNamed(context, OnboardingScreens.routeName);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
