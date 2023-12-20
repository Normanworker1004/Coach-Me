import 'package:cme/model/fetch_player_home_booking_response.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

LineChartData sampleData1(PlayerStatisticsItem hourData) {
  List<FlSpot> spots = hourData == null
      ? [
          FlSpot(0, 0),
        ]
      : hourData.playerstatistics!.isEmpty
          ? [
              FlSpot(0, 0),
            ]
          : List.generate(
              hourData.playerstatistics!.length,
              (index) => FlSpot(
                index / .5,
                hourData.playerstatistics![index].mydata! / 1.0 ,
              ),
            );
  return LineChartData(
      lineTouchData: LineTouchData(enabled: false) ,
    gridData: FlGridData(show: false),
    titlesData: FlTitlesData(show: false),
    borderData: FlBorderData(show: false),
    lineBarsData: linesBarData1(spots),
  );
}

List<LineChartBarData> linesBarData1(spots) {
  final LineChartBarData lineChartBarData = LineChartBarData(
    spots: spots,
    isCurved: true,
    color:   Colors.white,
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
  );
  return [
    lineChartBarData,
  ];
}
