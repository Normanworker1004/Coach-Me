import 'package:cme/app.dart';
import 'package:flutter/material.dart';

class BattleAnimationScreen extends StatefulWidget {
  @override
  _BattleAnimationScreenState createState() => _BattleAnimationScreenState();
}

class _BattleAnimationScreenState extends State<BattleAnimationScreen> {
  int h1 = 0;
  int h2 = 0;
  int total = 60; //must be even
  int duration = 30;

  var blueDecoration = BoxDecoration(
    gradient: LinearGradient(
      tileMode: TileMode.repeated,
      colors: [
        deepBlue,
        Colors.blue[900]!,
        deepBlue,
      ],
    ),
  );

  var redDecoration = BoxDecoration(
    gradient: LinearGradient(
      tileMode: TileMode.repeated,
      colors: [
        red,
        deepRed,
        Color.fromRGBO(91, 4, 14, 1),
      ],
    ),
  );

  bool showDots = false;

  @override
  void initState() {
    super.initState();

    startAnimation();
  }

  startAnimation() async {
    setState(() {
      h1 = 0;
      h2 = 0;
    });
    for (var i = 0; i < total; i++) {
      setState(() {
        h1 += 1;
      });
      await Future.delayed(Duration(milliseconds: duration));
    }
    // print(".....$h2......");
    for (var i = 0; i < total; i++) {
      setState(() {
        h2 += 1;
      });
      await Future.delayed(Duration(milliseconds: duration));
    }

    await Future.delayed(Duration(microseconds: 20));
    setState(() {
      showDots = true;
    });
  }

  buildlayerTR() {
    return Stack(
      children: [
        ClipPath(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: redDecoration,
          ),
          clipper: TopRightClipPath(),
        ),
        Column(
          children: [
            Flexible(
              flex: h1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                // height: 200,
                color: Colors.transparent.withOpacity(0),
              ),
            ),
            Visibility(
              visible: h1 != total,
              child: Expanded(
                flex: total - h1,
                child: Container(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  buildlayerTL() {
    return Stack(
      children: [
        ClipPath(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: blueDecoration,
          ),
          clipper: TopLeftClipPath(),
        ),
        Column(
          children: [
            Visibility(
              visible: h2 != total,
              child: Expanded(
                flex: total - h2,
                child: Container(
                  color: Colors.white,
                ),
              ),
            ),
            Flexible(
              flex: h2,
              child: Container(
                width: MediaQuery.of(context).size.width,
                // height: 200,
                color: Colors.transparent.withOpacity(0),
              ),
            ),
          ],
        ),
      ],
    );
  }

  buildlayerBL() {
    return Stack(
      children: [
        ClipPath(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: blueDecoration,
          ),
          clipper: BottomLeftClipPath(),
        ),
        Column(
          children: [
            Visibility(
              visible: h1 != total,
              child: Expanded(
                flex: total - h1,
                child: Container(
                  color: Colors.white,
                ),
              ),
            ),
            Flexible(
              flex: h1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                // height: 200,
                color: Colors.transparent.withOpacity(0),
              ),
            ),
          ],
        ),
      ],
    );
  }

  buildlayerBR() {
    return Stack(
      children: [
        ClipPath(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: redDecoration,
          ),
          clipper: BottomRightClipPath(),
        ),
        Column(
          children: [
            Flexible(
              flex: h2,
              child: Container(
                width: MediaQuery.of(context).size.width,
                // height: 200,
                color: Colors.transparent.withOpacity(0),
              ),
            ),
            Visibility(
              visible: h2 != total,
              child: Expanded(
                flex: total - h2,
                child: Container(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeBkg,
      body: InkWell(
        onTap: () {
          startAnimation();
        },
        child: Stack(
          children: [
            buildAnimationBackground(),
            Visibility(
              visible: showDots,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 1000),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(60, (index) {
                    if (index > 30) {
                      index = (60 - index) % 30;
                    }
                    return buildMultipleDot(index);
                  }),
                ),
              ),
            ),
            Visibility(
              visible: showDots,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 1000),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(60, (index) {
                    if (index > 30) {
                      index = (60 - index) % 30;
                    }
                    return buildMultipleDot(index, reverse: true);
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAnimationBackground() {
    return Column(
      children: [
        Expanded(
            child: Container(
          child: Stack(
            children: [
              buildlayerTL(),
              buildlayerTR(),
            ],
          ),
        )),
        Expanded(
            child: Container(
          child: Stack(
            children: [
              buildlayerBR(),
              buildlayerBL(),
            ],
          ),
        )),
      ],
    );
  }
}

class TopLeftClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    var h = size.height;
    var w = size.width;
    path.lineTo(0, 0);
    path.lineTo(w * 3 / 5, 0);
    path.lineTo(w * 2 / 5, h);
    path.lineTo(0, h);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TopRightClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    var h = size.height;
    var w = size.width;
    path.lineTo(w * 3 / 5, 0);
    path.lineTo(w, 0);
    path.lineTo(w, h);
    path.lineTo(w * 2 / 5, h);
    path.lineTo(w * 3 / 5, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BottomLeftClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    var h = size.height;
    var w = size.width;
    path.lineTo(0, 0);
    path.lineTo(w * 3 / 5, 0);
    path.lineTo(w * 2 / 5, h);
    path.lineTo(0, h);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BottomRightClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    var h = size.height;
    var w = size.width;
    path.moveTo(w * 3 / 5, 0);
    path.lineTo(w, 0);
    path.lineTo(w, h);
    path.lineTo(w * 2 / 5, h);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Widget buildDot({color: Colors.blue, double? height, double? width}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      // shape: BoxShape.circle,
      borderRadius: BorderRadius.all(Radius.elliptical(4, 12)),

      color: color,
    ),
  );
}

Widget buildMultipleDot(int total, {reverse: false}) {
  return Row(
    mainAxisAlignment:
        reverse ? MainAxisAlignment.end : MainAxisAlignment.start,
    children: List.generate(
        total,
        (index) => Padding(
              padding: const EdgeInsets.all(2.0),
              child: buildDot(
                color: reverse
                    ? Color.fromRGBO(125, 7, 17, 1)
                    : Color.fromRGBO(51, 118, 124, 1), //125,7,17
                height: reverse
                    ? (total * index / 55)
                    : (total * (total - index) / 55),
                width: //total * (total - index)

                    total * index / 300,
              ),
            )),
  );
}

class OvalClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    // var h = size.height;
    // var w = size.width;
    path.addOval(
      Rect.fromCircle(center: Offset(0, 0), radius: radius),
    );
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
