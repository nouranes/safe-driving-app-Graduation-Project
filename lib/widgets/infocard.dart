import 'package:flutter/material.dart';

class Info_Card extends StatelessWidget {
  final String text;
  final IconData icon;

  Info_Card({
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: Colors.white38,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.black,
          ),
          title: Text(text,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              )),
        ),
      ),
    );
  }
}
