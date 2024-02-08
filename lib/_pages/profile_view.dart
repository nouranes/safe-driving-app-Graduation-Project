import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:final_project/_pages/user_model.dart';
import 'package:final_project/_pages/user_provider.dart';
import 'package:final_project/login&regisrer/register_data.dart';
import 'package:final_project/widgets/dialog_utilies.dart';
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

  //TextEditingController _passwordController = TextEditingController();
  //TextEditingController _confirmpasswordController = TextEditingController();

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
    var mediaQuery = MediaQuery.of(context).size;
    // Use Consumer to rebuild the widget when user data changes
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        // Access the user data from the provider
        final user = userProvider.user;
        print('User in Profile_View: $user');

        return Scaffold(
          backgroundColor: Colors.white,

          // appBar: AppBar(
          //   title: Text('Profile'),
          // ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: double.infinity,
                  height: 300,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Image.asset(
                        'assets/images/profillle_photo.jpg',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            height: 80,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                          CircleAvatar(
                            radius: 82,
                            backgroundColor: Colors.white,
                            child: InkWell(
                              onTap: () {
                                _showBottomSheet();
                              },
                              //       },
                              child: CircleAvatar(
                                radius: 75,

                                //         backgroundImage: AssetImage('assets/images/photo_splash.jpg'),
                                //         radius: 70,
                                child: Icon(Icons.camera_alt, size: 30),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                //   Stack(
                //   children: [
                //   Container(
                //   height: 150,
                //     width: double.infinity,
                //     color: Colors.blue,
                //     child: Image.asset(
                //       "assets/images/profile_container_backg.jpg",
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                //
                //   Positioned(
                //     bottom: 20, // Adjust the position as needed
                //     left: MediaQuery.of(context).size.width / 4,
                //     child: InkWell(
                //       onTap: () {
                //         // Open Bottom Sheet or perform camera-related action
                //         _showBottomSheet();
                //       },
                //       child: CircleAvatar(
                //         backgroundColor: Colors.transparent,
                //         backgroundImage: AssetImage('assets/images/photo_splash.jpg'),
                //         radius: 70,
                //         child: Icon(Icons.camera_alt, size: 30),
                //       ),
                //     ),),
                //   ),
                //   ],
                // ),

                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    'Welcome, ${user?.fullName ?? ''}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    ' ${user?.email ?? ''}',
                    style: TextStyle(color: Colors.black45, fontSize: 14),
                  ),
                ),
                //____________________________________________________

                SizedBox(height: 20),

                //____________________________________________________
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    'User Name',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                //_____________________________________--
                SizedBox(height: 5),
                //________________________________________
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Text_filed(
                    data: _nameController,
                  ),
                ),

                //--____________________________________________
                //_____________________________________--
                SizedBox(height: 25),
                //________________________________________
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    'Mobile Number',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                //_____________________________________________

                SizedBox(height: 5),
                //________________________________________
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Text_filed(
                    data: _numberController,
                  ),
                ),

                //__________________________________-

                SizedBox(height: 25),
                //________________________________________

                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    'E-mail',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                //________________________________________
                //_____________________________________--
                SizedBox(height: 5),
                //________________________________________

                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Text_filed(
                    data: _emailController,
                  ),
                ),
                //______________________________________________
                // Text(
                //   'Password',
                //   style: TextStyle(color: Colors.black, fontSize: 18),
                // ),
                //__________________________________________________

                // Text_filed(
                //   data: _passwordController,
                // ),
                // //_________________________________________________
                // Text(
                //   'Confirm Password',
                //   style: TextStyle(color: Colors.black, fontSize: 18),
                // ),
                //__________________________________________________

                // Text_filed(
                //   data: _confirmpasswordController,
                // ),
                //_________________________________________________
                // Save button
                //_____________________________________--
                SizedBox(height: 22),
                //________________________________________
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: InkWell(
                    onTap: () async {
                      // Create an updated user object
                      MyUser updatedUser = MyUser(
                        id: user!.id,
                        fullName: _nameController.text,
                        email: _emailController.text,
                        number: _numberController.text,
                      );

                      // Call clickOnSaveChanges to save changes
                      await userProvider.clickOnSaveChanges(updatedUser);

                      DialogUtiles.showMessage(context,
                          message: 'Your changes have been successfully saved',
                          dialogType: DialogType.success);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 60,
                      width: mediaQuery.width,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(190, 190, 190, 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Save Changes",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                // Container(
                //   height: 60,
                //   padding: EdgeInsets.only(left: 16,right: 16),
                //   child: ElevatedButton(
                //     style: ButtonStyle(
                //
                //
                //         backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(190, 190, 190,1))),
                //     onPressed: () async {
                //       // Create an updated user object
                //       MyUser updatedUser = MyUser(
                //         id: user!.id,
                //         fullName: _nameController.text,
                //         email: _emailController.text,
                //         number: _numberController.text,
                //       );
                //
                //       // Call clickOnSaveChanges to save changes
                //       await userProvider.clickOnSaveChanges(updatedUser);
                //
                //       DialogUtiles.showMessage(context,
                //           message: 'Your changes have been successfully saved',
                //           dialogType: DialogType.success);
                //
                //     },
                //     child: Text('Save Changes',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18)),),
                // )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: double.infinity,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Choose  Profile Photo '),
              ],
            ),
          );
        });
  }
}