class Sport {
  List<String>? sport;
  List<int>? level;

  Sport({this.sport, this.level});

  Sport.fromJson(Map<String, dynamic> json) {
    sport = json['sport'].cast<String>();
    level = json['level'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sport'] = this.sport;
    data['level'] = this.level;
    return data;
  }
}
