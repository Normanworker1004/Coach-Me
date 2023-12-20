import 'package:cme/model/bnb_item.dart';
import 'package:cme/model/user_class/profile_details.dart';
import 'package:cme/model/user_class/user_details.dart';

int calculatePlayerPoints(Userdetails u) {
  // print("compute point");
  try {
    var p = u.profile!;

    // print("@@@@@@@@@@@add..${p.id}......${p.appusagePt} + ${p.bookingPt} ");
    var r = p.appusagePt ?? 0 + p.bookingPt ?? 0 + p.socialsharePt ?? 0;
    // print("compute point...$r");
    return r;
  } catch (e) {
    print("Error....$e");
    return 124;
  }
}

int calculatePlayerPoints2(Profiledetails u) {
  // print("compute point");
  try {
    var p = u;

    // print("@@@@@@@@@@@add..${p.id}......${p.appusagePt} + ${p.bookingPt} ");
    var r = p.appusagePt ?? 0 + p.bookingPt ?? 0 + p.socialsharePt ?? 0;
    // print("compute point...$r");
    return r;
  } catch (e) {
    print("Error....$e");
    return 124;
  }
}

String getSportLevel(Userdetails d, {String? sport: "football"}) {
  // cLevel[playerDetails.sport.level.first]

  if (sport == null) {
    sport = "football";
  }
  List<BNBItem> cLevel = [
    BNBItem("Amateur", "assets/badge1.png"),
    BNBItem("Grassroot", "assets/badge2.png"),
    BNBItem("Professional", "assets/badge3.png"),
    BNBItem("Expert", "assets/badge4.png"),
  ];
  var indexOfLevel = 0;
  if (d.sport == null) {
    indexOfLevel = 0;
  } else {
    if (d.sport!.level == null) {
      indexOfLevel = 0;
    } else {
      var s = d.sport!;
      for (var k = 0; indexOfLevel < s.sport!.length; indexOfLevel++) {
        if ("${s.sport![k]}" == sport) {
         //  indexOfLevel = s.level[k];
        //   print("...at ${s.level }");
          break;
        }
      }
    }
  }

  return cLevel[indexOfLevel <cLevel.length ? indexOfLevel : cLevel.length - 1 ].title;
}
