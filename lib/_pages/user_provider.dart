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

  //save changes
  //  clickOnSaveChanges(MyUser user )async{
  //   await DataBaseUtiles
  //       .getUserCollectioon().doc(user.id)
  //       .collection(MyUser.collectionName)
  //       .doc(user.id).set(user);

  //
  Future<void> clickOnSaveChanges(MyUser updatedUser) async {
    try {
      // Ensure that the user is not null
      if (user != null) {
        // Update user data in Firestore
        var userDocRef = DataBaseUtiles.getUserCollectioon().doc(user!.id);
        await userDocRef.update(updatedUser.toJson());

        // Update user data in Firebase Authentication
        await FirebaseAuth.instance.currentUser
            ?.updateDisplayName(updatedUser.fullName);

        // Update the local user object
        setUser(updatedUser);

        // Notify listeners about the change
        notifyListeners();

        // Print a success message or perform any other necessary actions
        print("User data updated successfully!");
      } else {
        print("User is null, unable to save changes.");
      }
    } catch (error) {
      // Handle any errors that may occur during the update process
      print("Error updating user data: $error");
    }
  }
}
