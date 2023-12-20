import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

List<Color> gradientColors = [
  // const Color(0xffB6091B),
  const Color.fromRGBO(182, 9, 27, 1),
];
LineChartData earningChartData() {
  return LineChartData(
    gridData: FlGridData(show: false),
    titlesData: FlTitlesData(show: false),
    borderData: FlBorderData(show: false),
    // minX: 0,
    // maxX: ,
    // minY: 0,
    // maxY: 70,
    lineBarsData: [
      LineChartBarData(
        spots: [
          FlSpot(0, 0),
          FlSpot(2.6, 2),
          FlSpot(3.5, 4),
          FlSpot(4.9, 2.5),
          FlSpot(6.8, 3.1),
          FlSpot(8, 4),
          FlSpot(9.1, 3),
          FlSpot(10.5, 2.1),
          FlSpot(11, 1),
        ],
        isCurved: false,
        color: gradientColors[0],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          color: gradientColors[0].withOpacity(0.3)
         ),
      ),
    ],
  );
}


