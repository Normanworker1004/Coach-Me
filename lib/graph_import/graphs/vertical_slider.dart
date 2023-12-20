import 'package:flutter/material.dart';

class VerticalSlider extends StatefulWidget {
  @override
  _VerticalSliderState createState() => _VerticalSliderState();
}

class _VerticalSliderState extends State<VerticalSlider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vertical Slider Test'),
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: RotatedBox(
            quarterTurns: 1,
            child: Slider(value: 10.0, onChanged: null),
          ),
        ),
      ),
    );
  }
}
