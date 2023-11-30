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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: secureText,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: hint,
          hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 15,
              fontWeight: FontWeight.w400),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.white)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        style: TextStyle(color: Color(0xFF083663)),
        validator: validator,
      ),
    );
  }
}
