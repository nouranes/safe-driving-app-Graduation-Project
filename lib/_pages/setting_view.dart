import 'package:final_project/cubits/app_theme_cubit.dart';
import 'package:final_project/cubits/app_theme_state.dart';
import 'package:final_project/login&regisrer/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting_View extends StatelessWidget {
  static const String routeName = 'setting';

  void logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    Navigator.pushReplacementNamed(context, Login_screen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final themeDataa = BlocProvider.of<AppThemeCubit>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "1".tr,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "16".tr,
                style: TextStyle(color: textColor),
              ),
              Switch(
                value: themeDataa.state is AppDarkTheme,
                onChanged: (_) => themeDataa.changeTheme(),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "60".tr,
                style: TextStyle(color: textColor),
              ),
              DropdownButton<String>(
                value: Get.locale?.languageCode,
                items: [
                  DropdownMenuItem(
                    value: 'en',
                    child: Text('English'),
                  ),
                  DropdownMenuItem(
                    value: 'ar',
                    child: Text('العربية'),
                  ),
                ],
                onChanged: (String? value) {
                  if (value != null) {
                    var locale = Locale(value);
                    Get.updateLocale(locale);
                  }
                },
              ),
            ],
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
                "17".tr,
                style: TextStyle(color: textColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
