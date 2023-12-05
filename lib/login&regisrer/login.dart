import 'package:animate_do/animate_do.dart';
import 'package:final_project/_pages/home_screen.dart';
import 'package:final_project/login&regisrer/register.dart';
import 'package:final_project/widgets/dialog_utilies.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/text_form_filed.dart';

class Login_screen extends StatefulWidget {
  static const String routeName = 'login';

  @override
  State<Login_screen> createState() => _Login_screenState();
}

class _Login_screenState extends State<Login_screen> {
  TextEditingController emailController =
      TextEditingController(text: "nouran11@gmail.com");

  TextEditingController passwordController =
      TextEditingController(text: "nouran12@N");

  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF083663),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FadeInRight(
                      delay: const Duration(milliseconds: 50),
                      child: Text(
                        'Welcome',
                        style: Theme.of(context).textTheme.titleLarge,
                      )),
                  FadeInRight(
                      delay: const Duration(milliseconds: 100),
                      child: Text(
                        'Please sign in with your mail',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  FadeInRight(
                      delay: const Duration(milliseconds: 150),
                      child: Text(
                        'E-mail',
                        style: Theme.of(context).textTheme.bodyLarge,
                      )),
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
                      )),
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
                  GestureDetector(
                      onTap: () {},
                      child: FadeInRight(
                          delay: const Duration(milliseconds: 350),
                          child: Text(
                            'Forget Password ?',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.end,
                          ))),
                  const SizedBox(
                    height: 30,
                  ),
                  FadeInRight(
                    delay: const Duration(milliseconds: 400),
                    child: MaterialButton(
                      onPressed: () {
                        if (formkey.currentState?.validate() ?? false) {}
                        login();
                      },
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: mediaQuery.width,
                        decoration: BoxDecoration(
                          //color: Colors.white,

                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
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
                          ))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    DialogUtiles.showLoading(context, 'Loading...');

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Login successful, add navigation or other actions here

      // Example: Navigate to the next screen
      DialogUtiles.showMessage(context, message: "Login Successfully");
      Navigator.pushReplacementNamed(context, Home_Screen.routeName);
    } on FirebaseAuthException catch (e) {
      DialogUtiles.hideLoading(context);
      DialogUtiles.showMessage(
        context,
        message: 'Error in E-mail or password ,check them again',
        title: 'Error',
        posActionName: 'ok',
      );

      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        DialogUtiles.showMessage(
          context,
          message: 'Wrong password provided for that user.',
          title: 'Error',
          posActionName: 'ok',
        );
        print('Wrong password provided for that user.');
      } else {
        // Handle other FirebaseAuthExceptions
        print(e.toString());
      }
    } catch (e) {
      DialogUtiles.hideLoading(context);
      print(e.toString());
    }
  }
}
