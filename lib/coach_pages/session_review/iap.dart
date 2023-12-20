import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/network/coach/booking_feedback.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetIAPPage extends StatefulWidget {
  final UserModel? userModel;
  final int? playerId;

  const SetIAPPage({
    Key? key,
    required this.userModel,
    required this.playerId,
  }) : super(key: key);
  @override
  _SetIAPPageState createState() => _SetIAPPageState();
}

class _SetIAPPageState extends State<SetIAPPage> {
  TextEditingController noteController = TextEditingController();
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: buildBaseScaffold(
          leftIcon: Icons.close,
          context: context,
          body: buildBody(context),
          title: "IAP"),
    );
  }

  double? ballControlVal = 10;
  double? diffSurfaceVal = 10;
  double? posessionVal = 10;
  double? positioningVal = 10;
  double? moveBallVal = 10;
  double? passingVal = 10;
  double? coorVal = 10;
  double? balanceVal = 10;

  Widget buildBody(BuildContext context) {
    return ListView(
      children: [
        boldText(
          "TECHNICAL",
          size: 18,
        ),
        verticalSpace(height: 10),
        buildSlider(
          sliderValue: ballControlVal!,
          title: "Ball Control",
          onChanged: (v) {
            setState(() {
              ballControlVal = v.roundToDouble();
            });
          },
        ),
        buildSlider(
          sliderValue: diffSurfaceVal!,
          title: "Using Different Surfaces",
          onChanged: (v) {
            setState(() {
              diffSurfaceVal = v.roundToDouble();
            });
          },
        ),
        buildSlider(
          sliderValue: posessionVal!,
          title: "Possession",
          onChanged: (v) {
            setState(() {
              posessionVal = v.roundToDouble();
            });
          },
        ),
        buildSlider(
          sliderValue: positioningVal!,
          title: "Positioning",
          onChanged: (v) {
            setState(() {
              positioningVal = v.roundToDouble();
            });
          },
        ),
        verticalSpace(height: 20),
        boldText(
          "PHYSICAL",
          size: 18,
        ),
        verticalSpace(height: 10),
        buildSlider(
          sliderValue: moveBallVal!,
          title: "Movement On/Off The Ball",
          onChanged: (v) {
            setState(() {
              moveBallVal = v.roundToDouble();
            });
          },
        ),
        buildSlider(
          sliderValue: passingVal!,
          title: "Passing",
          onChanged: (v) {
            setState(() {
              passingVal = v.roundToDouble();
            });
          },
        ),
        buildSlider(
          sliderValue: coorVal!,
          title: "Co-ordination",
          onChanged: (v) {
            setState(() {
              coorVal = v.roundToDouble();
            });
          },
        ),
        buildSlider(
          sliderValue: balanceVal!,
          title: "Balance",
          onChanged: (v) {
            setState(() {
              balanceVal = v.roundToDouble();
            });
          },
        ),
        verticalSpace(height: 20),
        mediumText("Note to Player (Optional)", size: 15),
        verticalSpace(height: 13),
        Container(
          padding: EdgeInsets.only(left: 16),
          height: 85,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromRGBO(206, 206, 206, 1),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: noteController,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(fontFamily: App.font_name, fontSize: 14),
                hintText: "Tell us about your experience"),
          ),
        ),
        verticalSpace(height: 40),
        proceedButton(
          isLoading: isLoading,
          text: "Submit AIP",
          onPressed: () => saveIap(context),
          color: Color.fromRGBO(25, 87, 234, 1), //rgba(25, 87, 234, 1)
        ),
      ],
    );
  }

  bool isLoading = false;
  saveIap(BuildContext context) async {
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    FocusScope.of(context).requestFocus(FocusNode());

    var r = await cocahCreateIAP(widget.userModel!.getAuthToken(),
        playerid: widget.playerId,
        ballcontrol: ballControlVal,
        differentSurface: diffSurfaceVal,
        possession: posessionVal,
        positioning: positioningVal,
        movement: moveBallVal,
        passing: passingVal,
        cordination: coorVal,
        balance: balanceVal,
        note: noteController.text);

    showSnack(context, "${r.message}");
    setState(() {
      isLoading = false;
    });

    if (r.status!) {
      await Future.delayed(Duration(seconds: 2));
      Navigator.pop(context);
    }
  }
}

// ignore: must_be_immutable
Widget buildSlider({required double sliderValue, onChanged, required title}) {
  var style = TextStyle(
    fontFamily: "ROBOTO",
    fontSize: 14,
  );
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      mediumText(title, size: 14),
      SizedBox(
        width: double.infinity,
        child: CupertinoSlider(
          min: 0,
          max: 10,
          divisions: 10,
          value: sliderValue,
          activeColor: deepRed,
          thumbColor: CupertinoColors.systemRed,
          onChanged: onChanged,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8),
        child: Row(
          children: <Widget>[
            Text(
              "0",
              style: style,
            ),
            Visibility(
              visible: sliderValue.toInt() > 1,
              child: Spacer(
                flex: 1 + sliderValue.toInt(),
              ),
            ),
            Visibility(
              visible: sliderValue.toInt() > 0 && sliderValue.toInt() < 10,
              child: Expanded(
                child: Center(
                  child: Text(
                    "$sliderValue",
                    style: style,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: sliderValue.toInt() < 9,
              child: Spacer(
                flex: 11 - sliderValue.toInt(),
              ),
            ),
            Text(
              "10",
              style: style,
            ),
          ],
        ),
      ),
    ],
  );
}
