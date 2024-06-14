import 'package:final_project/_pages/camera.dart';
import 'package:final_project/_pages/home_screen.dart';
import 'package:final_project/_pages/home_view.dart';
import 'package:final_project/_pages/profile_view.dart';
import 'package:final_project/_pages/setting_view.dart';
import 'package:final_project/_pages/user_provider.dart';
import 'package:final_project/login&regisrer/login.dart';
import 'package:final_project/login&regisrer/register.dart';
import 'package:final_project/map/nearest_gasoline.dart';
import 'package:final_project/map/nearest_hospital.dart';
import 'package:final_project/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
      create: (context) => UserProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          // Add other providers if needed
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
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
                unselectedIconTheme:
                IconThemeData(size: 26, color: Colors.white)),
            //------------------------------------------------
            textTheme: TextTheme(
              titleLarge: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              titleMedium: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              bodyLarge: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              bodyMedium: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              bodySmall: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.black,
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
            // NearByPlacesScreen.routeName: (context) => NearByPlacesScreen(),
            NearestHospital.routeName: (context) => NearestHospital(),
            NearestGasoline.routeName: (context) => NearestGasoline(),
          },
        ));
  }
}
