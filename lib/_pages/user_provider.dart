import 'package:final_project/_pages/user_model.dart';
import 'package:final_project/login&regisrer/register_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  MyUser? user;
  User? firebaseUser;

  UserProvider() {
    firebaseUser = FirebaseAuth.instance.currentUser;
    initUser();
  }

  initUser() async {
    if (firebaseUser != null) {
      user = await DataBaseUtiles.getUser(firebaseUser?.uid ?? '');
    }
  }

  // Ensure that you have the following method in your UserProvider
  void setUser(MyUser newUser) {
    user = newUser;
    notifyListeners();
  }
}
