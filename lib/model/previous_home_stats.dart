class PreviousHomeStats {
  int? userId;
  Set<dynamic>? statsIds = {};

  PreviousHomeStats({this.userId, this.statsIds});

  PreviousHomeStats.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    statsIds!.addAll(json['statsIds']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['statsIds'] = this.statsIds!.toList();
    return data;
  }
}
