import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showSnackBar({
  @required BuildContext context,
  String message,
  Widget messageText,
  String title,
  Widget titleText,
  Icon icon,
}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Flushbar(
      backgroundColor: Theme.of(context).primaryColor,
      message: message,
      messageText: messageText,
      title: title,
      titleText: titleText,
      icon: icon,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(8.0),
      borderRadius: 6.0,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    )..show(context);
  });
}
