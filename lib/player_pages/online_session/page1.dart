import 'package:cme/app.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:flutter/material.dart';

class VideoSessionPage1 extends StatefulWidget {
  @override
  _VideoSessionPage1State createState() => _VideoSessionPage1State();
}

class _VideoSessionPage1State extends State<VideoSessionPage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeBkg,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Text(
                "Video Session",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Positioned(
              top: 24,
              left: 0,
              right: 0,
              bottom: 16,
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 0,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Card(
                              shadowColor: Colors.grey.withOpacity(.2),
                              shape: CircleBorder(),
                              color: Colors.white.withOpacity(.5),
                              elevation: 6,
                              child: Container(
                                height: 150,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 32,
                            bottom: 32,
                            left: 32,
                            right: 32,
                            child: Card(
                              shadowColor: Colors.grey.withOpacity(.2),
                              shape: CircleBorder(),
                              color: Colors.white.withOpacity(.6),
                              elevation: 6,
                              child: Container(
                                height: 100,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 16,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircularImage(
                                  imageUrl: "assets/mou.png",
                                  size: 72,
                                ),
                                Text(
                                  "Jose Mourinho",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Spacer(),
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: buildCallIcon(Icons.call_end, red, "Decline")),
                      horizontalSpace(width: 32),
                      InkWell(
                          onTap: () {
                            // pushRoute(context, VideoSesson2());
                            // Navigator.push(context,
                            //     NavigatePageRoute(context, VideoSesson2()));
                          },
                          child: buildCallIcon(Icons.call, blue, "Accept")),
                      Spacer(),
                    ],
                  ),
                  verticalSpace(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCallIcon(IconData icon, Color color, String text) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, color: Colors.white),
          ),
        ),
        verticalSpace(),
        Text(text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ))
      ],
    );
  }
}
