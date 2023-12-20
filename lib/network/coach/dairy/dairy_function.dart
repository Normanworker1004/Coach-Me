import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/utils/date_functions.dart';

class DairyData {
  String? dataTime;
  String? fromTime;
  String? toTime;
  String? booking;
  String? bookingLocation;
  dynamic other;
  Userdetails? playerDetails;
  List<DateTime>? dateTimes;

  DairyData({
    this.dataTime,
    this.fromTime,
    this.toTime,
    this.booking,
    this.other,
    this.playerDetails,
    this.dateTimes,
    this.bookingLocation,
  });

  DairyData.fromJson(Map<String, dynamic> json) {
    dataTime = json['data_time'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
    booking = json['booking'];
    other = json['other'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data_time'] = this.dataTime;
    data['from_time'] = this.fromTime;
    data['to_time'] = this.toTime;
    data['booking'] = this.booking;
    data['other'] = this.other;
    return data;
  }
}

List<DairyData>? filterDairyResponse(jsonResponse) {
  print("map....");
  try {
    if (jsonResponse == null) {
      return null;
    }

    if (jsonResponse["details"] != null) {
      List<DairyData> dairyDates = [];
      var detailsData = jsonResponse["details"];

      var bookings = detailsData["booking"];
      for (var item in bookings) {
        var r = DairyData.fromJson(item);
        r.playerDetails = Userdetails.fromJson(item["other"]["user"]);
        r.bookingLocation = item["other"]["location"];
        dairyDates.add(r);
      }

      var bootCamps = detailsData["bootcamp"];
      for (var item in bootCamps) {
        var r = DairyData.fromJson(item);
        dairyDates.add(r);
      }

      var presetDate = detailsData["custom"];
      for (var item in presetDate) {
        var r = DairyData.fromJson(item);
        dairyDates.add(r);
      }
      return dairyDates;
    }
    return null;
  } catch (e) {
    print("Error....$e");
    return null;
  }
}

List<DateTime>? filterDairyBookingDates(jsonResponse) {
  print("map....");
  try {
    if (jsonResponse == null) {
      return null;
    }

    if (jsonResponse["details"] != null) {
      List<DateTime> dairyDates = [];
      var detailsData = jsonResponse["details"] as Map;
      for (var i in detailsData.values) {
        for (var da in i) {
          var m = da["data_time"];
          dairyDates.add(stringToDateTime(m));
        }
      }

      return dairyDates;
    }
    return [];
  } catch (e) {
    print("Error..a..$e");
    return [];
  }
}

List<DairyData> filterDairyDataForDay(jsonResponse, {date: "2020-11-10"}) {
  print("map....$date");
  try {
    if (jsonResponse == null) {
      return [];
    }

    if (jsonResponse["details"] != null) {
      List<DairyData> dairyDates = [];
      var detailsData = jsonResponse["details"] as Map;
      for (var i in detailsData.values) {
        for (var da in i) {
          var m = da["data_time"];
          if (m == date) {
            var r = DairyData.fromJson(da); //  "booking": "booking",
            r.bookingLocation = da["other"]["location"];
            r.playerDetails = da["booking"] != "booking"
                ? null
                : Userdetails.fromJson(da["other"]["user"]);
            dairyDates.add(r);
          }
        }
      }
      print("total....${dairyDates.length}");

      return dairyDates;
    }
    return [];
  } catch (e) {
    print("Error....$e");
    return [];
  }
}

DayReport? filterDairyForDay(jsonResponse, {date: "2020-11-10"}) {
  print("map....$date");
  // try {
    if (jsonResponse == null) {
      return null;
    }
    bool containBooking = false;

    if (jsonResponse["details"] != null) {
      List<DairyData> dairyDates = [];
      var detailsData = jsonResponse["details"] as Map;
      for (var i in detailsData.values) {
        for (var da in i) {
          var m = da["data_time"];
          if (m == date) {
            var r = DairyData.fromJson(da);

            var startHr = da["from_time"].split(":").first;
            var endHr = da["to_time"].split(":").first;

            r.dateTimes = stringToDateTimeList(m, startHr, endHr);
            if (da["booking"] == "booking") {
              containBooking = true;
              if(da["other"] != null ){
                r.playerDetails = Userdetails.fromJson(da["other"]["user"]);
                r.bookingLocation = da["other"]["location"];
              }

            }
            dairyDates.add(r);
          }
        }
      }
      print("total....${dairyDates.length}");
      List<DairyData?> list = <DairyData?>[];
      int count = 24;
      var nowDate = stringToDateTime(date);
      for (var i = 0; i < 24; i++) {
        var d = DateTime(
          nowDate.year,
          nowDate.month,
          nowDate.day,
          i,
        );
        bool isFound = false;
        for (var j in dairyDates) {
          if (j.dateTimes!.contains(d)) {
            list.add(j) ;
            isFound = true;
            break;
          }
        }
        if (!isFound) {
         // list[i] = null;
          list.add(null);
          count -= 1;
        }
      }
      print("List....${list.length}");
      return DayReport(
        date: stringToDateTime(date),
        containsBooking: containBooking,
        data: list,
        unAvailableAllDay: count == 24,
      );
    }
    return DayReport(
      date: stringToDateTime(date),
      containsBooking: false,
    );
  // } catch (e) {
  //   print("Error..e..$e");
  //   return DayReport(date: stringToDateTime(date), containsBooking: false);
  // }
}

List<DateTime>? filterCoachAvailableTimeInDay(
  jsonResponse, {
  date: "2020-11-10",
}) {
  print("map....$date");
  try {
    if (jsonResponse == null) {
      return null;
    }

    if (jsonResponse["details"] != null) {
      List<DateTime> dairyDates = [];
      var detailsData = jsonResponse["details"] as Map;
      for (var i in detailsData.values) {
        for (var da in i) {
          var m = da["data_time"];
          if (m == date) {
            var startHr = da["from_time"].split(":").first;
            var endHr = da["to_time"].split(":").first;

            print("date start hour:  $startHr");

            var r = stringToDateTimeList(m, startHr, endHr);

            dairyDates.addAll(r);
          }
        }
      }

      List<DateTime> output = [];
      var nowDate = stringToDateTime(date);

      var todayNow = DateTime.now();

      for (var i = 5; i < 22; i++) {
        var d = DateTime(
          nowDate.year,
          nowDate.month,
          nowDate.day,
          i,
        );

        if (!dairyDates.contains(d)) {
          if (todayNow.isBefore(d)) {
            print("date is before...${d.toString()}");
            output.add(d);
          }
        }
      }

      return output;
    }
    return [];
  } catch (e) {
    print("Error....$e");
    return [];
  }
}

class DayReport {
  DateTime date;
  bool containsBooking;
  bool unAvailableAllDay;
  List<DairyData?> data;
  DayReport({
    required this.date,
    this.containsBooking: false,
    this.data: const [],
    this.unAvailableAllDay: false,
  });
}
