import 'package:final_project/_pages/camera.dart';
import 'package:final_project/_pages/home_screen.dart';
import 'package:final_project/_pages/home_view.dart';
import 'package:final_project/_pages/nearest_places(map).dart';
import 'package:final_project/_pages/profile_view.dart';
import 'package:final_project/_pages/setting_view.dart';
import 'package:final_project/login&regisrer/login.dart';
import 'package:final_project/login&regisrer/register.dart';
import 'package:final_project/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        iconTheme: IconThemeData(color: Colors.white),
        //-------------------------------------
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedIconTheme: IconThemeData(
              size: 32,
              color: Colors.white,
            ),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            unselectedIconTheme: IconThemeData(size: 26, color: Colors.white)),
        //------------------------------------------------
        textTheme: TextTheme(
          titleLarge: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          titleMedium: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          bodySmall: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
      ),
      initialRoute: Splash_Screen.routeName,
      routes: {
        Splash_Screen.routeName: (context) => Splash_Screen(),
        Login_screen.routeName: (context) => Login_screen(),
        Register_Screen.routeName: (context) => Register_Screen(),
        Home_Screen.routeName: (context) => Home_Screen(),
        Home_View.routeName: (context) => Home_View(),
        Profile_View.routeName: (context) => Profile_View(),
        Setting_View.routeName: (context) => Setting_View(),
        MainScreen.routeName: (context) => MainScreen(),
        Nearest_places.routeName: (context) => Nearest_places(),
      },
    );
  }
}
