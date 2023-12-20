class CoachDiaryData {
  String? dataTime;
  String? fromTime;
  String? toTime;
  String? booking;
  var other;

  CoachDiaryData(
      {this.dataTime, this.fromTime, this.toTime, this.booking, this.other});

  CoachDiaryData.fromJson(Map<String, dynamic> json) {
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
    if (this.other != null) {
      data['other'] = this.other.toJson();
    }
    return data;
  }
}
