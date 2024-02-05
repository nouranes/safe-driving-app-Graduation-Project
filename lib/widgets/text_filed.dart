import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Text_filed extends StatefulWidget {
  TextEditingController data = TextEditingController();
  Function()? onEditSuccess;

  Text_filed({required this.data, this.onEditSuccess});

  @override
  _Text_filedState createState() => _Text_filedState();
}

class _Text_filedState extends State<Text_filed> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.data,
      style: TextStyle(color: Colors.black),
      readOnly: !isEditing,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: EdgeInsets.all(12.0),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              isEditing = !isEditing;
              if (!isEditing && widget.onEditSuccess != null) {
                // Trigger the callback when editing is successful
                widget.onEditSuccess!();
                updateUserInFirestore(widget.data.text);
              }
            });
          },
          child: Icon(
            Icons.edit,
            color: isEditing ? Colors.blue : Colors.grey,
          ),
        ),
        hintStyle: TextStyle(color: Colors.black),
        labelStyle: TextStyle(color: Colors.black),
      ),
    );
  }
}

Future<void> updateUserInFirestore(data) async {
  // Assuming you have a reference to the current user's document in Firestore
  // Replace 'yourUserId' with the actual user ID or current user ID
  String userId = 'yourUserId';

  try {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'name': data,
    });

    print('Data updated in Firestore');
  } catch (e) {
    print('Error updating data in Firestore: $e');
  }
}
