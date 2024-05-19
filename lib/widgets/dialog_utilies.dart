import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class DialogUtiles {
  static void showLoading(BuildContext context, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.bottomSlide,
      body: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(
            width: 12,
          ),
          Text(message, style: TextStyle(color: Color(0xFF083663))),
        ],
      ),
    )..show();
  }

  static void hideLoading(BuildContext context) {
    AwesomeDialog(context: context).dismiss();
  }

  static void showMessage(
    BuildContext context, {
    required String message,
    String title = 'Title',
    String? posActionName,
    // Function? posAction,
    DialogType? dialogType,
  }) {
    Color? btnOkColor;

    if (dialogType == DialogType.error) {
      btnOkColor = Colors.red;
    } else if (dialogType == DialogType.success) {
      btnOkColor = Colors.green;
    }
    AwesomeDialog(
      context: context,
      dialogType: dialogType ?? DialogType.success,
      animType: AnimType.bottomSlide,
      headerAnimationLoop: false,
      desc: message,
      btnOkText: posActionName ?? 'OK',
      btnOkColor: btnOkColor,
    )..show();
  }
}
