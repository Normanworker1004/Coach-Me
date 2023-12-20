import 'package:cme/app.dart';
import 'package:cme/model/subdetail.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';

Widget buildSubCard(SubDetail d) {
  return Column(
    children: <Widget>[
      ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Card(
            color: d.color,
            margin: EdgeInsets.all(0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      boldText(d.type, size: 19, color: Colors.white),
                      Spacer(),
                      Text(
                        d.perMonth!,
                        style: TextStyle(
                            fontFamily: "ROBOTO",
                            color: white,
                            fontSize: 12,
                            fontWeight: FontWeight.w100),
                      ),
                    ],
                  ),
                  verticalSpace(),
                  Row(
                    children: <Widget>[
                      Text(
                        d.price!,
                        style: TextStyle(
                            fontFamily: "ROBOTO",
                            color: white,
                            fontSize: 12,
                            fontWeight: FontWeight.w100),
                      ),
                      Spacer(),
                      lightText("Billed " + d.billType!,
                          size: 12, color: Colors.white),
                    ],
                  ),
                  verticalSpace(height: 16),
                  lightText(
                    "Additional Features",
                    color: Colors.white,
                    size: 16,
                  ),
                  verticalSpace(height: 4),
                  buildIconText("assets/hand-shake.png", d.entitlement1),
                  buildIconText("assets/vs.png", d.entitlement2),
                  Visibility(
                    child: Column(
                      children: [
                        buildIconText(
                            "assets/more-horiz.png", "More cool features 1"),
                        buildIconText(
                            "assets/more-horiz.png", "More cool features 2"),
                        buildIconText(
                            "assets/more-horiz.png", "More cool features 3"),
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
      verticalSpace(height: 16),
    ],
  );
}

Widget buildIconText(String icon, text) {
  return Row(
    children: <Widget>[
      Image.asset(icon, width: 30, height: 25),
      horizontalSpace(width: 5),
      Expanded(
        child: lightText(
          text,
          size: 14,
          color: Colors.white,
        ),
      ),
    ],
  );
}

class SubscribtionInfoCard extends StatefulWidget {
  final SubDetail? d;
  final bool isCurrent;

  const SubscribtionInfoCard({
    Key? key,
    this.d,
    this.isCurrent: false,
  }) : super(key: key);

  @override
  _SubscribtionInfoCardState createState() => _SubscribtionInfoCardState();
}

class _SubscribtionInfoCardState extends State<SubscribtionInfoCard> {
  bool showMore = false;
  @override
  Widget build(BuildContext context) {
    if(widget.d?.expendedMoreFeatures ?? false ){
      showMore = true;
    }
    return Column(
      children: <Widget>[
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.d!.color,
                  borderRadius: BorderRadius.circular(16),
                  border: widget.isCurrent ? Border.all(color: red) : null,
                ),
                margin: EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          boldText(widget.d!.type,
                              size: 19, color: Colors.white),
                          Spacer(),
                          Text(
                            widget.d!.perMonth!,
                            style: TextStyle(
                                fontFamily: "ROBOTO",
                                color: white,
                                fontSize: 12,
                                fontWeight: FontWeight.w100),
                          ),
                        ],
                      ),
                      verticalSpace(),
                      Row(
                        children: <Widget>[
                          Text(
                            widget.d!.price!,
                            style: TextStyle(
                                fontFamily: "ROBOTO",
                                color: white,
                                fontSize: 12,
                                fontWeight: FontWeight.w100),
                          ),
                          Spacer(),
                          // lightText("Billed " + widget.d!.billType!,
                          //     size: 12, color: Colors.white),
                        ],
                      ),
                      verticalSpace(height: 16),
                      Text(
                        "Additional Features",
                        style: TextStyle(
                            fontFamily: "ROBOTO",
                            color: white,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w100),
                      ),


                      verticalSpace(height: 4),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showMore = !showMore;
                          });
                        },
                        child: Column(
                          children: [
                            buildIconText(
                                "assets/hand-shake.png", widget.d!.entitlement1),
                            buildIconText(
                                "assets/vs.png", widget.d!.entitlement2),
                            !showMore
                                ? buildIconText("assets/more-horiz.png",
                                    "More cool features")
                                : Visibility(
                                    visible: showMore,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 35),
                                      child: Column(
                                        children:
                                        List.generate(
                                          widget.d!.moreFeatureList.length,
                                          (index) => Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.baseline,
                                                textBaseline: TextBaseline.alphabetic,
                                            children: [
                                              Icon(
                                                Icons.circle,
                                                size: 9,
                                                color: Colors.white,
                                              ),
                                              horizontalSpace(width: 4),
                                              Expanded(
                                                child: lightText(
                                                  widget.d!.moreFeatureList[index],
                                                  size: 14,
                                                  color: Colors.white,
                                                  maxLines: 10
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Visibility(
                visible: widget.isCurrent,
                child: Card(
                  margin: EdgeInsets.all(0),
                  shape: CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.check,
                      size: 14,
                      color: Color.fromRGBO(182, 9, 27, 1),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // verticalSpace(height: 16),
      ],
    );
  }
}
