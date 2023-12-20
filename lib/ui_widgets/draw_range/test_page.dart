import 'package:cme/app.dart';
import 'package:flutter/material.dart';
import 'dart:math' as m;

class TestPaintPage extends StatefulWidget {
  @override
  _TestPaintPageState createState() => _TestPaintPageState();
}

class _TestPaintPageState extends State<TestPaintPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeBkg,
      body: Center(
        child: Container(
          width: 320,
          height: 56,
          child: Stack(
            children: [
              Container(
                // color: blue,
                width: 120,
                height: 56,
              ),
              Transform.rotate(
                angle: m.pi,
                child: Container(
                  // color: white,
                  width: 320,
                  height: 56,
                  child: CustomPaint(
                    painter: CurvedPainter(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildGraph() {
  return Transform.rotate(
    angle: m.pi,
    child: Container(
      // color: white,
      width: double.infinity,
      height: 56,
      child: CustomPaint(
        painter: CurvedPainter(),
      ),
    ),
  );
}

class CurvedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    paint.color = Color.fromRGBO(245, 245, 245, 1); //green[800];rgba
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.70,
        size.width * 0.17, size.height * 0.90);
    path.quadraticBezierTo(
        size.width * 0.20, size.height, size.width * 0.25, size.height * 0.90);
    path.quadraticBezierTo(size.width * 0.40, size.height * 0.40,
        size.width * 0.50, size.height * 0.70);
    path.quadraticBezierTo(size.width * 0.60, size.height * 0.85,
        size.width * 0.65, size.height * 0.65);
    path.quadraticBezierTo(
        size.width * 0.70, size.height * 0.90, size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
    // canvas.drawColor(Colors.transparent.withOpacity(.5), BlendMode.color);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
