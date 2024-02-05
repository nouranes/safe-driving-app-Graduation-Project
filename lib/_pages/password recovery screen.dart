import 'package:flutter/material.dart';

class PasswordRecoveryScreen extends StatelessWidget {
  static const String routeName = 'passwordRecovery';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Recovery'),
      ),
      body: Center(
        child: Text('Password recovery page content'),
      ),
    );
  }
}
