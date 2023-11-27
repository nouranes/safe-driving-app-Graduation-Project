import 'package:final_project/login&regisrer/login.dart';
import 'package:final_project/login&regisrer/register.dart';
import 'package:final_project/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        iconTheme: IconThemeData(color: Color(0xFF083663)),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF083663),
          ),
          titleMedium: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF083663),
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF083663),
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Color(0xFF083663),
          ),
          bodySmall: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: Color(0xFF083663),
          ),
        ),
      ),
      initialRoute: Splash_Screen.routeName,
      routes: {
        Splash_Screen.routeName: (context) => Splash_Screen(),
        Login_screen.routeName: (context) => Login_screen(),
        Register_Screen.routeName: (context) => Register_Screen(),
      },
    );
  }
}
