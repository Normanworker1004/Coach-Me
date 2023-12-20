import 'package:cme/model/booking_date_class.dart';
import 'package:cme/model/map_bootcamp_response.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

/// age is now for 16years
bool isOver16(DateTime date) {
  final toDayDate = DateTime.now();
  var different = toDayDate.difference(date).inDays;
  return (different - (16 * 365)) >= 0;
}

bool isOver13(DateTime date) {
  final toDayDate = DateTime.now();
  var different = toDayDate.difference(date).inDays;
  return (different - (13 * 365)) >= 0;
}

bool isOver21(DateTime date) {
  final toDayDate = DateTime.now();
  var different = toDayDate.difference(date).inDays;
  return (different - (21 * 365)) >= 0;
}

String dateToString(DateTime? date) {
  var j = Jiffy(date).format("MMMM dd, yyyy");
  return j.trimLeft();
}

String dateToString2(DateTime? date) {
  var j = Jiffy(date).format("dd-MM-yyyy");
  return j.trimLeft();
}

String dateToString3(DateTime? date) {
  var j = Jiffy(date).format("yyyy-MM-dd");
  return j.trimLeft();
}

String bookingTimeRange(DateTime time) {
  var b = DateFormat("h:mma").format(time);
  var end = DateFormat("h:mma").format(time.add(Duration(hours: 1)));

  return "$b - $end";
}

List<DateTime> buildBookingTimeList(DateTime? d,
    {int startHour: 8, int startMinute: 0, int total: 14}) {
  try {
    return List.generate(
      total,
      (index) => DateTime(
        d!.year,
        d.month,
        d.day,
        startHour + index,
        startMinute,
      ),
    );
  } catch (e) {
    return [];
  }
}

String buildBookingDateRange(List<BookingDates> d) {
  if (d.length == 1) {
    var i1 = DateFormat("MMMM dd, yyyy").format(d.first.date!);
    return "$i1";
  } else {
    // var b4 = List.generate(d.length, (index) => null)
    d.sort((a, b) => a.date!.compareTo(b.date!));

    var d1 = d.first.date!;
    var d2 = d.last.date!;

    if (d1.month == d2.month) {
      var i = DateFormat("MMM. dd").format(d1);
      var i1 = DateFormat("dd, yyyy").format(d2);
      return "$i - $i1";
    } else {
      var i = DateFormat("MMM dd").format(d1);
      var i1 = DateFormat("dd MMM, yyyy").format(d2);
      return "$i- $i1";
    }
  }
}

BookingDates toBootCampBookingDates(BootCampDetails bootCampDetails) {
  try {
    List<DateTime> selectedTimeSlotList = [];
    print("completed...1");
    List d = bootCampDetails.bootCampDate!.split("T").first.split("-");
    List<int?> dateV =
        List.generate(d.length, (index) => int.tryParse(d[index]));

    print("completed...2");
    DateTime bDate = DateTime(dateV[0]!, dateV[1]!, dateV[2]!);

    var sTime = bootCampDetails.bootcamptime!;
    List sTimeList = List.generate(sTime.length, (index) => sTime[index].time);

    print("completed...3");
    for (var i in sTimeList) {
      var k = i.split(":");
      List<int?> dT = List.generate(
        k.length,
        (index) => int.tryParse(k[index]),
      );

      print("vl...$dT");
      selectedTimeSlotList
          .add(DateTime(bDate.year, bDate.month, bDate.day, dT[0]!, dT[1]!));
    }
    print("completed...4");
    return BookingDates(bDate, bookingTimes: selectedTimeSlotList);
  } catch (e) {
    print("errror...$e");
    return BookingDates(null, bookingTimes: null);
  }
}

String dateDiary(DateTime date, DateTime date2) {
  var j = Jiffy(date).format("dd-MM-yyyy");
  var j2 = DateFormat.Hm().format(date2);
  return j.trimLeft() + " $j2";
}

String to12hr(String d) {
  var i = d.split(":");
  var hr = int.tryParse(i.first)!;
  if (hr > 12) {
    return "${hr % 12}:${i.last}PM";
  } else {
    return "$hr:${i.last}AM";
  }
}

String toTimeRange(List<BookingDates> d) {
  if (d.length == 1) {
    var i1 = DateFormat("MMMM dd, yyyy").format(d.first.date!);
    return "$i1";
  } else {
    // var b4 = List.generate(d.length, (index) => null)
    d.sort((a, b) => a.date!.compareTo(b.date!));

    var d1 = d.first.date!;
    var d2 = d.last.date!;

    if (d1.month == d2.month) {
      var i = DateFormat("MMM. dd").format(d1);
      var i1 = DateFormat("dd, yyyy").format(d2);
      return "$i - $i1";
    } else {
      var i = DateFormat("MMM dd").format(d1);
      var i1 = DateFormat("dd MMM, yyyy").format(d2);
      return "$i- $i1";
    }
  }
}

String toDate(String? b) {
  var c = Jiffy(b) //.fromNow();

      .format("MMMM dd, yyyy");
  return c;
}

String toDateNormal(String? b) {
/*

    if (startDateTime.isAfter(DateTime.now().add(Duration(hours: 24)))) {
      displayDate = Jiffy(startDateTime).format("HH:mma MMMM dd, yyyy");
    } else {
      displayDate = "Today, " + Jiffy(startDateTime).format("HH:mma");
    }
  */

  if (b == null) {
    return "null";
  }
  DateTime dt;
  if (b.contains("T")) {
    // print(b);
    b = b.split("T").first;
    var s = b.split("-");
    dt = DateTime(
      int.parse(s[0]),
      int.parse(s[1]),
      int.parse(s[2]),
    );
    // var c = Jiffy().format("MMMM dd, yyyy");
    // return c;
  } else {
    b = b.split("T").first;
    var s = b.split("-");
    dt = DateTime(int.parse(s[2]), int.parse(s[1]), int.parse(s[0]));
  }
  return Jiffy(dt).format("MMMM dd, yyyy");
  // var c = Jiffy(
  // ,
  // ).fromNow();

  // //.format("MMMM dd, yyyy");

  // if (dt.isAfter(DateTime.now().add(Duration(hours: 24)))) {
  //   return Jiffy(dt).format("HH:mma MMMM dd, yyyy");
  // } else {
  //   return "Today, " + Jiffy(dt).format("HH:mma");
  // }
}

DateTime stringToDateTime(String b) {
  b = b.split("T").first;
  var s = b.split("-");
  return DateTime(int.parse(s[0]), int.parse(s[1]), int.parse(s[2]));
}

DateTime bookingTimeStringToDateTime(String b, hr) {
  b = b.split("T").first;
  var s = b.split("-");
  return DateTime(
    int.parse(s[2]),
    int.parse(s[1]),
    int.parse(s[0]),
    int.parse(hr),
  );
}

DateTime coachBookingTimeStringToDateTime(String b, hr) {
  b = b.split("T").first;
  var s = b.split("-");
  return DateTime(
    int.parse(s[0]),
    int.parse(s[1]),
    int.parse(s[2]),
    int.parse(hr),
  );
}

bool sessionCanStart(String sessionTime, startHour) {
  var b = sessionTime.split("T").first;
  var s = b.split("-");
  var time = DateTime(
      int.parse(s[2]), int.parse(s[1]), int.parse(s[0]), int.parse(startHour));
  time = time.subtract(Duration(minutes: 5));
  final d = DateTime.now();

  var i = d.isAfter(time);
  return i;
}

List<DateTime> stringToDateTimeList(String b, String from, to) {
  b = b.split("T").first;
  var s = b.split("-");
  int fromHr = int.tryParse(from)!;
  var toHr = int.tryParse(to)!;

  List<DateTime> timeList = [];
  for (int i = fromHr; i <= toHr; i++) {
    var d = DateTime(
      int.parse(s[0]),
      int.parse(s[1]),
      int.parse(s[2]),
      i,
    );
    timeList.add(d);
  }

  print("date $b, start: $from, end: $to,.......length: ${timeList.length} ");

  return timeList;
}
