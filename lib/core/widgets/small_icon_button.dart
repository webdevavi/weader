import 'package:flutter/material.dart';

class SmallIconButton extends StatelessWidget {
  final void Function() onPressed;
  final Icon icon;

  const SmallIconButton({
    Key key,
    @required this.onPressed,
    @required this.icon,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: Material(
        color: Colors.transparent,
        child: IconButton(
          onPressed: onPressed,
          icon: icon,
        ),
      ),
    );
  }
}
