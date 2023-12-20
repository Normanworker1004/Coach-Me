import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/ui_provider.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/subdetail.dart';
import 'package:cme/subscription/constants.dart';
import 'package:cme/subscription/sub_model.dart';
import 'package:cme/subscription/subfunctions.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_subscription_card.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:provider/provider.dart';

import '../register/tandc.dart';
import '../utils/navigate_effect.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  UserModel? userModel;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (co, wid, model) {
        userModel = model;

        return buildBaseScaffold(
          body: SubBodyWidget(
            toDoAfterSucessfulPayment: () {},
          ),
          context: context,
          title: "Subscription",
        );
      },
    );
  }
}

class SubBodyWidget extends StatefulWidget {
  final Function toDoAfterSucessfulPayment;

  const SubBodyWidget({Key? key, required this.toDoAfterSucessfulPayment})
      : super(key: key);
  @override
  _SubBodyWidgetState createState() => _SubBodyWidgetState();
}

class _SubBodyWidgetState extends State<SubBodyWidget> {


  bool isAnnual = false;
  PlayerPackages? playerPackages;

  Package? monthlyCoachBasic;
  Package? annualCoachBasic;
  Package? monthlyCoachAdv;
  Package? annualCoachAdv;
  bool isLoading = false;

  late CurrentSubManager currentSubManager;

  bool isPlayerBasicActive = false;
  bool isCoachBasicActive = false;
  bool isCoachAdvActive = false;

  bool isMonthlyActive = false;
  bool isAnnualActive = false;

  EntitlementInfo? playerBasic;
  EntitlementInfo? coachBasic;
  EntitlementInfo? coachAdvanced;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (co, wid, model) {
        userModel = model;
        return SingleChildScrollView(
          child: "${userModel.getUserDetails()!.usertype}" == "coach"
              ? buildCoachSubBody()
              : buildPlayerSubBody(),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initPurchases();
  }

  @override init(){  }

  late UserModel userModel;

  initPurchases() async {
    await Purchases.setup(SubKeys.sdkKey);
    Purchases.addPurchaserInfoUpdateListener((info) {
      // handle any changes to purchaserInfo
      print("purchase rinfo changes....${info.activeSubscriptions}");
      updateSub();
    });
     updateSub();
  }

  updateSub() async {
    currentSubManager = await getOldPurchases();
    isPlayerBasicActive = currentSubManager.isPlayerBasicActive;
    isCoachBasicActive = currentSubManager.isCoachBasicActive;
    isCoachAdvActive = currentSubManager.isCoachAdvActive;

    if(isCoachAdvActive  ) isCoachBasicActive = false;

    playerBasic = currentSubManager.playerBasic;
    coachBasic = currentSubManager.coachBasic;
    coachAdvanced = currentSubManager.coachAdvanced;

    print("coach adv ....${currentSubManager.isCoachAdvActive}");
    print("coach basic....${currentSubManager.isCoachBasicActive}");
    print("player basic....${currentSubManager.isPlayerBasicActive}");
    print("trial....${currentSubManager.isTrialOver}");
    print("identifiew....${playerBasic?.productIdentifier}");
    if(playerBasic != null && currentSubManager.isPlayerBasicActive){
      isMonthlyActive = !playerBasic!.productIdentifier.contains("annual");
      isAnnualActive = !isMonthlyActive;
      if (isAnnualActive) isAnnual = true;
    }

    if(isCoachBasicActive ){
      isMonthlyActive = !coachBasic!.productIdentifier.contains("annual");
      isAnnualActive = !isMonthlyActive;
      if (isAnnualActive) isAnnual = true;
    }

    if(isCoachAdvActive ){
       isMonthlyActive = !coachAdvanced!.productIdentifier.contains("annual");
      isAnnualActive = !isMonthlyActive;
      if (isAnnualActive) isAnnual = true;
    }

    print("JEREMYCOACH.....isCoachAdvActive :: $isCoachAdvActive");
    print("JEREMYCOACH.....isCoachBasicActive :: $isCoachBasicActive");
    print("JEREMYCOACH.....isPlayerBasicActive :: $isPlayerBasicActive");
    print("JEREMYCOACH.....isMonthlyActive :: $isMonthlyActive");
    print("JEREMYCOACH.....isAnnualActive :: $isAnnualActive");



    setState(() {});
  }

  bool coachSubScribed() => isCoachBasicActive || isCoachAdvActive;

  Widget buildCoachSubBody() {
    return FutureBuilder<List>(
        future: getCoachAdvOfferings(),
        builder: (context, snapshot) {
          if (snapshot == null) {
            return Container(
              child: Center(
                child: Column(
                  children: [
                    mediumText("Unable to Fetch Subscription Packages"),
                  ],
                ),
              ),
            );
          }
          if (snapshot.data == null) {
            return Container(
              height: 600,
              child: Center(
                child: Column(
                  children: [
                    mediumText("Fetching Subscription Packages"),
                    verticalSpace(),
                    CupertinoActivityIndicator(),
                  ],
                ),
              ),
            );
          }

          if ( isLoading  ) {
            return Container(
              height: 600,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    mediumText("Fetching Package..."),
                    verticalSpace(),
                    CupertinoActivityIndicator(),
                  ],
                ),
              ),
            );
          }

          var coachPackages = snapshot.data!;

          CoachBasicPackages? cBasic = coachPackages[0];
          CoachAdvPackages? cAdv = coachPackages[1];

          if (cBasic != null) {
            monthlyCoachBasic = cBasic.monthly;
            annualCoachBasic = cBasic.annual;
            print("$monthlyCoachBasic");
          }
          if (cAdv != null) {
            monthlyCoachAdv = cAdv.monthly;
            annualCoachAdv = cAdv.annual;
          }

          return monthlyCoachBasic == null || monthlyCoachAdv == null
              ? Container(
            child: Center(
              child: Column(
                children: [
                  mediumText("Unable to Fetch Subscription Packages"),
                ],
              ),
            ),
          )
              : Column(
            children: [
              verticalSpace(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    boldText("Monthly",
                        color: isAnnual ? Colors.grey : Colors.black,
                        size: 14),
                    Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                          trackColor: normalBlue,
                          activeColor: normalBlue,
                          value: isAnnual,
                          onChanged: (v) {
                            setState(() {
                              isAnnual = v;
                            });
                          }),
                    ),
                    boldText("Annual",
                        color: isAnnual ? Colors.black : Colors.grey,
                        size: 14),
                  ],
                ),
              ),
              verticalSpace(height: 16),
              !isAnnual
                  ? Stack(
                    children: [GestureDetector(
                onTap: () => {purchasePackage(monthlyCoachAdv!)},
                child: SubscribtionInfoCard(
                    isCurrent: coachSubScribed() &&
                        ("${coachAdvanced?.productIdentifier}" ==
                            "${SubKeys.coach_advanced_monthly}"),
                    d: SubDetail(
                      price:
                      "${(monthlyCoachAdv!.product.priceString)}",
                      perMonth:"",
                      // "${monthlyCoachAdv!.product.currencyCode} ${(monthlyCoachAdv!.product.price / 1.0).toStringAsFixed(2)}/month",
                      billType: "Monthly",
                      type: "Advanced",
                      color: Color.fromRGBO(182, 9, 27, 1),
                      entitlement1:
                      "Group Bookings (plus BootCamp option)",
                      entitlement2: "Provide coaching nationally",
                      moreFeatureList: [
                        "Virtual and Physical player booking",
                        "Video Bio",
                        "Include Subscribed Player access",
                        "Provide Player Reports"
                      ],
                    ),
                ),
              ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Visibility(
                          visible:coachSubScribed() &&  isCoachAdvActive  && isMonthlyActive,
                          child: Card(
                            margin: EdgeInsets.all(0),
                            shape: CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.check,
                                size: 14,
                                color: Color.fromRGBO(182, 9, 27, 1),
                              ),
                            ),
                          ),
                        ),
                      )  ],
                  )
                  : Stack(
                    children: [GestureDetector(
                onTap: () => {purchasePackage(annualCoachAdv!)},
                child: SubscribtionInfoCard(
                    isCurrent: coachSubScribed() &&
                        ("${coachAdvanced?.productIdentifier}" ==
                            "${SubKeys.coach_advanced_annual}"),
                    d: SubDetail(
                      price:
                      "${(annualCoachAdv!.product.priceString)}",
                      perMonth:"",
                      // "${annualCoachAdv!.product.currencyCode} ${(annualCoachAdv!.product.price / 12.0).toStringAsFixed(2)}/month",
                      billType: "Annually",
                      type: "Advanced",
                      color: Color.fromRGBO(182, 9, 27, 1),
                      entitlement1:
                      "Group Bookings (plus BootCamp option)",
                      entitlement2: "Provide coaching nationally",
                      moreFeatureList: [
                        "Virtual and Physical player booking",
                        "Video Bio",
                        "Include Subscribed Player access",
                        "Provide Player Reports"
                      ],
                    ),
                ),
              ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Visibility(
                          visible:coachSubScribed() &&  isCoachAdvActive && isAnnualActive,
                          child: Card(
                            margin: EdgeInsets.all(0),
                            shape: CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.check,
                                size: 14,
                                color: Color.fromRGBO(182, 9, 27, 1),
                              ),
                            ),
                          ),
                        ),
                      )   ],
                  ),
              !isAnnual
                  ? Stack(
                    children : [GestureDetector(
                onTap: () =>  {purchasePackage(monthlyCoachBasic!)},
                child: SubscribtionInfoCard(
                    isCurrent: coachSubScribed() &&
                        ("${coachBasic?.productIdentifier}" ==
                            "${SubKeys.coach_basic_monthly}"),
                    d: SubDetail(
                      price:
                      "${(monthlyCoachBasic!.product.priceString)}",
                      perMonth:"",
                      // "${monthlyCoachBasic!.product.currencyCode} ${(monthlyCoachBasic!.product.price / 1.0).toStringAsFixed(2)}/month",
                      billType: "Monthly",
                      type: "Basic",
                      color: Color.fromRGBO(25, 87, 234, 1),
                      entitlement1:
                      "Virtual and Physical booking options",
                      entitlement2: "Provide Coaching Up to 25 miles",
                      moreFeatureList: [
                        "Includes Basic player access",
                        "Account and Billing"
                      ],
                    ),
                ),
              ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Visibility(
                          visible: coachSubScribed() && isCoachBasicActive && isMonthlyActive,
                          child: Card(
                            margin: EdgeInsets.all(0),
                            shape: CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.check,
                                size: 14,
                                color: Color.fromRGBO(182, 9, 27, 1),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                  : Stack(
                    children: [GestureDetector(
                onTap: () => {purchasePackage(annualCoachBasic!)},
                child: SubscribtionInfoCard(
                    isCurrent: coachSubScribed() &&
                        ("${coachBasic?.productIdentifier}" ==
                            "${SubKeys.coach_basic_annual}"),
                    d: SubDetail(
                      price:
                      "${(annualCoachBasic!.product.priceString)}",
                      perMonth:"",
                      // "${annualCoachBasic!.product.currencyCode} ${(annualCoachBasic!.product.price / 12.0).toStringAsFixed(2)}/month",
                      billType: "Annually",
                      type: "Basic",
                      color: Color.fromRGBO(25, 87, 234, 1),
                      entitlement1:
                      "Virtual and Physical booking options",
                      entitlement2: "Provide Coaching Up to 25 miles",
                      moreFeatureList: [
                        "Includes Basic player access",
                        "Account and Billing"
                      ],
                    ),
                ),
              ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Visibility(
                          visible:coachSubScribed() &&  isCoachBasicActive && isAnnualActive,
                          child: Card(
                            margin: EdgeInsets.all(0),
                            shape: CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.check,
                                size: 14,
                                color: Color.fromRGBO(182, 9, 27, 1),
                              ),
                            ),
                          ),
                        ),
                      )],
                  ),
              verticalSpace(height: 64),
              Center(child: mediumText(SubKeys.subText, size: 12)),
            ],
          );
        });
  }

  Widget buildPlayerSubBody() {
    return


      FutureBuilder<PlayerPackages>(
        future: getPlayerOfferings(),

        builder: (context, snapshot) {

          if (snapshot == null) {
            return Container(
              child: Center(
                child: Column(
                  children: [
                    mediumText("Unable to Fetch Subscription Packages"),
                  ],
                ),
              ),
            );
          }
          if (snapshot.data == null  ) {
            return Container(
              height: 600,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    mediumText("Fetching Subscription Packages"),
                    verticalSpace(),
                    CupertinoActivityIndicator(),
                  ],
                ),
              ),
            );
          }

          if ( isLoading  ) {
            return Container(
              height: 600,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    mediumText("Fetching Package..."),
                    verticalSpace(),
                    CupertinoActivityIndicator(),
                  ],
                ),
              ),
            );
          }

          playerPackages = snapshot.data;
          Package? monthlyPlayer = playerPackages!.monthly;
          Package? monthlyPlayerTrial = playerPackages!.monthlyTrial;
          Package? annualPlayer = playerPackages!.annual;
          Package? annualPlayerTrial = playerPackages!.annualTrial;

           return monthlyPlayer == null || annualPlayer == null
              ? Container(
            child: Center(
              child: Column(
                children: [
                  mediumText("Unable to Fetch Subscription Packages.."),
                ],
              ),
            ),
          )
              : Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap:() {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => _buildPopupDialog(context),
                              );
                            },
                            child:
                            Padding(  padding: const EdgeInsets.only(left: 0, right: 10),
                               child:
                               Container(
                                 width: 15,
                                 height: 40,
                                 child:Image.asset("assets/info.png") ,
                               )
                             // Center(child: mediumText(SubKeys.subText, size: 12)  ),
                              ),
                          ),
                          boldText("Monthly",
                              color:
                              isAnnual ? Colors.grey : Colors.black,
                              size: 14),
                          Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                                trackColor: normalBlue,
                                activeColor: normalBlue,
                                value: isAnnual,
                                onChanged: (v) {
                                  setState(() {
                                    isAnnual = v;
                                  });
                                }),
                          ),
                          boldText("Annual",
                              color:
                              isAnnual ? Colors.black : Colors.grey,
                              size: 14),
                          horizontalSpace(),
                          mediumText('Save 10%', color: red, size: 12),
                        ],
                      ),
                    ),
                    //


                  ],
                ),
              ),
              verticalSpace(height: 16),
              ////FIRST MONTHLY !

              Visibility(
                visible: !isAnnual,
                child: Stack(
                  children:[
                    GestureDetector(
                    onTap: () => {purchasePackage(monthlyPlayer)},
                    // isPlayerBasicActive && isMonthlyActive
                    //     ? () {}
                    //     : () => purchasePackage(monthlyPlayer),
                    child: SubscribtionInfoCard(
                      isCurrent: isPlayerBasicActive &&
                          ("${playerBasic?.productIdentifier}" ==
                              "${SubKeys.player_basic_monthly}"),
                      d: SubDetail(
                        type: "Subscription",
                        price: "${(monthlyPlayer.product.priceString)}",
                        perMonth:"",
                        // "${monthlyPlayer.product.currencyCode} ${(monthlyPlayer.product.price / 1.0).toStringAsFixed(2)}/month",
                        billType: "Monthly",
                        color: blue,
                        entitlement1: "Buddy up with other players",
                        entitlement2: "1 on 1 challenge other players",
                        moreFeatureList: [
                          "Enjoy Challenge mode",
                          "Group bookings with friends",
                          "Choose Multiple Sports",
                        ],
                      ),
                    ),
                  ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Visibility(
                        visible: isMonthlyActive && currentSubManager.isTrialOver,
                        child: Card(
                          margin: EdgeInsets.all(0),
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.check,
                              size: 14,
                              color: Color.fromRGBO(182, 9, 27, 1),
                            ),
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ),

              ////SECOND MONTHLY WITH TRIAL  !
              Visibility(
                visible: !isAnnual && monthlyPlayerTrial != null ,
                child: Stack(
                  children:[
                    GestureDetector(
                      onTap: () => {purchasePackage(monthlyPlayerTrial!)},
                      child: SubscribtionInfoCard(
                        isCurrent: isPlayerBasicActive && ("${playerBasic?.productIdentifier}" ==  "${SubKeys.player_basic_monthly_trial}"),
                        d: SubDetail(
                          type: "30 Days Free Trial ",
                          price: "Access subscription features",
                          perMonth:"",
                          // "${monthlyPlayerTrial!.product.currencyCode} ${(monthlyPlayerTrial.product.price / 1.0).toStringAsFixed(2)}/month",
                          billType: "Monthly",
                          color: red,
                          entitlement1: "Buddy up with other players",
                          entitlement2: "1 on 1 challenge other players",
                          moreFeatureList: [
                            "Enjoy Challenge mode",
                            "Group bookings with friends",
                            "Choose Multiple Sports",
                            "Monthly or annual subscription is required to access all Coach & Me features.\n After the 30 day free trial period, the subscription will automatically switch to the standard subscription."

                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Visibility(
                        visible: isMonthlyActive && !currentSubManager.isTrialOver,
                        child: Card(
                          margin: EdgeInsets.all(0),
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.check,
                              size: 14,
                              color: Color.fromRGBO(182, 9, 27, 1),
                            ),
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ),
              Visibility(
                visible: isAnnual,
                child:
                Stack(
                  children: [GestureDetector(
                    onTap: () => {purchasePackage(annualPlayer)} ,
                    //   isPlayerBasicActive  && isAnnualActive
                    //     ? null
                    //     : () => purchasePackage(annualPlayer),
                    child: SubscribtionInfoCard(
                      isCurrent: isPlayerBasicActive &&
                          ("${playerBasic?.productIdentifier}" ==
                              "${SubKeys.player_basic_annual}"),
                      d: SubDetail(
                        type: "Annual ",
                        expendedMoreFeatures: true,
                        price: "${(annualPlayer.product.priceString)}",
                        perMonth:
                        "",//${annualPlayer.product.currencyCode} ${(annualPlayer.product.price / 12.0).toStringAsFixed(2)}/month
                        billType: "Subscription",
                        color: blue,
                        entitlement1: "Buddy up with other players",
                        entitlement2: "1 on 1 challenge other players",
                        moreFeatureList: [
                          "Enjoy Challenge mode",
                          "Group bookings with friends",
                          "Choose Multiple Sports",

                        ],
                      ),
                    ),
                  ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Visibility(
                        visible: isAnnualActive,
                        child: Card(
                          margin: EdgeInsets.all(0),
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.check,
                              size: 14,
                              color: Color.fromRGBO(182, 9, 27, 1),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // Visibility(
              //   visible: isAnnual && annualPlayerTrial != null,
              //   child:
              //   Stack(
              //     children: [GestureDetector(
              //       onTap: () => {purchasePackage(annualPlayerTrial!)} ,
              //
              //       child: SubscribtionInfoCard(
              //         isCurrent: isPlayerBasicActive &&
              //             ("${playerBasic?.productIdentifier}" ==
              //                 "${SubKeys.player_basic_annual}"),
              //         d: SubDetail(
              //           type: "Subscription ",
              //           price: "Free",
              //           perMonth:
              //           "${annualPlayerTrial!.product.currencyCode} ${(annualPlayerTrial.product.price / 12.0).toStringAsFixed(2)}/month",
              //           billType: "Annually",
              //           color: red,
              //           entitlement1: "Buddy up with other players",
              //           entitlement2: "1 on 1 challenge other players",
              //           moreFeatureList: [
              //             "Enjoy Challenge mode",
              //             "Group bookings with friends",
              //             "Choose Multiple Sports",
              //             "Monthly or annual subscription is required to access all Coach & Me features.\n After the 30 day free trial period, the subscription will automatically switch to the standard subscription."
              //
              //           ],
              //         ),
              //       ),
              //     ),
              //       Positioned(
              //         top: 0,
              //         right: 0,
              //         child: Visibility(
              //           visible: isAnnualActive,
              //           child: Card(
              //             margin: EdgeInsets.all(0),
              //             shape: CircleBorder(),
              //             child: Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Icon(
              //                 Icons.check,
              //                 size: 14,
              //                 color: Color.fromRGBO(182, 9, 27, 1),
              //               ),
              //             ),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),

              Padding(  padding: const EdgeInsets.only(left: 10.0, right: 0),
                child:
                GestureDetector(
                  onTap:  () => {   } ,
                  child:  isPlayerBasicActive
                      ? buildFreeVersion()
                      : buildCheckedTile(child: buildFreeVersion()),
                ),




              ),
              verticalSpace(height: 20),
              // GestureDetector(
              //   onTap:() {
              //     showDialog(
              //       context: context,
              //       builder: (BuildContext context) => _buildPopupDialog(context),
              //     );
              //   },
              //
              //   child:
              //
              //   Padding(  padding: const EdgeInsets.only(left: 10.0, right: 0),
              //     child:
              //     Container(
              //       width: 20,
              //    child:Image.asset("assets/info.png") ,
              //    )
              //    // Center(child: mediumText(SubKeys.subText, size: 12)  ),
              //   ),),
            ],
          );
        });
  }
  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
       content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          mediumText(SubKeys.subText, size: 14),
        ],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            pushRoute(context, TermsPage());
          },
          style:TextButton.styleFrom(
                textStyle: TextStyle(color: Theme.of(context).primaryColor)
          ),
           child: const Text('Terms and conditions'),
        ),
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style:TextButton.styleFrom(
              textStyle: TextStyle(color: Theme.of(context).primaryColor)
          ),
          child: const Text('Close'),
        ),
      ],
    );
  }

  purchasePackage(Package package) async {
    setState(() {
      isLoading = true;
    });
    try {
      PurchaserInfo purchaserInfo = await Purchases.purchasePackage(package);
      print("puchaser.....${purchaserInfo.entitlements}");
      buildDialogue("${package.product.title}");
      CurrentSubManager c = await getOldPurchases();

      if (c.isPlayerBasicActive || c.isCoachBasicActive || c.isCoachAdvActive) {
        print("puchaser.....${purchaserInfo.entitlements}....sucessss");

        widget.toDoAfterSucessfulPayment();
        updateSub();
        var u = context.read<UIProvider>();
        await u.setIsSubScribed();
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } on PlatformException catch (e) {
       print("error.in puchase..$e");
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        buildErroorDialogue("Purchase was cancelled");
      } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
        buildErroorDialogue("Purchase was not allowed");
      }else{
        buildErroorDialogue(""+e.message!);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget buildFreeVersion() {
    return

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Free Version",
                    style: TextStyle(fontWeight: FontWeight.w500)
                  ),
                  Text(
                    "- Limited Features\n- Book Coaches\n- record your performance",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }

  Widget buildCheckedTile({
    Widget? child,
    double height: 100,
  }) {
    return Container(
      width: double.infinity,
      height: height,
      child: Stack(
        // fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(182, 9, 27, 1),
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: child
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Card(
              margin: EdgeInsets.all(0),
              shape: CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.check,
                  size: 14,
                  color: Color.fromRGBO(182, 9, 27, 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildDialogue(String text) {
    showCupertinoDialog(
      context: context,
      builder: (c) => CupertinoAlertDialog(
        title: Text("Thanks for Subscribing"),
        content: Text("You have successfully subscribed for $text plan."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(c);
              // Navigator.pop(context);
            },
            child: Text("Continue"),
          )
        ],
      ),
    );
  }

  buildErroorDialogue(String text) {
    showCupertinoDialog(
        context: context,
        builder: (c) => CupertinoAlertDialog(
          title: Text("Unable to process subscription"),
          content: Text("$text"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(c);
              },
              child: Text("Continue"),
            )
          ],
        ));
  }
}
