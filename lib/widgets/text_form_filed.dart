import 'package:flutter/material.dart';

class Custom_Form_Field extends StatefulWidget {
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
  _Custom_Form_FieldState createState() => _Custom_Form_FieldState();
}

class _Custom_Form_FieldState extends State<Custom_Form_Field> {
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    obscureText = widget.secureText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white),
          ),
          // Show visibility toggle only for the password field
          suffixIcon: widget.secureText
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                )
              : null,
        ),
        style: TextStyle(color: Color(0xFF083663)),
        validator: widget.validator,
      ),
    );
  }
}