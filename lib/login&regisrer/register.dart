import 'package:animate_do/animate_do.dart';
import 'package:final_project/widgets/dialog_utilies.dart';
import 'package:final_project/widgets/text_form_filed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register_Screen extends StatefulWidget {
  static const String routeName = 'register';

  @override
  State<Register_Screen> createState() => _Register_ScreenState();
}

class _Register_ScreenState extends State<Register_Screen> {
  TextEditingController fullnameController =
      TextEditingController(text: "nouran");

  TextEditingController mobileController =
      TextEditingController(text: "01027532464");

  TextEditingController emailController =
      TextEditingController(text: "nouran11@gmail.com");

  TextEditingController passwordController =
      TextEditingController(text: "nouran12@N");

  TextEditingController confirm_passwordController =
      TextEditingController(text: "nouran12@N");

  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xFF083663),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 35,
        ),
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
                              //-------------------------------------------
                              FadeInRight(
                                  delay: const Duration(milliseconds: 50),
                                  child: Text(
                                    'Full Name',
                                    style:
                                    Theme.of(context).textTheme.bodyLarge,
                                  )),

                              const SizedBox(
                                height: 2,
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
                              //--------------------------------------

                              const SizedBox(
                                height: 20,
                              ),

                              FadeInRight(
                                  delay: const Duration(milliseconds: 150),
                                  child: Text(
                                    'Mobile Number',
                                    style:
                                    Theme.of(context).textTheme.bodyLarge,
                                  )),

                              const SizedBox(
                                height: 2,
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
                                height: 2,
                              ),

                              FadeInRight(
                                delay: const Duration(milliseconds: 100),
                                child: Custom_Form_Field(
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'please enter the Email ';
                                      }
                                      RegExp emailRegex = RegExp(
                                        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                                      );

                                      if (!emailRegex.hasMatch(value)) {
                                        return 'Please enter a valid email address';
                                      }
                                      return null;
                                    },
                                    controller: emailController,
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
                                height: 2,
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
                                      RegExp regex = RegExp(
                                          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,}$');

                                      // Test the password against the regex
                                      if (!regex.hasMatch(value)) {
                                        return 'Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character.';
                                      }

                                      // Password is valid
                                      return null;
                                    },
                                    controller: passwordController,
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
                                height: 2,
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
                                      if (value != passwordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                    controller: confirm_passwordController,
                                    hint: 'Confirm your password'),
                              ),
                              FadeInRight(
                                delay: const Duration(milliseconds: 450),
                                child: MaterialButton(
                                  onPressed: () {
                                    if (formkey.currentState?.validate() ??
                                        false) {}

                                    register();
                                  },
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 60,
                                    width: mediaQuery.width,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
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

  register() async {
    DialogUtiles.showLoading(context, 'Loading...');
    try {
      final credintial =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      //need to hide loading
      DialogUtiles.hideLoading(context);

      //need to show message
      DialogUtiles.showMessage(context,
          message: 'Register Successfully',
          title: 'sucess',
          posActionName: 'ok');
      print('register successifully ');
      print(credintial.user?.uid ?? '');
    } on FirebaseAuthException catch (e) {
      //if make an error

      if (e.code == 'weak-password') {
        //need to hide loading
        DialogUtiles.hideLoading(context);

        //need to show message
        DialogUtiles.showMessage(context,
            message: 'The password provided is too weak.',
            title: 'Error',
            posActionName: 'ok');
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        //need to hide loading
        DialogUtiles.hideLoading(context);

        //need to show message
        DialogUtiles.showMessage(context,
            message: 'The account already exists for that email.',
            title: 'Error',
            posActionName: 'ok');

        print('The account already exists for that email.');
      }
    } catch (e) {
      //need to hide loading
      DialogUtiles.hideLoading(context);

      //need to show message
      DialogUtiles.showMessage(context,
          message: " ${e.toString()}", title: 'Error', posActionName: 'ok');

      print(e);
    }
  }
}
