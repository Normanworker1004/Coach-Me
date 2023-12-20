

import 'package:jiffy/jiffy.dart';

class BookingDates {
  DateTime? date;
  // List<String> sessionTime;
  List<DateTime>? bookingTimes;

  BookingDates(this.date,  { required this.bookingTimes});

  BookingDates.fromJson(Map<String, dynamic> json) {
    date = convertStringToDate(json['date']);
 
  
  }

  Map<String, dynamic> toJson() {
    
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = converDateToString(this.date);
   
    return data;
  }

  String converDateToString(DateTime? date) {
    return date == null ? "01-01-1999" : Jiffy(date).format("dd-mm-yyyy");
  }

  DateTime convertStringToDate(String? date) {
    if (date == null) {
      return DateTime(1999);
    }
    var d = date.split("-");
    var dd = List.generate(d.length, (index) => int.parse(d[index]));
    return DateTime(dd.last, dd[1], dd.first);
  }
}
