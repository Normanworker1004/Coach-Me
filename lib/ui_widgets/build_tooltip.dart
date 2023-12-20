import 'package:cme/app.dart';
import 'package:flutter/material.dart';
import 'package:simple_tooltip/simple_tooltip.dart';

class CustomToolTip extends StatefulWidget {
  final Widget child;
  final Widget icon;

  const CustomToolTip({Key? key, required this.child, required this.icon})
      : super(key: key);
  @override
  _CustomToolTipState createState() => _CustomToolTipState();
}

class _CustomToolTipState extends State<CustomToolTip> {
  bool show = false;
  @override
  Widget build(BuildContext context) {
    return SimpleTooltip(
      tooltipTap: () {
        setState(() {
          show = !show;
        });
      },
      // maxWidth: double.infinity,
      borderColor: Colors.white,
      borderWidth: 1,
      animationDuration: Duration(seconds: 0),
      show: show,
      tooltipDirection: TooltipDirection.down,
      child: InkWell(
          onTap: () {
            setState(() {
              show = !show;
            });
          },
          child: Container(padding: EdgeInsets.only(top: 10,right: 10, bottom: 10),  child: widget.icon)),
      content: widget.child,
    );
  }
}

Widget buildToolTip() {
  return CustomToolTip(
    icon: Image.asset(
      "assets/info.png",
      height: 15,
      width: 15,
    ),
    child: Container(
      width: 300,
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: App.font_name,
          ),
          children: [
            TextSpan(
              text: "Coach Level Help\n\n",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            TextSpan(
              text: "Expert: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            TextSpan(
                text:
                    "High level qualifications/ High level experience as a COACH i.e. 10 years + \n\n"),
            TextSpan(
              text: "Professional: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            TextSpan(
                text:
                    "Advanced level qualifications or coaching/playing experience 5 years +  \n\n"),
            TextSpan(
              text: "Intermediate: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            TextSpan(
                text:
                    "General level qualification or coaching/playing experience 2 years+ \n\n"),
            TextSpan(
              text: "Beginner: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            TextSpan(
                text:
                    "entry level qualification or coaching/playing experience 1 year+\n\n"),
          ],
        ),
      ),
    ),
  );
}

Widget buildToolTipWithText({String? text}) {
  return CustomToolTip(
    icon: Image.asset(
      "assets/info.png",
      height: 15,
      width: 15,
    ),
    child: Container(
      width: 300,
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: App.font_name,
          ),
          children: [
            TextSpan(
              text: "$text",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
