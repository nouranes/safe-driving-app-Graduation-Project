import 'package:flutter/material.dart';

class Info_Card extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function() onPressed;

  Info_Card({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white38,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ListTile(
        trailing: GestureDetector(
          onTap: onPressed,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        title: Text(text,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            )),
      ),
    );
  }
}
