import 'dart:convert';

import 'package:cme/model/previous_home_stats.dart';
import 'package:cme/model/previous_user.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences pref;

String notif = "notif";

Future<bool> saveNotif(bool isAllow) async {
  pref = await SharedPreferences.getInstance();

  return await pref.setBool(notif, isAllow);
}

Future<bool> getNotif() async {
  try {
    pref = await SharedPreferences.getInstance();

    return pref.getBool(notif) ?? true;
  } catch (e) {
    return false;
  }
}

final account = "account";

Future<bool> saveAccount(PreviousUser acc) async {
  pref = await SharedPreferences.getInstance();
  if (acc == null) {
    return await pref.setString(account, "");
  }
  var p = jsonEncode(acc.toJson());

  return await pref.setString(account, p);
}

Future<PreviousUser?> getAccount() async {
  try {
    pref = await SharedPreferences.getInstance();

    var p = pref.getString(account)!;

    var pp = jsonDecode(p);

    PreviousUser acc = PreviousUser.fromJson(pp);

    return acc;
  } catch (e) {
    return null;
  }
}

Future clearAccount() async {
  try {
    pref = await SharedPreferences.getInstance();
    pref.remove(account);
  } catch (e) {}
}

String allowLocalAuth = "allow_local";

Future<bool> saveAllowLocal(bool isAllow) async {
  pref = await SharedPreferences.getInstance();

  return await pref.setBool(allowLocalAuth, isAllow);
}

Future<bool> getAllowLocal() async {
  try {
    pref = await SharedPreferences.getInstance();

    return pref.getBool(allowLocalAuth) ?? false;
  } catch (e) {
    return false;
  }
}

String stats = "stats";

Future<bool> updateStatsDate(int dayOfYear) async {
  pref = await SharedPreferences.getInstance();

  return await pref.setInt(stats, dayOfYear);
}

Future<int> getStatsLastUpdateDate() async {
  try {
    pref = await SharedPreferences.getInstance();

    return pref.getInt(stats) ?? Jiffy().dayOfYear - 1;
  } catch (e) {
    return Jiffy().dayOfYear - 1;
  }
}

String homeStatsLocal = "home_stats";

/// Always remember to store all the homeStats again at every new addition
Future<bool> saveStatsHomeStateLocal(PreviousHomeStats homeStats) async {
  pref = await SharedPreferences.getInstance();

  if (homeStats.userId == null) {
    return await pref.remove(homeStatsLocal);
   }
  var p = jsonEncode(homeStats.toJson());

  return await pref.setString(homeStatsLocal, p);
  // return await pref.setBool(allowLocalAuth, isAllow);
}

/// This returns a list of all stats to be displayed on the player stats home
Future<PreviousHomeStats?> getStatsHomeStateLocal() async {
  try {
    pref = await SharedPreferences.getInstance();

    var p = pref.getString(homeStatsLocal);

    if (p != null) {
      var pp = jsonDecode(p);
      print("Home Stats");
      print(pp);
      print(PreviousHomeStats.fromJson(pp));
      return PreviousHomeStats.fromJson(pp);
    } else
      return null;
  } catch (e) {
    print("getHomeStats Error: ");
    print(e);
    return null;
  }
}

/// Always remember to store all the homeStats again at every deletion
Future<bool> deleteStatsItemHomeStateLocal(int statId) async {
  pref = await SharedPreferences.getInstance();

  var p = pref.getString(homeStatsLocal);
  if (p != null) {
    var pp = jsonDecode(p);
    print("Home Stats");
    var homeStats = PreviousHomeStats.fromJson(pp);
    homeStats.statsIds?.remove(statId);
    var newStats = jsonEncode(homeStats.toJson());

    await pref.setString(homeStatsLocal, newStats);

    return true;
  }

  return false;
  // return await pref.setBool(allowLocalAuth, isAllow);
}
