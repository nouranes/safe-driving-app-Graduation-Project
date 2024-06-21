import 'package:animate_do/animate_do.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:final_project/_pages/home_screen.dart';
import 'package:final_project/_pages/user_provider.dart';
import 'package:final_project/login&regisrer/register.dart';
import 'package:final_project/login&regisrer/register_data.dart';
import 'package:final_project/widgets/dialog_utilies.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/text_form_filed.dart';

class Login_screen extends StatefulWidget {
  static const String routeName = 'login';

  @override
  State<Login_screen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login_screen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, Home_Screen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FadeInRight(
                    delay: const Duration(milliseconds: 50),
                    child: Text(
                      'Welcome',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  FadeInRight(
                    delay: const Duration(milliseconds: 100),
                    child: Text(
                      'Please sign in with your mail',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  FadeInRight(
                    delay: const Duration(milliseconds: 150),
                    child: Text(
                      'E-mail',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FadeInRight(
                    delay: const Duration(milliseconds: 200),
                    child: Custom_Form_Field(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'please enter your E-mail';
                        }
                      },
                      controller: emailController,
                      hint: 'enter your e-mail',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  FadeInRight(
                    delay: const Duration(milliseconds: 250),
                    child: Text(
                      'Password',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FadeInRight(
                    delay: const Duration(milliseconds: 300),
                    child: Custom_Form_Field(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'please enter your password';
                        }
                      },
                      controller: passwordController,
                      hint: 'enter your password',
                      secureText: true,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      sendPasswordResetEmail();
                    },
                    child: FadeInRight(
                      delay: const Duration(milliseconds: 350),
                      child: Text(
                        'Forget Password ?',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FadeInRight(
                    delay: const Duration(milliseconds: 400),
                    child: MaterialButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          login();
                        }
                      },
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: mediaQuery.width,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Log In",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Register_Screen.routeName);
                    },
                    child: FadeInRight(
                      delay: const Duration(milliseconds: 450),
                      child: Text(
                        'Don’t have an account? Create Account',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    DialogUtiles.showLoading(context, 'Loading...');

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Retrieve user data from the database
      var userObj = await DataBaseUtiles.getUser(credential.user?.uid ?? '');
      if (userObj == null) {
        DialogUtiles.hideLoading(context);
        DialogUtiles.showMessage(
          context,
          dialogType: DialogType.error,
          message: 'Something went wrong',
          posActionName: 'ok',
        );
        return;
      }

      // Set user data in provider
      Provider.of<UserProvider>(context, listen: false).setUser(userObj);
      Provider.of<UserProvider>(context, listen: false).notifyListeners();

      // Save login status in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);

      // Show success message and navigate to home screen
      DialogUtiles.hideLoading(context);
      DialogUtiles.showMessage(context,
          dialogType: DialogType.success, message: "Login Successfully");
      Navigator.pushReplacementNamed(context, Home_Screen.routeName);
    } on FirebaseAuthException catch (e) {
      DialogUtiles.hideLoading(context);
      if (e.code == 'user-not-found') {
        DialogUtiles.showMessage(
          context,
          dialogType: DialogType.error,
          message: 'No user found for that email.',
          posActionName: 'ok',
        );
      } else if (e.code == 'wrong-password') {
        DialogUtiles.showMessage(
          context,
          dialogType: DialogType.error,
          message: 'Wrong password provided for that user.',
          posActionName: 'ok',
        );
      } else {
        DialogUtiles.showMessage(
          context,
          dialogType: DialogType.error,
          message: 'Error in E-mail or password, check them again',
          posActionName: 'ok',
        );
      }
    } catch (e) {
      DialogUtiles.hideLoading(context);
      DialogUtiles.showMessage(
        context,
        dialogType: DialogType.error,
        message: 'An unexpected error occurred. Please try again later.',
        posActionName: 'ok',
      );
    }
  }

  void sendPasswordResetEmail() async {
    String email = emailController.text; // Replace with the user's email

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Password reset email sent successfully
      DialogUtiles.showMessage(context,
          dialogType: DialogType.success,
          message: "Password reset email sent to $email");
      // print("Password reset email sent to $email");
    } catch (e) {
      // An error occurred. Handle the error.
      DialogUtiles.showMessage(context,
          dialogType: DialogType.error,
          message:
              "Error sending password reset email: The email address is badly formatted.");
      print("Error sending password reset email: $e");
    }
  }
}