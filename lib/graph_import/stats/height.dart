import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/fetch_player_stats_response.dart';
import 'package:cme/network/player_stats/fetchplayerstats.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';

class HeightInputPage extends StatefulWidget {
  final UserModel? userModel;
  final StatDetails statDetail;
  final onSave;

  const HeightInputPage({
    Key? key,
    required this.userModel,
    required this.statDetail,
    required this.onSave,
  }) : super(key: key);
  @override
  _HeightInputPageState createState() => _HeightInputPageState();
}

class _HeightInputPageState extends State<HeightInputPage> {
  // ScrollController heightController;
  UserModel? userModel;

  final feetController = TextEditingController();
  // final inchController = TextEditingController();

  List<String> list = [
    "CM",
    "FT",
  ];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // heightController = ScrollController(initialScrollOffset: 20000);
    userModel = widget.userModel;
  }

  @override
  void dispose() {
    super.dispose();
    // heightController.dispose();

    feetController.dispose();
    // inchController.dispose();
  }

  void handleHeightScaleChanged(int scalePoints) {
    /// scale only understands scale points.
    /// So we need to convert scale points into our measurement unit by dividing scale point with 20.
    ///  i.e measurement unit = scale point / 20.
    int inchOffest = scalePoints ~/ 20;
    int feet = inchOffest ~/ 10;
    int inch = inchOffest % 10;

    feetController.text = feet.toString();
    // inchController.text = inch.toString();

    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: buildBaseScaffold(
          lrPadding: 0,
          bottomPadding: 78,
          color: themeBkg,
          context: context,
          body: buildBody(context),
          title: "Stats"),
    );
  }

  Widget buildBody(BuildContext context) {
    return Container(
      child: ListView(
        // direction: Axis.vertical,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(text: "How "),
                  TextSpan(
                    text: "tall ",
                    style: TextStyle(
                      color: Color.fromRGBO(182, 9, 27, 1),
                    ),
                  ),
                  TextSpan(text: "are you?"),
                ],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: App.font_name),
              ),
            ),
          ),
          Spacer(),
          Container(
            width: double.infinity,
            height: 581,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              child: Container(
                color: white,
                margin: EdgeInsets.all(0),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 45, right: 16, left: 16.0),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 38,
                        width: 251,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(16)),
                        // width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24.0, right: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              list.length,
                              (index) => Padding(
                                padding: EdgeInsets.only(
                                    right: index == 0 ? 64.0 : 0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      // selectedIndex = index;
                                    });
                                  },
                                  child: boldText(
                                    "${list[index]}",
                                    size: 13,
                                    color: index == selectedIndex
                                        ? Colors.black
                                        : Colors.black.withOpacity(.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      verticalSpace(height: 16),
                      /* Container(
                        height: 72,
                        width: 137,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Row(
                          textBaseline: TextBaseline.alphabetic,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: <Widget>[
                            rLightText("165", size: 60),
                            horizontalSpace(width: 4),
                            mediumText("${list[selectedIndex]}",
                                color: red, size: 15)
                          ],
                        ),
                      ),
                      */

                      Container(
                        height: 72,
                        width: 137,
                        child: Center(
                          child: TextField(
                            controller: feetController,
                            style: TextStyle(fontSize: 48),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '0',
                              suffixText: "${list[selectedIndex]}",
                              suffixStyle: TextStyle(
                                color: red,
                                fontSize: 15,
                              ),
                              border: OutlineInputBorder(),
                            ),
                            //onSubmitted: _heightChangeScale(),
                          ),
                        ),
                      ),
                      verticalSpace(height: 21),
                      Expanded(
                        child: Card(
                          child: Container(
                              child:
                              Text("Flutter Scale to replace !! ")


                          //         VerticalScale(
                          //   onChanged: handleHeightScaleChanged,
                          //   pointer: RotatedBox(
                          //       quarterTurns: 1,
                          //       child: Image.asset('assets/football.png')),
                          //   lineColor: Colors.grey,
                          //   linesBetweenTwoPoints: 9,
                          //   middleLineAt: 5,
                          //   maxValue: 190,
                          //   scaleColor: Colors.white,
                          //   scaleController:
                          //       ScrollController(initialScrollOffset: 20000),
                          // )

                              ),
                        ),
                      ),
                      verticalSpace(height: 32),
                      Row(
                        children: <Widget>[
                          Spacer(),
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(32)),
                            child: ElevatedButton(
                              onPressed: () {
                                // pushRoute(context, WeightInputPage());
                                if (feetController.text.isNotEmpty) {
                                  addPlayerPerformanceStatsData(
                                      data: feetController.text,
                                      statid: widget.statDetail.id,
                                      token: userModel!.getAuthToken()!);
                                }
                                widget.onSave();
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                textStyle: TextStyle(color: Colors.white),
                                primary: Color.fromRGBO(182, 9, 27, 1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[Icon(Icons.arrow_forward)],
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          lightText("Skip", size: 20),
                          horizontalSpace(width: 20)
                        ],
                      ),
                      verticalSpace(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

/*
class HeightInputPage extends StatefulWidget {
  @override
  _HeightInputPageState createState() => _HeightInputPageState();
}

class _HeightInputPageState extends State<HeightInputPage> {
  // ScrollController heightController;

  final feetController = TextEditingController();
  // final inchController = TextEditingController();

  List<String> list = [
    "CM",
    "FT",
  ];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // heightController = ScrollController(initialScrollOffset: 20000);
  }

  @override
  void dispose() {
    super.dispose();
    // heightController.dispose();

    feetController.dispose();
    // inchController.dispose();
  }

  void handleHeightScaleChanged(int scalePoints) {
    /// scale only understands scale points.
    /// So we need to convert scale points into our measurement unit by dividing scale point with 20.
    ///  i.e measurement unit = scale point / 20.
    int inchOffest = scalePoints ~/ 20;
    int feet = inchOffest ~/ 10;
    int inch = inchOffest % 10;

    feetController.text = feet.toString();
    // inchController.text = inch.toString();

    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: buildBaseScaffold(
          lrPadding: 0,
          bottomPadding: 78,
          color: themeBkg,
          context: context,
          body: buildBody(context),
          title: "Stats"),
    );
  }

  Widget buildBody(BuildContext context) {
    return Container(
      child: ListView(
        // direction: Axis.vertical,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(text: "How "),
                  TextSpan(
                    text: "tall ",
                    style: TextStyle(
                      color: Color.fromRGBO(182, 9, 27, 1),
                    ),
                  ),
                  TextSpan(text: "are you?"),
                ],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: App.font_name),
              ),
            ),
          ),
          Spacer(),
          Container(
            width: double.infinity,
            height: 581,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              child: Container(
                color: white,
                margin: EdgeInsets.all(0),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 45, right: 16, left: 16.0),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 38,
                        width: 251,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(16)),
                        // width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24.0, right: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              list.length,
                              (index) => Padding(
                                padding: EdgeInsets.only(
                                    right: index == 0 ? 64.0 : 0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      // selectedIndex = index;
                                    });
                                  },
                                  child: boldText(
                                    "${list[index]}",
                                    size: 13,
                                    color: index == selectedIndex
                                        ? Colors.black
                                        : Colors.black.withOpacity(.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      verticalSpace(height: 16),
                      /* Container(
                        height: 72,
                        width: 137,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Row(
                          textBaseline: TextBaseline.alphabetic,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: <Widget>[
                            rLightText("165", size: 60),
                            horizontalSpace(width: 4),
                            mediumText("${list[selectedIndex]}",
                                color: red, size: 15)
                          ],
                        ),
                      ),
                      */

                      Container(
                        height: 72,
                        width: 137,
                        child: Center(
                          child: TextField(
                            controller: feetController,
                            style: TextStyle(fontSize: 48),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '0',
                              suffixText: "${list[selectedIndex]}",
                              suffixStyle: TextStyle(
                                color: red,
                                fontSize: 15,
                              ),
                              border: OutlineInputBorder(),
                            ),
                            //onSubmitted: _heightChangeScale(),
                          ),
                        ),
                      ),
                      verticalSpace(height: 21),
                      Expanded(
                        child: Card(
                          child: Container(
                              child:

                                  // selectedIndex == 0
                                  //     ?
                                  VerticalScale(
                            onChanged: handleHeightScaleChanged,
                            pointer: RotatedBox(
                                quarterTurns: 1,
                                child: Image.asset('assets/football.png')),
                            lineColor: Colors.grey,
                            linesBetweenTwoPoints: 9,
                            middleLineAt: 5,
                            maxValue: 190,
                            scaleColor: Colors.white,
                            scaleController:
                                ScrollController(initialScrollOffset: 20000),
                          )
                              //     :
                              //     VerticalScale(
                              //   onChanged: handleHeightScaleChanged,
                              //   pointer: RotatedBox(
                              //       quarterTurns: 1,
                              //       child: Image.asset('assets/football.png')),
                              //   lineColor: Colors.grey,
                              //   linesBetweenTwoPoints: 11,
                              //   middleLineAt: 6,
                              //   maxValue: 7,
                              //   scaleColor: Colors.white,
                              //   scaleController:
                              //       ScrollController(initialScrollOffset: 0),
                              // ),
                              ),
                        ),
                      ),
                      verticalSpace(height: 32),
                      Row(
                        children: <Widget>[
                          Spacer(),
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(32)),
                            child: RaisedButton(
                              onPressed: () {
                                // pushRoute(context, WeightInputPage());
                              },
                              elevation: 0,
                              textColor: Colors.white,
                              color: Color.fromRGBO(182, 9, 27, 1),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[Icon(Icons.arrow_forward)],
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          lightText("Skip", size: 20),
                          horizontalSpace(width: 20)
                        ],
                      ),
                      verticalSpace(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
*/
