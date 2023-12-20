import 'package:cme/app.dart';
import 'package:cme/model/player_performance_stats.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';

class HoursOfTrainingGraph extends StatelessWidget {
  final domainAxisColor;
  final primaryAxisColor;
  static const defaultAxisColor = Color(0xFFFFFFFF);
  final HoursOfTrainingStats? statsData;
  // final statsData;

  HoursOfTrainingGraph(
      {this.domainAxisColor = defaultAxisColor,
      this.primaryAxisColor = defaultAxisColor,
      this.statsData});

  @override
  Widget build(BuildContext context) {
    print("datta goal.....${statsData!.data}");
    List<String> primaryAxisLabels = [
      "100%",
      "75%",
      "50%",
      "25%",
      "",
    ];

    List<String> domainAxisLabels = ["", "w1", "w2", "w3", "w4", ""];

    // List<int> l2 = [4, 5, 3, 2];
    List<int> currentData = [
      statsData?.week1?.weekSum.round() ?? 0,
      statsData?.week2?.weekSum.round() ?? 0,
      statsData?.week3?.weekSum.round() ?? 0,
      statsData?.week4?.weekSum.round() ?? 0,
    ];
    return Container(
      padding: EdgeInsets.only(top: 16, right: 8),
      width: double.infinity,
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                        primaryAxisLabels.length,
                        (index) => rLightText(
                          primaryAxisLabels[index],
                          color: white,
                        ),
                      ) +
                      [verticalSpace(height: 4)],
                ),
              ),
              Expanded(
                flex: 90,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8.0),
                        //color: Colors.transparent,
                        decoration: BoxDecoration(
                            border: Border(
                          left: BorderSide(
                            color: primaryAxisColor,
                          ),
                          bottom: BorderSide(
                            color: domainAxisColor,
                          ),
                        )),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            domainAxisLabels.length,
                            (index) => rLightText(
                              domainAxisLabels[index],
                              color: white,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              color: blue,
                              width: 10,
                              height: 10,
                            ),
                            horizontalSpace(),
                            rLightText('Completed', color: white),
                            horizontalSpace(width: 16),
                            Container(
                              color: red,
                              width: 10,
                              height: 10,
                            ),
                            horizontalSpace(),
                            rLightText('Target', color: white),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 40),
            child: Row(
              children: [
                Expanded(flex: 10, child: horizontalSpace(width: 0)),
                Expanded(
                  flex: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (index) {
                        // return buildBar(uncompleted: 2, completed: currentData[index]);
                        return buildBar(
                            uncompleted: ((statsData?.target?.round() ?? 0) -
                                currentData[index]),
                            completed: currentData[index]);
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildBar({required uncompleted, required completed}) {
    return Container(
      width: 16,
      child: Flex(
        direction: Axis.vertical,
        children: [
          Flexible(
            flex: completed,
            child: Container(
              decoration: BoxDecoration(
                  color: red, borderRadius: BorderRadius.circular(4)),
              width: 5,
            ),
          ),
          verticalSpace(height: 3),
          Flexible(
            flex: uncompleted,
            child: Container(
              decoration: BoxDecoration(
                  color: blue, borderRadius: BorderRadius.circular(4)),
              width: 5,
            ),
          )
        ],
      ),
    );
  }
}

class _GraphAxis extends StatelessWidget {
  final List<String> l = [
    "100%",
    "75%",
    "50%",
    "25%",
    "",
  ];

  final List<int> l2 = [2, 5, 3, 2];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                l.length,
                (index) => rLightText(
                  l[index],
                  color: white,
                ),
              ),
            ),
            Container(
              color: white,
              width: 8,
            ),
          ],
        ),
        Container(
          color: white,
          height: 2,
        ),
      ],
    );
  }
}
