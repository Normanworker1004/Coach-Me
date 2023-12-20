import 'package:cme/subscription/constants.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class CurrentSubManager {
  bool isPlayerBasicActive;
  bool isCoachBasicActive;
  bool isCoachAdvActive;
  bool isTrialOver;

  EntitlementInfo? playerBasic;
  EntitlementInfo? coachBasic;
  EntitlementInfo? coachAdvanced;


  CurrentSubManager({
    this.isPlayerBasicActive: false,
    this.isCoachBasicActive: false,
    this.isCoachAdvActive: false,
    this.isTrialOver: false,
    this.playerBasic,
    this.coachBasic,
    this.coachAdvanced,
   });
}

class PlayerPackages {
  String entitlementKey = SubKeys.player_basic_entitlement;
  String offeringKey = SubKeys.player_basic_offering;
  Package? monthly;
  Package? monthlyTrial;
  Package? annual;
  Package? annualTrial;

  PlayerPackages({
    this.monthly,
    this.monthlyTrial,
    this.annual,
    this.annualTrial,
  });
}

class CoachBasicPackages {
  String entitlementKey = SubKeys.coach_basic_entitlement;
  String offeringKey = SubKeys.coach_basic_offering;

  Package? monthly;
  Package? annual;

  CoachBasicPackages({
    this.monthly,
    this.annual,
  });
}

class CoachAdvPackages {
  String entitlementKey = SubKeys.coach_advanced_entitlement;
  String offeringKey = SubKeys.coach_advanced_offering;

  Package? monthly;
  Package? annual;

  CoachAdvPackages({
    this.monthly,
    this.annual,
  });
}
