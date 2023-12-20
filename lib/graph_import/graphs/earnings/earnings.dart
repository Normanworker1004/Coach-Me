
/// Sample linear data type.
class EarningsModel {
  final DateTime? date;
  final double amount;

  EarningsModel(this.date, this.amount);
}

class WeeklyEarningsModel extends EarningsModel {
  final int day;
  final double amount;

  ///
  /// [day] specify the day of the week, its value can either be 0,1,2,3,4,5,6
  ///
  WeeklyEarningsModel(this.amount, {required this.day}) : super(null, amount);
}

enum WeekDays { Mo, Tu, We, Th, Fr, Sa, Su }
