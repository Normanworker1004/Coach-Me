import 'dart:io';

import 'package:cme/subscription/constants.dart';
import 'package:cme/subscription/sub_model.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

Future<PlayerPackages> getPlayerOfferings() async {

  try {
    PlayerPackages p = PlayerPackages();
    var offerings = await Purchases.getOfferings();
    final currentOfferings = offerings.getOffering(p.offeringKey);
    if (currentOfferings != null) {
      p.monthly = currentOfferings.monthly;
      p.monthlyTrial =  currentOfferings.getPackage(SubKeys.player_basic_monthly_trial_offering);

      p.annual = currentOfferings.annual;
      p.annualTrial =  currentOfferings.getPackage(SubKeys.player_basic_annual_trial_offering);


      print("aa${currentOfferings.getPackage(SubKeys.player_basic_annual_trial_offering)}aa");
      print("bb${currentOfferings.weekly}bb");
      print("cc${currentOfferings.availablePackages}cc");
      currentOfferings.availablePackages.forEach((element) {
        print(element.identifier);
      });

    }
    print("player current ofering...$offerings");
    return p;
  } on PlatformException catch (e) {
    print("Error...$e");
    return PlayerPackages();
  }
}

Future<CoachBasicPackages> getCoachBasicOfferings() async {
  try {
    CoachBasicPackages c = CoachBasicPackages();
    var offerings = await Purchases.getOfferings();
    final currentOfferings = offerings.getOffering(c.offeringKey);
    if (currentOfferings != null) {
      c.monthly = currentOfferings.monthly;
      c.annual = currentOfferings.annual;
    }
    return c;
  } on PlatformException catch (e) {
    print("Error...$e");
    return CoachBasicPackages();
  }
}

Future<List> getCoachAdvOfferings() async {
  CoachAdvPackages adv = CoachAdvPackages();

  CoachBasicPackages basic = CoachBasicPackages();
  try {
    var offerings = await Purchases.getOfferings();
    final advOfferings = offerings.getOffering(adv.offeringKey);
    if (advOfferings != null) {
      adv.monthly = advOfferings.monthly;
      adv.annual = advOfferings.annual;
    }

    final basicOfferings = offerings.getOffering(basic.offeringKey);
    if (basicOfferings != null) {
      basic.monthly = basicOfferings.monthly;
      basic.annual = basicOfferings.annual;
    }

    return [
      basic,
      adv,
    ];
  } on PlatformException catch (e) {
    print("Error...$e");
    return List.filled(2, null, growable: false);
  }
}

Future<CurrentSubManager> getOldPurchases() async {
  if (Platform.isIOS //|| Platform.isAndroid
  ) {
    //T ODO (REMOVE ANDROID BACK DOOR)
    // return CurrentSubManager(
    //   isCoachAdvActive: true,
    //   isCoachBasicActive: true,
    //   isPlayerBasicActive: true,
    //   isTrialOver: true,
    // );
  }

  CurrentSubManager sub = CurrentSubManager();

  try {
    PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
     print("JEREMY infro....$purchaserInfo");

    EntitlementInfos entitlementInfos = purchaserInfo.entitlements;
    print("entitlementInfos....$entitlementInfos");
    if (entitlementInfos.all.length > 0) {
      sub.isTrialOver = true;
    }

    EntitlementInfo? playerBasic =
        entitlementInfos.active[SubKeys.player_basic_entitlement];

     print("JEREMY : ....$playerBasic");

    print("sub.playerBasic....${playerBasic?.isActive}");
    sub.isPlayerBasicActive = playerBasic?.isActive ?? false;
    sub.playerBasic = playerBasic;

    EntitlementInfo? coachBasic =
        entitlementInfos.active[SubKeys.coach_basic_entitlement];
    sub.isCoachBasicActive = coachBasic?.isActive ?? false;
    sub.coachBasic = coachBasic;
    print("ssub.coachBasic....${coachBasic?.isActive}");

    EntitlementInfo? coachAdv =
        entitlementInfos.active[SubKeys.coach_advanced_entitlement];
    sub.isCoachAdvActive = coachAdv?.isActive ?? false;
    sub.coachAdvanced = coachAdv;
    print("sub.coachAdvanced....${coachAdv?.isActive}");
    print(  "coach basic....${sub.isCoachBasicActive}\ncoach adv....${sub.isCoachAdvActive}\nplayer basic...${sub.isPlayerBasicActive}.\ntrial....${sub.isTrialOver}\n");
    return sub;
  } on PlatformException catch (e) {
    print("Error...$e");
    return CurrentSubManager();
  }
}
