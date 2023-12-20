import 'package:cme/app.dart';
import 'package:cme/ui_widgets/animation_background.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';

class Animation1 extends StatefulWidget {
  @override
  _Animation1State createState() => _Animation1State();
}

class _Animation1State extends State<Animation1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BattleAnimationScreen(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: boldText("Get Ready", color: white, size: 48)),
              Center(child: boldText("To Battle", color: white, size: 48)),
            ],
          )
        ],
      ),
    );
  }
}
