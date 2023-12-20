import 'package:cme/app.dart';
import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'earnings.dart';
import 'earnings_weekly_chart.dart';
import 'earnings_monthly_chart.dart';
import 'earnings_yearly_chart.dart';

class EarningsChart extends StatelessWidget {
  // final List earnings;
  final Period period;
  double? target = 0;

  Widget? graph;

  List<WeeklyEarningsModel>? weeklyEarnings = [
    new WeeklyEarningsModel(300, day: WeekDays.Mo.index),
    new WeeklyEarningsModel(500, day: WeekDays.Tu.index),
    new WeeklyEarningsModel(800, day: WeekDays.We.index),
    new WeeklyEarningsModel(1200, day: WeekDays.Th.index),
    new WeeklyEarningsModel(1700, day: WeekDays.Fr.index),
    new WeeklyEarningsModel(1500, day: WeekDays.Sa.index),
    new WeeklyEarningsModel(1300, day: WeekDays.Su.index),
  ];

  List<EarningsModel>? monthlyEarnings = [
    new EarningsModel(new DateTime(2020, 9, 1), 800),
    new EarningsModel(new DateTime(2020, 9, 3), 1150),
    new EarningsModel(new DateTime(2020, 9, 7), 1350),
    new EarningsModel(new DateTime(2020, 9, 12), 1800),
    new EarningsModel(new DateTime(2020, 9, 18), 1750),
    new EarningsModel(new DateTime(2020, 9, 23), 1500),
    new EarningsModel(new DateTime(2020, 9, 28), 1700),
  ];

  List<EarningsModel>? yearlyEarnings = [
    new EarningsModel(new DateTime(2020, 1), 800),
    new EarningsModel(new DateTime(2020, 2), 1150),
    new EarningsModel(new DateTime(2020, 3), 1350),
    new EarningsModel(new DateTime(2020, 4), 1800),
    new EarningsModel(new DateTime(2020, 5), 1750),
    new EarningsModel(new DateTime(2020, 6), 1500),
    new EarningsModel(new DateTime(2020, 7), 1700),
  ];

  EarningsChart(
      {required this.period,
      this.target,
      this.weeklyEarnings,
      this.monthlyEarnings,
      this.yearlyEarnings}) {
    if (target == null) target = 0;
    switch (period) {
      case Period.WEEKLY:
        graph = EarningsWeeklyChart(
          _createWeeklySeriesList(weeklyEarnings!),
          animate: true,
          target: target! / 52,
        );
        break;
      case Period.MONTHLY:
        graph = EarningsMonthlyChart(
          _createMonthlySeriesList(monthlyEarnings!),
          animate: true,
          target: target! / 12,
        );
        break;
      case Period.YEARLY:
        graph = EarningsYearlyChart(
          _createYearlySeriesList(yearlyEarnings!),
          animate: true,
          target: target,
        );
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

  List<charts.Series<WeeklyEarningsModel, int>> _createWeeklySeriesList(
      List<WeeklyEarningsModel> earnings) {
    return [
      new charts.Series<WeeklyEarningsModel, int>(
        id: 'WeeklyEarnings',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (WeeklyEarningsModel sales, _) => sales.day,
        measureFn: (WeeklyEarningsModel sales, _) => sales.amount,
        data: earnings,
      )
    ];
  }

  List<charts.Series<EarningsModel, DateTime?>> _createMonthlySeriesList(
      List<EarningsModel> earnings) {
    return [
      new charts.Series<EarningsModel, DateTime?>(
        id: 'MonthlyEarnings',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (EarningsModel sales, _) => sales.date,
        measureFn: (EarningsModel sales, _) => sales.amount,
        data: earnings,
        labelAccessorFn: (EarningsModel sales, _) => sales.date!.day.toString(),
      )
    ];
  }

  List<charts.Series<EarningsModel, DateTime?>> _createYearlySeriesList(
      List<EarningsModel> earnings) {
    return [
      new charts.Series<EarningsModel, DateTime?>(
        id: 'YearlyEarnings',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (EarningsModel sales, _) => sales.date,
        measureFn: (EarningsModel sales, _) => sales.amount,
        radiusPxFn: (EarningsModel sales, _) => 5,
        strokeWidthPxFn: (EarningsModel sales, _) => 2,
        data: earnings,
      )
    ];
  }
}
