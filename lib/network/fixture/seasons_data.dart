class SeasonsData {
  bool? status;
  String? description;
  List<Season>? seasons;
  Season? _allSeason;

  SeasonsData({this.status, this.description, this.seasons});

  SeasonsData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    description = json['description'];

    if (json['Fixture'] != null && json['Fixture'] != []) {
      _allSeason = Season(
          seasonName: "All",
          title1: "MINS PLYD",
          title2: "GOALS",
          title3: "ASSIST",
          title4: "CLN SHT",
          title5: "CLN SHT",
          title6: "CLN SHT",
          fixture: []);

      seasons = <Season>[];
      json['Fixture'].forEach((v) {
        var season = new Season.fromJson(v);
        seasons!.add(season);
        _allSeason!.addSeason(season);
      });
    }
  }

  Season? get allSeason => _allSeason;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['description'] = this.description;
    if (this.seasons != null) {
      data['Fixture'] = this.seasons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SeasonResponse {
  bool? status;
  String? description;
  Season? season;

  SeasonResponse({this.status, this.description, this.season});

  SeasonResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    description = json['description'];
    print("TRYING TO DECODE ${json['Season']}");
    season = json['Season'] != null
        ? new Season.fromJson(json['Season'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['description'] = this.description;
    if (this.season != null) {
      data['Season'] = this.season!.toJson();
    }
    return data;
  }

}

class Season {
  int? id;
  int? userid;
  String? seasonName;
  String? title1 = "MINS PLYD";
  String? title2 = "GOALS";
  String? title3 = "ASSIST";
  String? title4 = "CLN SHT";
  String? title5 = "";
  String? title6 = "";
  String? createdAt;
  String? updatedAt;
  List<Fixture>? fixture;
  int _score1Sum = 0, _score2Sum = 0, _score3Sum = 0, _score4Sum = 0,_score5Sum = 0,_score6Sum = 0, _app = 0;

  Season(
      {this.id,
      this.userid,
      this.seasonName,
      this.title1,
      this.title2,
      this.title3,
      this.title4,
      this.title5,
      this.title6,
      this.createdAt,
      this.updatedAt,
      this.fixture});

  Season.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    seasonName = json['season'];
    title1 = json['title1'];
    title2 = json['title2'];
    title3 = json['title3'];
    title4 = json['title4'];
    title5 = json['title5'];
    title6 = json['title6'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['fixturDetails'] != null) {
      fixture = <Fixture>[];
      json['fixturDetails'].forEach((v) {
        fixture!.add(new Fixture.fromJson(v));
        print("GOT SOME FIXTURE HERE //// ${v} ---> comment ${new Fixture.fromJson(v).comment}");
      });
    }else{
      fixture =  <Fixture>[];
    }
    calculateSums();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['season'] = this.seasonName;
    data['title1'] = this.title1;
    data['title2'] = this.title2;
    data['title3'] = this.title3;
    data['title4'] = this.title4;
    data['title5'] = this.title5;
    data['title6'] = this.title6;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.fixture != null) {
      data['fixturDetails'] = this.fixture!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  void calculateSums() {
    if (fixture == null && fixture!.length == 0) return;
    fixture!.forEach((element) {
      _score1Sum += element.score1!;
      _score2Sum += element.score2!;
      _score3Sum += element.score3!;
      _score4Sum += element.score4!;
      _score5Sum += element.score5!;
      _score6Sum += element.score6!;
      _app++;
    });
  }

  addSeason(Season season) {
    _score1Sum += season.score1Sum;
    _score2Sum += season.score2Sum;
    _score3Sum += season.score3Sum;
    _score4Sum += season.score4Sum;
    _score5Sum += season.score5Sum;
    _score6Sum += season.score6Sum;
    _app += season._app;
    this.fixture!.addAll(season.fixture!);
  }

  int get score4Sum => _score4Sum;
  int get score5Sum => _score5Sum;
  int get score6Sum => _score6Sum;

  int get score3Sum => _score3Sum;

  int get score2Sum => _score2Sum;

  int get score1Sum => _score1Sum;

  int get app => _app;

  void addNewFixture(Fixture fixture) {
    this.fixture!.add(fixture);
    _score1Sum += fixture.score1!;
    _score2Sum += fixture.score2!;
    _score3Sum += fixture.score3!;
    _score4Sum += fixture.score4!;
    _score6Sum += fixture.score5!;
    _score5Sum += fixture.score6!;
    _app++;
  }
}

class Fixture {
  int? id;
  int? userid;
  int? seasonID;
  // I changed all titles to scores here too.
  int? score1;
  int? score2;
  int? score3;
  int? score4;
  int? score5;
  int? score6;
  String? dateplayed;
  String? house;
  String? opponent;
  String? gamestatus;
  String? createdAt;
  String? updatedAt;
  String? comment;

  Fixture(
      {this.id,
      this.userid,
      this.seasonID,
      this.score1,
      this.score2,
      this.score3,
      this.score4,
      this.score5,
      this.score6,
      this.dateplayed,
      this.house,
      this.opponent,
      this.gamestatus,
      this.createdAt,
      this.updatedAt,
      this.comment,
      });

  Fixture.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    seasonID = json['seasonID'];
    score1 = json['title1'];
    score2 = json['title2'];
    score3 = json['title3'];
    score4 = json['title4'];
    score5 = json['title5'] ?? 0;
    score6 = json['title6'] ?? 0;
    dateplayed = json['dateplayed'];
    house = json['house'];
    opponent = json['opponent'];
    gamestatus = json['gamestatus'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['seasonID'] = this.seasonID;

    // Remember you changed title1, title2... to score1, score2... bcoz thats the key for fixture
    data['score1'] = this.score1;
    data['score2'] = this.score2;
    data['score3'] = this.score3;
    data['score4'] = this.score4;
    data['score5'] = this.score5;
    data['score6'] = this.score6;
    data['dateplayed'] = this.dateplayed;
    data['house'] = this.house;
    data['opponent'] = this.opponent;
    data['gamestatus'] = this.gamestatus;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['comment'] = this.comment;
    return data;
  }

  DateTime getDate() {
    List<String> dateString = createdAt!.split('T')[0].split('-');
    return DateTime(int.parse(dateString[0]), int.parse(dateString[1]),
        int.parse(dateString[2]));
  }

  String getDatePlayed() {
    String dateString = dateplayed!.split('T')[0];
    return dateString.split(' ')[0].replaceAll('-', '/');
  }
}

class CreateFixtureResponse {
  bool? status;
  String? description;
  FixtureResponse? fixtureResponse;

  CreateFixtureResponse({this.status, this.description, this.fixtureResponse});

  CreateFixtureResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    description = json['description'];
    fixtureResponse = json['Season'] != null
        ? new FixtureResponse.fromJson(json['Season'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['description'] = this.description;
    if (this.fixtureResponse != null) {
      data['Season'] = this.fixtureResponse!.toJson();
    }
    return data;
  }
}

class FixtureResponse {
  int? id;
  int? userid;
  String? seasonID;
  String? title1;
  String? title2;
  String? title3;
  String? title4;
  String? title5;
  String? title6;
  String? dateplayed;
  String? house;
  String? opponent;
  String? gamestatus;
  String? updatedAt;
  String? createdAt;
  String? comment;

  FixtureResponse(
      {this.id,
      this.userid,
      this.seasonID,
      this.title1,
      this.title2,
      this.title3,
      this.title4,
      this.dateplayed,
      this.house,
      this.opponent,
      this.gamestatus,
      this.updatedAt,
      this.createdAt,
      this.comment,

      });

  FixtureResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    seasonID = json['seasonID'];
    title1 = json['title1'];
    title2 = json['title2'];
    title3 = json['title3'];
    title4 = json['title4'];
    title5 = json['title5'];
    title6 = json['title6'];
    dateplayed = json['dateplayed'];
    house = json['house'];
    opponent = json['opponent'];
    gamestatus = json['gamestatus'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['seasonID'] = this.seasonID;
    data['title1'] = this.title1;
    data['title2'] = this.title2;
    data['title3'] = this.title3;
    data['title4'] = this.title4;
    data['title5'] = this.title5;
    data['title6'] = this.title6;
    data['dateplayed'] = this.dateplayed;
    data['house'] = this.house;
    data['opponent'] = this.opponent;
    data['gamestatus'] = this.gamestatus;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    data['comment'] = this.comment;
    return data;
  }
}