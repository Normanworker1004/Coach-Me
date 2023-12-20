import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';

import '../../../app.dart';

class GoalsScoredGraph extends StatelessWidget {
  final int current;
  final int target;
  final String start;
  final String end;

  GoalsScoredGraph(
      {required this.current,
      required this.target,
      required this.start,
      required this.end});

  @override
  Widget build(BuildContext context) {
    final double strokeWidth = (target > 50) ? 2 : 4;
    return Column(
      children: [
        Opacity(
          opacity: 0.6,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff2C2C2C),
                  Color(0xff1957EA),
                  Color(0xffC6091B),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                    current,
                    (index) => Expanded(
                      child: Padding(
                        padding: (target > 50)
                            ? const EdgeInsets.only(right: 2)
                            : const EdgeInsets.only(right: 4),
                        child: Container(
                            height: 78, color: Colors.black, width: 1),
                      ),
                    ),
                  ) +
                  [
                    Expanded(
                      flex: target - current,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: Container(
                            height: 78, color: Colors.black, width: 1),
                      ),
                    ),
                  ],
            ),
          ),
        ),
        verticalSpace(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            mediumText(
              "Start: $start",
              color: white,
              size: 12,
            ),
            mediumText(
              "end: $end",
              color: white,
              size: 12,
            ),
          ],
        ),
        verticalSpace(height: 33)
      ],
    );
  }
}
