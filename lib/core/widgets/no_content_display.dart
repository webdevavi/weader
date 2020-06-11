import 'package:flutter/material.dart';

class NoContentDisplay extends StatelessWidget {
  final String title;
  final String message;
  final Widget action;

  const NoContentDisplay({
    Key key,
    @required this.title,
    @required this.message,
    this.action,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          Text(message, textAlign: TextAlign.center),
          SizedBox(height: 24.0),
          if (action != null) action,
        ],
      ),
    );
  }
}
