import 'package:flutter/material.dart';

class SubDetail {
  final String? type;
  final String? price;
  final String? perMonth;
  final String? billType;
  final String entitlement1;
  final String entitlement2;
  final int totalMonths;
  final Color? color;
  final bool expendedMoreFeatures;
  final List<String> moreFeatureList;
  SubDetail({
    this.type,
    this.price,
    this.perMonth,
    this.billType,
    this.color,
    this.expendedMoreFeatures:false,
    this.totalMonths: 1,
    this.entitlement1: "Buddy up with other players",
    this.entitlement2: "1 on 1 challenge other players",
    this.moreFeatureList: const [
      "More cool feature.",
      "More cool feature.",
      "More cool feature.",
    ],
  });
}
