import 'package:cme/app.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';

class ChallegeGetReady extends StatefulWidget {
  @override
  _ChallegeGetReadyState createState() => _ChallegeGetReadyState();
}

class _ChallegeGetReadyState extends State<ChallegeGetReady> {
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
                "VS",
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          Positioned(
            top: 64,
            left: 64,
            child: Text("jbnkj"),
          ),
          Positioned(
            bottom: 64,
            right: 64,
            child: Center(
              child: boldText(
                "VS",
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
