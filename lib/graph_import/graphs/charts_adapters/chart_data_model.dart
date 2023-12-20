
/// Sample linear data type.
class StatsDataModel {
  final DateTime? date;
  final double amount;

  StatsDataModel(this.date, this.amount);
}

class WeeklyStatsDataModel extends StatsDataModel {
  final int day;
  final double amount;

  ///
  /// [day] specify the day of the week, its value can either be 0,1,2,3,4,5,6
  ///
  WeeklyStatsDataModel(this.amount, {required this.day}) : super(null, amount);
}

enum WeekDays { Mo, Tu, We, Th, Fr, Sa, Su }
