import 'package:cme/app.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';



class SessionCompletedMeter extends StatefulWidget {

  int? completed;
  int? total;


  SessionCompletedMeter({this.completed = 1, this.total = 1}) {

  }

  @override
  _SessionCompletedMeterState createState() => _SessionCompletedMeterState();
}

class _SessionCompletedMeterState extends State<SessionCompletedMeter> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16),
      child: Container(
        height: 287,
        width: double.infinity,
        child: Container(
          child: Column(
            children: [
              verticalSpace(height: 25),
              SleekCircularSlider(
                innerWidget: (t) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/logo_solo.png",
                          height: 60,
                          width: 60,
                          // scale: .5,
                        ),
                      ),
                      verticalSpace(),
                      rBoldText("${widget.completed} out of ${widget.total}", size: 24, color: white),
                      mediumText("Sessions", size: 14, color: white)
                    ],
                  );
                },
                appearance: CircularSliderAppearance(
                  size: 220,
                  customColors: CustomSliderColors(
                    dotColor: red,
                    shadowColor: Colors.transparent,
                    progressBarColor: red,
                    trackColor: white,
                  ),
                ),
                onChange: (double value) {
                  // print(value);
                },
                initialValue: widget.completed?.toDouble() ?? 1,
                min: 0,
                max: widget.total?.toDouble() ?? 5,
              ),
              Container(
                color: white,
                height: 1,
                width: double.infinity,
              ),
              verticalSpace(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/stats_share.png",
                    width: 10,
                    height: 10,
                  ),
                  horizontalSpace(width: 4),
                  mediumText(
                    "Share",
                    color: white,
                    size: 14,
                  ),
                ],
              ),
              verticalSpace(),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromRGBO(3, 12, 30, 1).withOpacity(.89),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage("assets/stats12.png"),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
