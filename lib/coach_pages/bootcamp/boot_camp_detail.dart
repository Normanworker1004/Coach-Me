import 'package:cme/app.dart';
import 'package:cme/coach_pages/bootcamp/edit_boot_camp_page.dart';
import 'package:cme/model/map_bootcamp_response.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:cme/ui_widgets/icon_title.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:cme/utils/player_points.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BootCampDetailPage extends StatefulWidget {
  final BootCampDetails bootCampDetails;

  const BootCampDetailPage({Key? key, required this.bootCampDetails})
      : super(key: key);

  @override
  _BootCampDetailPageState createState() => _BootCampDetailPageState();
}

class _BootCampDetailPageState extends State<BootCampDetailPage> {
  BootCampDetails? bootCampDetails;

  @override
  void initState() {
    super.initState();
    bootCampDetails = widget.bootCampDetails;
  }

  @override
  Widget build(BuildContext context) {
    return buildBaseScaffold(
      context: context,
      body: buildBody(context),
      title: "Boot Camp",
    );
  }

  Widget buildBody(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 78.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildCard(
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${bootCampDetails!.bootCampName}",
                              style: Style.titleTitleTextStyle,
                            ),
                            verticalSpace(height: 4),
                            iconTitle(
                                "assets/booking_clock.png",
                                "${toDate(bootCampDetails!.bootCampDate)}",
                                Colors.red),
                            verticalSpace(height: 4),
                            iconTitleExpanded(
                              "assets/map_pin.png",
                              "${bootCampDetails!.location}",
                              Color.fromRGBO(25, 87, 234, 1),
                            ),
                          ],
                        ),
                      ),
                      CircularPercentIndicator(
                        radius: 69.0,
                        lineWidth: 8.0,
                        percent: bootCampDetails!.joinedbootcamp!.length /
                            bootCampDetails!.capacity!,
                        center: Container(
                          width: 120,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/bnb4a.png",
                                  height: 10,
                                ),
                                horizontalSpace(width: 4),
                                Expanded(
                                  child: Text(
                                    "${bootCampDetails!.joinedbootcamp!.length} /${bootCampDetails!.capacity}",
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w100,
                                      fontFamily: App.font_name,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        progressColor: normalBlue,
                        backgroundColor: Colors.lightBlue.withOpacity(.1),
                      )
                    ],
                  ),
                ),
              ),
              verticalSpace(height: 16),
              boldText("Players Attending Bootcamp"),
              verticalSpace(height: 16),
              Expanded(
                child: ListView(
                  children: List.generate(
                    bootCampDetails!.joinedbootcamp!.length,
                    (index) {
                      var d = bootCampDetails!.joinedbootcamp![index];
                      var u = d.playerinfo!;
                      return Column(
                        children: [
                          Row(
                            children: [
                              CircularNetworkImage(
                                imageUrl: "${photoUrl + u.profilePic!}",
                              ),
                              horizontalSpace(),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    boldText("${u.name}", size: 14),
                                    lightText(
                                      "${getSportLevel(u, sport: bootCampDetails!.sport)}",
                                      size: 12,
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                              ),
                              Image.asset(
                                "assets/check2.png",
                                scale: 1.2,
                              )
                            ],
                          ),
                          verticalSpace(height: 16)
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: borderProceedButton(
            text: "Edit Boot Camp",
            onPressed: () async {
              pushRoute(
                  context,
                  EditBootCampPage(
                    bootCampDetails: bootCampDetails,
                  ));
            },
            color: normalBlue,
          ),
        )
      ],
    );
  }
}
