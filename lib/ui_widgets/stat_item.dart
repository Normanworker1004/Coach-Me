import 'package:cme/app.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';

class StatItem extends StatefulWidget {
  final String title;
  final String current;
  final String target;
  final String img;
  final Widget chart;
  final bool hidetarget;
  final bool hideTop;

  const StatItem({
    Key? key,
    this.hideTop: false,
    required this.chart,
    required this.title,
    required this.current,
    required this.target,
    required this.img,
    this.hidetarget = false,
  }) : super(key: key);
  @override
  _StatItemState createState() => _StatItemState();
}

class _StatItemState extends State<StatItem> {
  List<String> l = [
    "Weekly",
    "Month",
    "Year",
  ];
  bool isEdit = false;
  int catIndex = 1;
  @override
  Widget build(BuildContext context) {
    return isEdit ? buildEdit() : buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return buildContainer(
        child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent.withOpacity(.8),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                boldText(widget.title, color: Colors.white, size: 24),
                // verticalSpace(),
                Visibility(
                  visible: !widget.hideTop,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        3,
                        (index) => InkWell(
                          onTap: () {
                            setState(() {
                              catIndex = index;
                            });
                          },
                          child: catIndex == index
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Color.fromRGBO(26, 87, 234, 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: lightText(
                                      l[index].toUpperCase(),
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                )
                              : boldText(
                                  l[index].toUpperCase(),
                                  color: Colors.white,
                                  size: 14,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                widget.chart,
                Visibility(
                  visible: !widget.hidetarget,
                  child: Row(
                    children: [
                      RichText(
                        textAlign: TextAlign.right,
                        text: TextSpan(children: [
                          TextSpan(
                            text: "${widget.current}\n",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: "Current",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                      ),
                      Spacer(),
                      RichText(
                        textAlign: TextAlign.right,
                        text: TextSpan(children: [
                          TextSpan(
                            text: "${widget.target}\n",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: "Target",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Divider(color: white),
          Container(
            color: white,
            width: double.infinity,
            height: 1,
          ),
          Flex(
            direction: Axis.horizontal,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    border: Border(right: BorderSide(color: white)),
                  ),
                  child: TextButton(
                      style:TextButton.styleFrom(
                      textStyle: TextStyle(color: white)
                      ),
                       onPressed: () {
                        setState(() {
                          isEdit = !isEdit;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/edit_red.png",
                            width: 12,
                            height: 12,
                            color: white,
                          ),
                          horizontalSpace(),
                          Text("Edit"),
                        ],
                      )),
                ),
              ),
              VerticalDivider(
                color: white,
              ),
              Expanded(
                child: TextButton(
                    style:TextButton.styleFrom(
                        textStyle: TextStyle(color: white)
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/stats_share.png",
                          width: 12,
                          height: 12,
                          color: white,
                        ),
                        horizontalSpace(),
                        Text("Share"),
                      ],
                    )),
              ),
            ],
          )
        ],
      ),
    ));
  }

  Widget buildContainer({Widget? child}) {
    return Container(
      child: child,
      // height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
            image: AssetImage(widget.img),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(deepBlue, BlendMode.color)),
      ),
    );
  }

  Widget buildEdit() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color.fromRGBO(3, 12, 30, 1) //rgba(3, 12, 30, 1)
          ),
      child: Column(
        children: [
          verticalSpace(height: 8),
          Center(child: boldText(widget.title, size: 24, color: white)),
          verticalSpace(height: 16),
          Row(
            children: [
              Text("Target",
                  style: TextStyle(
                    fontFamily: App.font_name,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: white,
                  )),
              Spacer(),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, 4, 8, 4),
                  decoration: BoxDecoration(
                      border: Border.all(color: white),
                      borderRadius: BorderRadius.circular(8)),
                  child: rLightText(widget.target, color: white, size: 16),
                ),
              ),
            ],
          ),
          verticalSpace(),
          Row(
            children: [
              Text("Tip",
                  style: TextStyle(
                    fontFamily: App.font_name,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: white,
                  )),
              horizontalSpace(),
              Tooltip(
                decoration: BoxDecoration(color: Colors.white),
                textStyle: TextStyle(
                  fontFamily: App.font_name,
                  color: Colors.black,
                  fontSize: 12,
                ),
                message:
                    "Expert: High level qualifications/ High level experience as a COACH i.e. 10 years +\n"
                    "Professional: Advanced level qualifications or coaching/playing experience 5 years +\n"
                    "Intermediate: General level qualification or coaching/playing experience 2 years+\n"
                    "Beginner: entry level qualification or coaching/playing experience 1 year+\n",
                child: Image.asset(
                  "assets/info_red.png",
                  height: 12,
                  color: Colors.red,
                  width: 12,
                ),
              )
            ],
          ),
          verticalSpace(),
          RichText(
            text: TextSpan(
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: App.font_name,
                    fontWeight: FontWeight.w100),
                children: [
                  TextSpan(text: "You need "),
                  TextSpan(
                      text: "52 Sessions",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          " your current rate of £100 to achieve your target"),
                ]),
          ),
          verticalSpace(height: 64),
          proceedButton(
              text: "Save",
              onPressed: () {
                setState(() {
                  isEdit = !isEdit;
                });
              }),
        ],
      ),
    );
  }
}
