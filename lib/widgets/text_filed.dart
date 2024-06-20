import 'package:flutter/material.dart';

class Text_filed extends StatelessWidget {
  final TextEditingController data;
  final Color textColor;

  Text_filed({required this.data, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: data,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: textColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: textColor),
        ),
      ),
    );
  }
}
