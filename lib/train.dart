import 'package:final_project/widgets/text_form_filed.dart';
import 'package:flutter/material.dart';

class train extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        GestureDetector(
            onTap: () {},
            child: Custom_Form_Field(
              hint: 'vmmbmbm',
            ))
      ],
    ));
  }
}
