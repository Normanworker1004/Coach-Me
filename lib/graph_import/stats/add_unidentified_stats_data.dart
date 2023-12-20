import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/fetch_player_stats_response.dart';
import 'package:cme/network/player_stats/fetchplayerstats.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';

class AddUnidentifiedDataScren extends StatefulWidget {
  final UserModel? userModel;
  final StatDetails statDetail;
  final onSave;

  const AddUnidentifiedDataScren({
    Key? key,
    required this.userModel,
    required this.statDetail,
    required this.onSave,
  }) : super(key: key);
  @override
  _AddUnidentifiedDataScrenState createState() =>
      _AddUnidentifiedDataScrenState();
}

class _AddUnidentifiedDataScrenState extends State<AddUnidentifiedDataScren> {
  TextEditingController controller = TextEditingController();

  UserModel? userModel;

  FocusNode? fNode;
  late StatDetails statDetail;
  @override
  void initState() {
    super.initState();

    userModel = widget.userModel;
    statDetail = widget.statDetail;
    fNode = FocusNode();
    fNode!.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
    fNode!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
    /*ScopedModelDescendant<UserModel>(
      builder: (i, j, model) {
        userModel = model;
        return buildBaseScaffold(
            lrPadding: 0,
            bottomPadding: 0,
            color: themeBkg,
            context: context,
            body: buildBody(context),
            title: "Stats");
      },
    );*/
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      // direction: Axis.vertical,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(text: "How many "),
                TextSpan(
                  text: " ${statDetail.goal}?",
                  style: TextStyle(
                    color: Color.fromRGBO(182, 9, 27, 1),
                  ),
                ),
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
        SizedBox(
          width: double.infinity,
          // height: 581,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            child: Card(
              margin: EdgeInsets.all(0),
              child: Padding(
                padding: const EdgeInsets.only(top: 45),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16,
                      ),
                      child: Column(
                        children: [
                          verticalSpace(height: 16),
                          Container(
                            height: 72,
                            width: 137,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              textBaseline: TextBaseline.alphabetic,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              children: <Widget>[
                                Expanded(
                                  child: TextField(
                                    onChanged: (a) {
                                      setState(() {});
                                    },
                                    onEditingComplete: () {
                                      setState(() {});
                                    },
                                    keyboardType: TextInputType.number,
                                    focusNode: fNode,
                                    controller: controller,
                                    style: TextStyle(
                                      fontFamily: App.font_name2,
                                      fontSize: 48,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          verticalSpace(height: 16),
                        ],
                      ),
                    ),
                    verticalSpace(
                        height: fNode!.hasFocus
                            ? 32
                            : MediaQuery.of(context).size.height * .4),
                    Visibility(
                      visible: false,
                      child: Expanded(
                        child:
                        Text("Flutter Gauge to replace !! ")
                        // Container(
                        //   child: FlutterGauge(
                        //     hand: Hand.long,
                        //     width: MediaQuery.of(context).size.width * .75,
                        //     index: 58.0,
                        //     end: 130,
                        //     start: 50,
                        //     counterStyle: TextStyle(
                        //       color: Colors.black,
                        //       fontSize: 25,
                        //     ),
                        //     widthCircle: 35,
                        //     secondsMarker: SecondsMarker.none,
                        //     numberInAndOut: NumberInAndOut.outside,
                        //     number: Number.all,
                        //   ),
                        // ),
                      ),
                    ),
                    Container(
                      height: 80,
                      width: double.infinity,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                height: 60,
                                width: 121,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32)),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      // pushRoute(
                                      //     context,
                                      //     PlayerStatsPage(
                                      //       userModel: userModel,
                                      //     ));
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      if (controller.text.isNotEmpty) {
                                        addPlayerPerformanceStatsData(
                                            data: controller.text,
                                            statid: statDetail.id,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.arrow_forward)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            bottom: 16,
                            right: 16,
                            child: Center(
                              child: InkWell(
                                  onTap: () => widget.onSave,
                                  child: mediumText("Skip", size: 19)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(height: 64),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
