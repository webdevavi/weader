import 'package:flutter/material.dart';

void showCustomBottomSheet({
  @required BuildContext context,
  @required String title,
  @required String subtitle,
  @required List<Widget> actions,
  @required void Function() onClosing,
}) {
  Scaffold.of(context).showBottomSheet((context) => BottomSheet(
        elevation: 6.0,
        builder: (_) {
          return Container(
            padding: EdgeInsets.only(
              top: 24.0,
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
                Text(subtitle),
                SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions,
                ),
              ],
            ),
          );
        },
        onClosing: onClosing,
      ));
}
