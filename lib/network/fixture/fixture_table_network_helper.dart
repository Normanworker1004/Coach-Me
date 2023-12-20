import 'dart:convert';
import 'dart:developer';
import 'package:cme/network/coach/request.dart';
import 'package:cme/network/fixture/seasons_data.dart';
import 'package:http/http.dart' as http;

Future<SeasonsData> fetchSeasons(token, sport) async {
  try {
    // print("fetch bio");
    var url = baseUrl + "api/fixture/fetchseason";
    print(url);

    // print(token);

    var mapa = {
      "sport": "${sport}",
    };
    print( "sport ${sport}");
    http.Response r = await http.post(
      Uri.parse(url),
      body: mapa,
      headers: {"x-access-token": token, "Accept": "application/json"},
    );

      print(jsonDecode(r.body));

    Map<String, dynamic>? map = jsonDecode(r.body);
    return SeasonsData.fromJson(jsonDecode(r.body));
  } catch (e) {
    log(
      'An Error occurred while trying to fetch Seasons',
      level: 3,
      error: e,
    );
    print('An Error occurred while trying to fetch Seasons ${e.toString()}');
    return SeasonsData(status: false);
  }
}

Future updateSeasonInfo(token, int? seasonId, String title1, String title2,
    String title3, String title4, String title5,String title6) async {

  try {
    var map = {
      "title1": title1,
      "title2": title2,
      "title3": title3,
      "title4": title4,
      "title5": title5,
      "title6": title6,
      "seasonid": seasonId.toString(),
    };

    var url = baseUrl + "api/fixture/updateseasoninfo";

    // print(token);
    http.Response r = await http
        .post(
      Uri.parse(url),
          headers: {
            "x-access-token": token,
          },
          body: map,

        );

    print("Updated Successfully!");

    print(r.body);

    // return BioResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    print('An Error Occurred while updating season info');
    // return BioResponse(status: false);
    print(e);
  }
}


Future updateCommentFixture(token, int? fixtureID, String comment) async {

  try {
    var map = {
      "fixtureid": "${fixtureID ?? 0}",
      "comment": comment,
    };
    print("${map.toString()}");

    var url = baseUrl + "api/fixture/updatefixturecomment";

    // print(token);
    http.Response r = await http
        .post(
      Uri.parse(url),
          headers: {
            "x-access-token": token,
          },
          body: map,

        );

    print("Updated Successfully!");
    print(r.body);

    // return BioResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    print('An Error Occurred while updating season info');
    // return BioResponse(status: false);
    print(e);
  }
}

Future<Season?> createSeason(token, String sport) async {
  try {
    var url = baseUrl + "api/fixture/createseason";
    var map = {
      "sport": "${sport}",
    };

    // print(token);
    http.Response r = await http
        .post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
      },
      body: map,
    )
        .whenComplete(() => print("Season's created successfully!"))
        .catchError((error) {
      print(error);
    });
    print("${r.body}");
    return SeasonResponse.fromJson(json.decode(r.body)).season;

    // print("Updated Successfully!");

    // print(r.body);
    // return BioResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    print('An Error Occurred while creating season');
    // return BioResponse(status: false);
    print(e);
    return null;
  }
}


Future<void> deleteSeason(token, int? seasonId) async {
  try {
    var url = baseUrl + "api/fixture/deleteseason";
    var map = {
      "seasonID": "${seasonId}",
    };

    // print(token);
    http.Response r = await http
        .delete(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
      },
      body: map,
    )
        .whenComplete(() => print("Season's deleted successfully!"))
        .catchError((error) {
      print(error);
    });
    print("${r.body}");
    return ;

    // print("Updated Successfully!");

    // print(r.body);
    // return BioResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    print('An Error Occurred while deleting season');
    // return BioResponse(status: false);
    print(e);
    return null;
  }
}

Future<CreateFixtureResponse> createFixture(token, Fixture fixture) async {
  try {
    var map = {
      "seasonid": "${fixture.seasonID}",
      "score1": "${fixture.score1}",
      "score2": "${fixture.score2}",
      "score3": "${fixture.score3}",
      "score4": "${fixture.score4}",
      "dateplayed": "${fixture.dateplayed}",
      "house": "${fixture.house}",
      "opponent": "${fixture.opponent}",
      "gamestatus": "${fixture.gamestatus}",
    };

    var url = baseUrl + "api/fixture/createfixture";

    // print(token);
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
      },
      body: map,
    );

    print("Fixture Created Successfully!");

    print(r.body);

    return CreateFixtureResponse.fromJson(jsonDecode(r.body));

    // print("Updated Successfully!");

    // return BioResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    print('An Error Occurred while creating Fixture!');
    print(e);
    return CreateFixtureResponse(status: false);
  }
}

Future updateFixture(token, Fixture fixture) async {
  try {
    var map = {
      "seasonid": "${fixture.seasonID}",
      "score1": "${fixture.score1}",
      "score2": "${fixture.score2}",
      "score3": "${fixture.score3}",
      "score4": "${fixture.score4}",
      "dateplayed": "${fixture.dateplayed}",
      "house": "${fixture.house}",
      "opponent": "${fixture.opponent}",
      "gamestatus": "${fixture.gamestatus}",
    };

    var url = baseUrl + "api/fixture/updatefixtureinfo";
    // print(token);
    http.Response r = await http
        .post(
      Uri.parse(url),
          headers: {
            "x-access-token": token,
          },
          body: map,
        )
        .whenComplete(() => print("Fixture Updated Successfully!"))
        .catchError((error) {
      print(error);
    });

    // print("Updated Successfully!");

    // print(r.body);
    // return BioResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    print('An Error Occurred while updating Fixture!');
    // return BioResponse(status: false);
    print(e);
  }
}

Future deleteFixture(token, Fixture fixture) async {
  try {
    var map = {
      "fixtureid": "${fixture.id}",
    };

    var url = baseUrl + "api/fixture/delete_fixture";

    // print(token);
    http.Response r = await http
        .post(
      Uri.parse(url),
          headers: {
            "x-access-token": token,
          },
          body: map,
        )
        .whenComplete(() => print("Fixture Updated Successfully!"))
        .catchError((error) {
      print(error);
    });

    // print("Updated Successfully!");

    // print(r.body);
    // return BioResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    print('An Error Occurred while updating Fixture!');
    // return BioResponse(status: false);
    print(e);
  }
}

enum GameStatus { win, lose, draw }
