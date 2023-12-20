//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImagesStepper extends StatefulWidget {
  @override
  _ImagesStepperState createState() => _ImagesStepperState();
}
class _imageStepper {
  String imageUrl;
  AlignmentGeometry alignement = Alignment.center;

  _imageStepper(this.imageUrl, this.alignement);
}
class _ImagesStepperState extends State<ImagesStepper> {
  SharedPreferences? prefs;

  bool isLoading = false;

  List<_imageStepper> imageUrlList = [
    new _imageStepper("assets/cp1.jpg", Alignment.center),
    new _imageStepper("assets/cp2.jpg", Alignment.centerLeft),
    new _imageStepper("assets/cp3.jpg", Alignment.center)
  ];


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: ClipRRect(
       // borderRadius: BorderRadius.circular(16),
        child: Swiper(
          outer: false,
          curve: Curves.linearToEaseOut,
          loop: true,
          autoplay: true,
          autoplayDelay: 5000,
          indicatorLayout: PageIndicatorLayout.COLOR,
          itemCount: imageUrlList.length,
          itemBuilder: (b, index) {
            return Container(
                foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent.withOpacity(.1),
                        Colors.transparent.withOpacity(.3),
                        Colors.transparent.withOpacity(.7),
                        Colors.transparent.withOpacity(1),
                      ]),
                ),
                child:Image.asset(
              imageUrlList[index].imageUrl,
              fit: BoxFit.cover,
             alignment: imageUrlList[index].alignement,
             // width: double.infinity,
            ));
          },
        ),
      ),
    );
  }
}
