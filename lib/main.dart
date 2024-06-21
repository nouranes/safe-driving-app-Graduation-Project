import 'package:camera/camera.dart';
import 'package:final_project/_pages/camera.dart';
import 'package:final_project/_pages/dashboard.dart';
import 'package:final_project/_pages/history.dart';
import 'package:final_project/_pages/home_screen.dart';
import 'package:final_project/_pages/home_view.dart';
import 'package:final_project/_pages/onboarding.dart';
import 'package:final_project/_pages/profile_view.dart';
import 'package:final_project/_pages/setting_view.dart';
import 'package:final_project/_pages/user_provider.dart';
import 'package:final_project/cubits/app_theme_cubit.dart';
import 'package:final_project/cubits/app_theme_state.dart';
import 'package:final_project/locale/locale.dart';
import 'package:final_project/login&regisrer/login.dart';
import 'package:final_project/login&regisrer/register.dart';
import 'package:final_project/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize cameras
  final cameras = await availableCameras();
  final firstCamera = cameras.firstWhere(
    (camera) => camera.lensDirection == CameraLensDirection.front,
  );

  // Run the app with necessary providers and camera configuration
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      // Replace UserProvider with your actual provider class
      child: MyApp(camera: firstCamera),
    ),
  );
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  MyApp({required this.camera});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppThemeCubit(),
        ),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: BlocBuilder<AppThemeCubit, AppThemeState>(
        builder: (context, state) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,

            theme: _buildThemeData(state),
            translations: MyLocale(), // Add this line
            locale: const Locale('en'), // Default locale
            fallbackLocale: Locale('en'),
            // state is AppLightTheme ? ThemeData.light() : ThemeData.dark(),
            routes: {
              Splash_Screen.routeName: (context) => Splash_Screen(),
              OnboardingScreens.routeName: (context) => OnboardingScreens(),
              Login_screen.routeName: (context) => Login_screen(),
              Register_Screen.routeName: (context) => Register_Screen(),
              Home_Screen.routeName: (context) => Home_Screen(),
              Home_View.routeName: (context) => Home_View(),
              Profile_View.routeName: (context) => Profile_View(),
              Setting_View.routeName: (context) => Setting_View(),
              RealTimeDetection.routeName: (context) =>
                  RealTimeDetection(camera: camera),
              ShowResult.routeName: (context) => ShowResult(),
              HistoryScreen.routeName: (context) => HistoryScreen(),
            },
            initialRoute: Splash_Screen.routeName,
          );
        },
      ),
    );
  }

  ThemeData _buildThemeData(AppThemeState state) {
    return state is AppLightTheme ? ThemeData.light() : ThemeData.dark();
  }
}
