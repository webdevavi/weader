import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepOrange,
      child: Center(
        child: Image.asset(
          'assets/logo.png',
          width: 100.0,
          height: 100.0,
        ),
      ),
    );
  }
}
