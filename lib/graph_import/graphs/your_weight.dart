import 'package:cme/app.dart';
import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'charts_adapters/chart_data_model.dart';
import 'charts_adapters/week_data_chart.dart';
import 'charts_adapters/month_data_chart.dart';
import 'charts_adapters/year_data_chart.dart';

class WeightChart extends StatelessWidget {
  // final List earnings;
  final Period period;
  final int? target;

  Widget? graph;

  final List<WeeklyStatsDataModel> weeklyData = [
    new WeeklyStatsDataModel(300, day: WeekDays.Mo.index),
    new WeeklyStatsDataModel(500, day: WeekDays.Tu.index),
    new WeeklyStatsDataModel(800, day: WeekDays.We.index),
    new WeeklyStatsDataModel(1200, day: WeekDays.Th.index),
    new WeeklyStatsDataModel(1700, day: WeekDays.Fr.index),
    new WeeklyStatsDataModel(1500, day: WeekDays.Sa.index),
    new WeeklyStatsDataModel(1300, day: WeekDays.Su.index),
  ];

  final List<StatsDataModel> monthlyData = [
    new StatsDataModel(new DateTime(2020, 9, 1), 800),
    new StatsDataModel(new DateTime(2020, 9, 3), 1150),
    new StatsDataModel(new DateTime(2020, 9, 7), 1350),
    new StatsDataModel(new DateTime(2020, 9, 12), 1800),
    new StatsDataModel(new DateTime(2020, 9, 18), 1750),
    new StatsDataModel(new DateTime(2020, 9, 23), 1500),
    new StatsDataModel(new DateTime(2020, 9, 28), 1700),
  ];

  final List<StatsDataModel> yearlyData = [
    new StatsDataModel(new DateTime(2020, 1), 800),
    new StatsDataModel(new DateTime(2020, 2), 1150),
    new StatsDataModel(new DateTime(2020, 3), 1350),
    new StatsDataModel(new DateTime(2020, 4), 1800),
    new StatsDataModel(new DateTime(2020, 5), 1750),
    new StatsDataModel(new DateTime(2020, 6), 1500),
    new StatsDataModel(new DateTime(2020, 7), 1700),
  ];

  WeightChart({required this.period, this.target}) {
    switch (period) {
      case Period.WEEKLY:
        graph =
            WeekDataChart(_createWeeklySeriesList(weeklyData), animate: true);
        break;
      case Period.MONTHLY:
        graph = MonthDataChart(
          _createMonthlySeriesList(monthlyData),
          animate: true,
          month: new DateTime(2020, 9),
        );
        break;
      case Period.YEARLY:
        graph = YearDataChart(_createYearlySeriesList(yearlyData),
            animate: true, year: new DateTime(2020, 9, 28).year);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      // color: Colors.black45,
      child: graph,
    );
  }

  List<charts.Series<WeeklyStatsDataModel, int>> _createWeeklySeriesList(
      List<WeeklyStatsDataModel> earnings) {
    return [
      new charts.Series<WeeklyStatsDataModel, int>(
        id: 'WeeklyData',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (WeeklyStatsDataModel sales, _) => sales.day,
        measureFn: (WeeklyStatsDataModel sales, _) => sales.amount,
        data: earnings,
      )
    ];
  }

  List<charts.Series<StatsDataModel, DateTime>> _createMonthlySeriesList(
      List<StatsDataModel> earnings) {
    return [
      new charts.Series<StatsDataModel, DateTime>(
        id: 'MonthlyData',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (StatsDataModel sales, _) => sales.date ?? DateTime.now(),
        measureFn: (StatsDataModel sales, _) => sales.amount,
        data: earnings,
      )
    ];
  }

  List<charts.Series<StatsDataModel, DateTime>> _createYearlySeriesList(
      List<StatsDataModel> earnings) {
    return [
      new charts.Series<StatsDataModel, DateTime>(
        id: 'YearlyData',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (StatsDataModel sales, _) => sales.date ?? DateTime.now(),
        measureFn: (StatsDataModel sales, _) => sales.amount,
        radiusPxFn: (StatsDataModel sales, _) => 5,
        strokeWidthPxFn: (StatsDataModel sales, _) => 2,
        data: earnings,
        labelAccessorFn: (StatsDataModel sales, _) => sales.amount.toString(),
      )
    ];
  }
}
