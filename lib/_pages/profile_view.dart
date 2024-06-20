import 'package:final_project/_pages/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:final_project/_pages/user_provider.dart';
import 'package:final_project/widgets/text_filed.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:final_project/widgets/dialog_utilies.dart';
import 'package:final_project/login&regisrer/register_data.dart';

class Profile_View extends StatefulWidget {
  static const String routeName = 'profile';

  @override
  State<Profile_View> createState() => _Profile_ViewState();
}

class _Profile_ViewState extends State<Profile_View> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _numberController = TextEditingController();

  bool isEditing = false;
  double? userRating;

  @override
  void initState() {
    super.initState();

    MyUser? user = Provider.of<UserProvider>(context, listen: false).user;

    // Check if user is not null
    if (user != null) {
      // Fetch user data from Firestore and update the UI
      DataBaseUtiles.getUser(user.id).then((MyUser? updatedUser) async {
        if (updatedUser != null) {
          // Calculate rating if the user's email contains "@uber"
          if (updatedUser.email.contains('@uber')) {
            double averagePercentage = (updatedUser.drowsyPercentage +
                    updatedUser.noSeatBeltPercentage +
                    updatedUser.distractedPercentage) /
                3;
            updatedUser.rating = _calculateRating(averagePercentage);
            userRating = updatedUser.rating;

            // Update the rating in Firebase
            await Provider.of<UserProvider>(context, listen: false).clickOnSaveChanges(updatedUser);
          }

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

  double _calculateRating(double averagePercentage) {
    if (averagePercentage >= 90) return 5.0;
    if (averagePercentage >= 75) return 4.0;
    if (averagePercentage >= 50) return 3.0;
    if (averagePercentage >= 25) return 2.0;
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subTextColor = isDarkMode ? Colors.white70 : Colors.black45;

    var mediaQuery = MediaQuery.of(context).size;

    // Use Consumer to rebuild the widget when user data changes
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        // Access the user data from the provider
        final user = userProvider.user;
        print('User in Profile_View: $user');

        return Scaffold(
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
                              child: CircleAvatar(
                                radius: 75,
                                child: Icon(Icons.camera_alt, size: 30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (userRating != null)
                  Padding(
                    padding: EdgeInsets.only(top: 13.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        userRating!.toInt(),
                        (index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    'Welcome, ${user?.fullName ?? ''}',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    '${user?.email ?? ''}',
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    "10".tr,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Text_filed(
                    data: _nameController,
                    textColor: textColor,
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    "11".tr,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Text_filed(
                    data: _numberController,
                    textColor: textColor,
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    "12".tr,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Text_filed(
                    data: _emailController,
                    textColor: textColor,
                  ),
                ),
                SizedBox(height: 22),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: InkWell(
                    onTap: () async {
                      // Create an updated user object
                      MyUser updatedUser = MyUser(
                        id: user!.id,
                        fullName: _nameController.text.isEmpty
                            ? user.fullName
                            : _nameController.text,
                        email: _emailController.text.isEmpty
                            ? user.email
                            : _emailController.text,
                        number: _numberController.text.isEmpty
                            ? user.number
                            : _numberController.text,
                        journeyHistory: user.journeyHistory,
                        drowsyPercentage: user.drowsyPercentage,
                        noSeatBeltPercentage: user.noSeatBeltPercentage,
                        distractedPercentage: user.distractedPercentage,
                      );

                      // Calculate rating if the user's email contains "@uber"
                      if (updatedUser.email.contains('@uber')) {
                        double averagePercentage = (updatedUser.drowsyPercentage +
                                updatedUser.noSeatBeltPercentage +
                                updatedUser.distractedPercentage) /
                            3;
                        updatedUser.rating =
                            _calculateRating(averagePercentage);
                        setState(() {
                          userRating = updatedUser.rating;
                        });

                        // Update the rating in Firebase
                        await userProvider.clickOnSaveChanges(updatedUser);
                      }

                      // Call clickOnSaveChanges to save changes
                      await userProvider.clickOnSaveChanges(updatedUser);

                      DialogUtiles.showMessage(context,
                          message: "13".tr, dialogType: DialogType.success);
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
                        "14".tr,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                ),
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
                Text("15".tr),
              ],
            ),
          );
        });
  }
}
