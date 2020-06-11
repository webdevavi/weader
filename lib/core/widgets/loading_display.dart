import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class LoadingDisplay extends StatelessWidget {
  final String message;

  const LoadingDisplay({
    Key key,
    this.message = "Loading...",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            child: Stack(
              children: <Widget>[
                Image.asset(
                  "assets/weader_icon.png",
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                FlareActor(
                  "assets/loading.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: "loading",
                ),
              ],
            ),
          ),
          SizedBox(height: 24.0),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
