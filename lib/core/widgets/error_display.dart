import 'package:flutter/material.dart';

class ErrorDisplay extends StatelessWidget {
  final String message;

  const ErrorDisplay({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Icon(
                    Icons.info_outline,
                    color: Colors.redAccent,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    message + '!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
