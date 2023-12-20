import 'package:cme/app.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_echarts/flutter_echarts.dart';

Widget buildCustomRange({
  initial: "10\£",
  finalText: null,
  startText: "150\£",
  endText: "600\£",
  symbol: "\£",
  min: 20,
  max: 30,
  double minLimit: 0,
  double maxLimit: 250000000,
  double graphWidget: 150,
  required onChanged,
  required context,
  required onChangeStart,
  required onChangeEnd,
}) {
  Color grey = Color.fromRGBO(153, 153, 153, 1);
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Column(
      children: [
        Container(
          height: graphWidget,
          width: double.infinity,
          child:


          Stack(
            fit: StackFit.passthrough,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: AspectRatio(
                  aspectRatio: 1.70,
                  child: IgnorePointer(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: LineChart(
                        mainData(graphWidget, minLimit, maxLimit, min*1.0, max*1.0),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                // width: double.infinity,
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Row(
                    children: [
                      rMediumText("$minLimit$symbol", color: grey, maxLines: 1),
                      // Spacer(),
                      Visibility(
                        visible: min > minLimit,
                        child: Expanded(
                          flex: min,
                          child: rMediumText(
                            "$min$symbol",
                            color: blue,
                            maxLines: 1,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      Spacer(
                        flex: max - min,
                      ),
                      Visibility(
                        visible: max < maxLimit,
                        child: Expanded(
                          flex: maxLimit.floor() - max as int,
                          child: rMediumText(
                            "$max$symbol",
                            color: blue,
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      // Spacer(),
                      rMediumText("${finalText ??  "$maxLimit$symbol"}", color: grey, maxLines: 1),
                    ],
                  ),
                ),
              ),
              Positioned(
                // width: double.infinity,
                bottom: 6,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: RangeSlider(
                    min: minLimit,
                    max: maxLimit,
                    inactiveColor: Colors.white,
                    activeColor: Color.fromRGBO(25, 87, 234, 1),
                    values: RangeValues(min / 1.0, max / 1.0),
                    onChanged: onChanged,
                    onChangeStart: onChangeStart,
                    onChangeEnd: onChangeStart,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

LineChartData mainData(double width, double limitMin, double limitMax , double min, double max) {
  List<Color> gradientColors = [const Color(0xFF1957EA),const Color(0x519B9B9B)];
  var step = (limitMax -limitMin) / 9 ;
  var dList = [
    FlSpot(0, 0),
    FlSpot(step*2, 3.5),
    FlSpot(step*3, 3),
    FlSpot(step*4, 6),
    FlSpot(step*5, 5),
    FlSpot(step*6, 2),
    FlSpot(step*7, 2.5),
    FlSpot(step*8, 1),
    FlSpot(step*9, 0),
  ];
  print("limitMax:: ${limitMax}");
  print("limitMin:: ${limitMin}");
  print("step:: ${step}");
  print("min:: ${min}");
  print("max:: ${max}");

  List<Color> cList = [] ;
  for(double i=0; i<9; i= i + 0.3 ){
      if(step * i < min || step * i > max ){cList = [...cList,gradientColors[1]];}
      else cList = [...cList,gradientColors[0]];
  }
  return




    LineChartData(
    gridData: FlGridData(
      show: false,
      drawVerticalLine: false,
      drawHorizontalLine: false,
      getDrawingHorizontalLine: (value) {
        return FlLine();
      },
      getDrawingVerticalLine: (value) {
        return FlLine();
      },
    ),
    titlesData: FlTitlesData(
      show: false,
      bottomTitles: AxisTitles(),
      leftTitles: AxisTitles(),
    ),
    borderData: FlBorderData(
      show: false,
    ),
    minX: limitMin,
    maxX: limitMax,
    minY: 0,
    maxY: 6,
    lineBarsData: [
      LineChartBarData(
        spots: List.generate(dList.length, (index) {
          var d = dList[index];
          return FlSpot(d.x , d.y);
          return FlSpot(d.x / 3 * 11, d.y / 7 * 4.5);
        }),
        isCurved: true,
        barWidth: 0,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(show: true,
            color: gradientColors[0],
            gradient: LinearGradient(
              colors: cList,
              tileMode: TileMode.clamp
  ),
        ),

            gradient: LinearGradient(
  colors: [
  gradientColors[0],
  gradientColors[1],
  ],
  stops: const [0,80],
  ),


      ),

    ],
  );
}
