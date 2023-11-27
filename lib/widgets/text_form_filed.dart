import 'package:flutter/material.dart';

class Custom_Form_Field extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final bool secureText;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;

  Custom_Form_Field({
    this.controller,
    required this.hint,
    this.secureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: secureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Color(0xFF083663)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Color(0xFF083663)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Color(0xFF083663)),
        ),
      ),
      style: TextStyle(color: Color(0xFF083663)),
      validator: validator,
    );
  }
}
