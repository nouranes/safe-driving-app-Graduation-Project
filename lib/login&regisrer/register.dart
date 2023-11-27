import 'package:final_project/widgets/text_form_filed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class Register_Screen extends StatelessWidget {
  static const String routeName = 'register';
  TextEditingController fullnameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirm_passwordController = TextEditingController();
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
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
                                    'Full Name',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )),

                              const SizedBox(
                                height: 20,
                              ),

                              FadeInRight(
                                delay: const Duration(milliseconds: 100),
                                child: Custom_Form_Field(
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'please enter the full name ';
                                      }
                                    },
                                    controller: fullnameController,
                                    hint: 'enter your name'),
                              ),

                              const SizedBox(
                                height: 30,
                              ),

                              FadeInRight(
                                  delay: const Duration(milliseconds: 150),
                                  child: Text(
                                    'Mobile Number',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )),

                              const SizedBox(
                                height: 20,
                              ),

                              FadeInRight(
                                delay: const Duration(milliseconds: 200),
                                child: Custom_Form_Field(
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'please enter your mobile number';
                                    }
                                    return null;
                                  },
                                  controller: mobileController,
                                  hint: 'enter your mobile number',
                                ),
                              ),

                              const SizedBox(
                                height: 20,
                              ),
                              //-------------------------------------
                              FadeInRight(
                                  delay: const Duration(milliseconds: 250),
                                  child: Text(
                                    'Email',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )),

                              const SizedBox(
                                height: 20,
                              ),

                              FadeInRight(
                                delay: const Duration(milliseconds: 100),
                                child: Custom_Form_Field(
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'please enter the Email ';
                                      }
                                    },
                                    controller: fullnameController,
                                    hint: 'enter your Email'),
                              ),
                              //--------------------------------
                              const SizedBox(
                                height: 20,
                              ),
                              //-------------------------------------
                              FadeInRight(
                                  delay: const Duration(milliseconds: 50),
                                  child: Text(
                                    'Password',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )),

                              const SizedBox(
                                height: 20,
                              ),

                              FadeInRight(
                                delay: const Duration(milliseconds: 300),
                                child: Custom_Form_Field(
                                    secureText: true,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'please enter the Password ';
                                      }
                                    },
                                    controller: fullnameController,
                                    hint: 'enter your password'),
                              ),
                              //----------------------------------
                              const SizedBox(
                                height: 20,
                              ),
                              //-------------------------------------
                              FadeInRight(
                                  delay: const Duration(milliseconds: 350),
                                  child: Text(
                                    'Confirm Password',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )),

                              const SizedBox(
                                height: 20,
                              ),

                              FadeInRight(
                                delay: const Duration(milliseconds: 400),
                                child: Custom_Form_Field(
                                    secureText: true,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'please Cofirm your password ';
                                      }
                                    },
                                    controller: fullnameController,
                                    hint: 'Confirm your password'),
                              ),
                              FadeInRight(
                                delay: const Duration(milliseconds: 450),
                                child: MaterialButton(
                                  onPressed: () {
                                    if (formkey.currentState?.validate() ??
                                        false) {
                                      Navigator.pushNamed(
                                          context, Register_Screen.routeName);
                                    }
                                  },
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 60,
                                    width: mediaQuery.width,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xFF083663),
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      "Create Account",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                ),
                              ),
                            ]))))));
  }
}
