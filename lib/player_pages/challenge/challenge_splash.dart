import 'package:cme/app.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';

class ChallengeSplash extends StatefulWidget {
  @override
  _ChallengeSplashState createState() => _ChallengeSplashState();
}

class _ChallengeSplashState extends State<ChallengeSplash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Container(color: deepBlue)),
              Expanded(child: Container(color: Colors.red)),
            ],
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: boldText(
                "Getting Ready \nTo Battle",
                color: Colors.white,
                size: 32,
              ),
            ),
          )
        ],
      ),
    );
  }
}
