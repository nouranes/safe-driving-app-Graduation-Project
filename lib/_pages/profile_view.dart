import 'package:final_project/_pages/user_model.dart';
import 'package:final_project/_pages/user_provider.dart';
import 'package:final_project/login&regisrer/register_data.dart';
import 'package:final_project/widgets/text_filed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile_View extends StatefulWidget {
  static const String routeName = 'profile';

  @override
  State<Profile_View> createState() => _Profile_ViewState();
}

class _Profile_ViewState extends State<Profile_View> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();

  bool isEditing = false;

  void initState() {
    super.initState();

    MyUser? user = Provider.of<UserProvider>(context, listen: false).user;

    // Check if user is not null
    if (user != null) {
      // Fetch user data from Firestore and update the UI
      DataBaseUtiles.getUser(user.id).then((MyUser? updatedUser) {
        if (updatedUser != null) {
          setState(() {
            _nameController.text = updatedUser.fullName ?? '';
            _numberController.text = updatedUser.number ?? '';
            _emailController.text = updatedUser.email ?? '';
          });
        }
      }).catchError((error) {
        // Handle error as needed
        print('Error fetching user data: $error');
      });
    }
  }

  // void handleSaveButton() async {
  //   if (isEditing) {
  //     // Perform the update in Firebase Firestore
  //     await updateUserInFirestore(_emailController);
  //     // Set isEditing to false after saving changes
  //     setState(() {
  //       isEditing = false;
  //     });
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    // Use Consumer to rebuild the widget when user data changes
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        // Access the user data from the provider
        final user = userProvider.user;
        print('User in Profile_View: $user');

        return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${user?.fullName ?? ''}',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                Text(
                  ' ${user?.email ?? ''}',
                  style: TextStyle(color: Colors.black45, fontSize: 14),
                ),
                //____________________________________________________

                SizedBox(height: 10),

                //____________________________________________________
                Text(
                  'User Name',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),

                //_____________________________________--
                Text_filed(
                  data: _nameController,
                ),
                //--____________________________________________
                Text(
                  'Mobile Number',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),

                //_____________________________________________
                Text_filed(
                  data: _numberController,
                ),

                //__________________________________-

                Text(
                  'E-mail',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),

                //________________________________________

                Text_filed(
                  data: _emailController,
                ),
                //______________________________________________
                Text(
                  'Password',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                //__________________________________________________

                Text_filed(
                  data: _passwordController,
                ),
                //_________________________________________________
                Text(
                  'Confirm Password',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                //__________________________________________________

                Text_filed(
                  data: _confirmpasswordController,
                ),
                //_________________________________________________
                // Save button
                // ElevatedButton(
                //   onPressed: handleSaveButton,
                //   child: Text('Save'),)
              ],
            ),
          ),
        );
      },
    );
  }
}
