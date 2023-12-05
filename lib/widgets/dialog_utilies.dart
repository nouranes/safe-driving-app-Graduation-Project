import 'package:flutter/material.dart';

class DialogUtiles {
  static void showLoading(BuildContext context, String message) {
    showDialog(
        //barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 12,
                ),
                Text(message, style: TextStyle(color: Color(0xFF083663))),
              ],
            ),
          );
        });
  }

  static void hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessage(
    BuildContext context, {
    required String message,
    String title = 'Title',
    String? posActionName,
    Function? posAction,
  }) {
    List<void> actions = [];
    if (posActionName != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            posAction?.call();
          },
          child: Text('ok', style: TextStyle(color: Color(0xFF083663)))));
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message, style: TextStyle(color: Color(0xFF083663))),
          title: Text(title, style: TextStyle(color: Color(0xFF083663))),
        );
      },
    );
  }
}
