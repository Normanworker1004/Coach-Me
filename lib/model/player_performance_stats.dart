import 'package:cme/graph_import/graphs/charts_adapters/chart_data_model.dart';
import 'package:flutter/material.dart';

class PlayerPerformanceStat {
  int? id;
  int? userId;
  String? category;
  String? goal;
  double? target;
  double _current = 0;
  bool homeStats = false;
  Map<DateTime, int?>? data = {};
  List<WeeklyStatsDataModel>? weekly;
  List<StatsDataModel>? monthly;
  List<StatsDataModel>? yearly;

  PlayerPerformanceStat({
    required this.goal,
    required this.target,
    this.category,
    this.data,
    this.id,
    this.userId,
  }) {
    collectData();
  }

  get current {
    int currTotal = 0;

    data?.forEach((key, value) {currTotal += value ?? 0; });
    return currTotal.toDouble();
  }

  void collectData() {
    weekly = getWeeklyData().values.first;
    monthly = getMonthlyData().values.first;
    yearly = getYearlyData().values.first;
  }

  Map<DateTimeRange, List<WeeklyStatsDataModel>> getWeeklyData() {
    List<WeeklyStatsDataModel> weekData = [];
    DateTime currentDay = DateTime.now();
    int weekday = currentDay.weekday;
    DateTime weekStarts = DateTime(
        currentDay.year, currentDay.month, currentDay.day - weekday + 1);
    DateTime weekEnds =
        DateTime(currentDay.year, currentDay.month, weekStarts.day + 7);
    DateTimeRange week = DateTimeRange(start: weekStarts, end: weekEnds);
    if (data != null && data != {})
      data!.forEach((key, value) {
        if (key.isAfter(weekStarts) && key.isBefore(weekEnds)) {
          weekData
              .add(WeeklyStatsDataModel(value!.toDouble(), day: key.weekday));
        }
      });

    return {week: weekData};
  }

  Map<DateTimeRange, List<StatsDataModel>> getMonthlyData() {
    List<StatsDataModel> monthData = [];
    DateTime currentDay = DateTime.now();
    DateTime monthStarts = DateTime(currentDay.year, currentDay.month);
    DateTime monthEnds = DateTime(currentDay.year, currentDay.month + 1, 0);
    DateTimeRange month = DateTimeRange(start: monthStarts, end: monthEnds);
    if (data != null && data != {})
      data!.forEach((key, value) {
        if (key.isAfter(monthStarts) && key.isBefore(monthEnds)) {
          monthData.add(StatsDataModel(key, value!.toDouble()));
        }
      });

    return {month: monthData};
  }

  double _getMonthSum(DateTime month) {
    double monthSum = 0;
    data!.forEach((key, value) {
      if (key.isAtSameMomentAs(month)) {
        monthSum += value!.toDouble();
      }
    });

    return monthSum;
  }

  Map<DateTimeRange, List<StatsDataModel>> getYearlyData() {
    List<StatsDataModel> yearData = [];
    DateTime currentDay = DateTime.now();
    DateTime monthStarts = DateTime(currentDay.year, 1);
    DateTime monthEnds = DateTime(currentDay.year, 12, 31);
    DateTimeRange year = DateTimeRange(start: monthStarts, end: monthEnds);
    if (data != null && data != {})
      for (int month = 1; month <= currentDay.month; month++) {
        yearData.add(StatsDataModel(DateTime(currentDay.year, month),
            _getMonthSum(DateTime(currentDay.year, month))));
      }

    return {year: yearData};
  }
}

class HoursOfTrainingStats extends PlayerPerformanceStat {
  String? goal = "Hours of Training";
  List<StatsDataModel>? monthly;
  _HoursOfTrainingWeekData? week1;
  _HoursOfTrainingWeekData? week2;
  _HoursOfTrainingWeekData? week3;
  _HoursOfTrainingWeekData? week4;

  HoursOfTrainingStats(List<StatsDataModel> monthlyStats, double target) : super(goal:  "", target: target) { //TODO CHANGE GOAL AND TARGET HERE TO BE DYN
    monthly = monthlyStats;
    collectData();
  }

  @override
  void collectData() {
    // monthly = getMonthlyData().values.first;
    if (monthly != null && monthly!.length >= 1) {
      DateTime firstDay =
          DateTime(monthly!.first.date!.year, monthly!.first.date!.month, 1);
      int firstDayWeekday = firstDay.weekday;
      DateTime firstMonday = DateTime(firstDay.year, firstDay.month,
          firstDay.day + (7 - firstDayWeekday + 1));
      DateTimeRange week1Dates = DateTimeRange(
          start: firstMonday, end: firstMonday.add(Duration(days: 7)));
      DateTimeRange week2Dates = DateTimeRange(
          start: week1Dates.end, end: week1Dates.end.add(Duration(days: 7)));
      DateTimeRange week3Dates = DateTimeRange(
          start: week2Dates.end, end: week2Dates.end.add(Duration(days: 7)));
      DateTimeRange week4Dates = DateTimeRange(
          start: week3Dates.end, end: week3Dates.end.add(Duration(days: 7)));

      week1 = _HoursOfTrainingWeekData(week1Dates, _getWeekSum(week1Dates));
      week2 = _HoursOfTrainingWeekData(week2Dates, _getWeekSum(week2Dates));
      week3 = _HoursOfTrainingWeekData(week3Dates, _getWeekSum(week3Dates));
      week4 = _HoursOfTrainingWeekData(week4Dates, _getWeekSum(week4Dates));

    }
  }

  double _getWeekSum(DateTimeRange week) {
    double sum = 0;
    monthly!.forEach((element) {
      if (element.date!.isAfter(week.start) && element.date!.isBefore(week.end))
        sum += element.amount;
    });
    return sum;
  }
}

class _HoursOfTrainingWeekData {
  DateTimeRange weekRange;
  double weekSum;

  _HoursOfTrainingWeekData(this.weekRange, this.weekSum);
}
