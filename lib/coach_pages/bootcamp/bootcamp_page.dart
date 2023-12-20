import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/coach_pages/bootcamp/boot_camp_detail.dart';
import 'package:cme/coach_pages/bootcamp/create_boot_camp_page.dart';
import 'package:cme/model/fetch_coach_bootcamp_response.dart';
import 'package:cme/network/coach/request.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/icon_title.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class BootCampPage extends StatefulWidget {
  @override
  _BootCampPageState createState() => _BootCampPageState();
}

class _BootCampPageState extends State<BootCampPage> {
  FetchCoachBootCampResponse? bootCamp;
  late UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (c, widget, model) {
        userModel = model;
        return buildBaseScaffold(
          context: context,
          body: buildBody(context),
          title: "Boot Camp",
        );
      },
    );
  }

  Widget buildBody(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        await Future.delayed(Duration(seconds: 3));
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 78.0),
            child: FutureBuilder<FetchCoachBootCampResponse>(
                future: fetchBootCamp(userModel.getAuthToken()!),
                builder: (context, snapshot) {
                  if (snapshot == null) {
                    return Center(
                      child: Text("Unable to Load Boot Camp"),
                    );
                  } else {
                    if (snapshot.data == null) {
                      return Center(child: CupertinoActivityIndicator());
                    } else {
                      bootCamp = snapshot.data;

                      if (bootCamp!.details == null ||
                          bootCamp!.details!.isEmpty) {
                        return Center(child: Text("Start a Boot Camp Now"));
                      } else {
                        return ListView.builder(
                          itemCount: bootCamp!.details!.length,
                          itemBuilder: (c, i) {
                            var d = bootCamp!.details![i];
                            // print(d.bootCampDate);
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await pushRoute(
                                      context,
                                      BootCampDetailPage(
                                        bootCampDetails: d,
                                      ),
                                    );

                                    setState(() {});
                                  },
                                  child: buildBootCampCard(
                                      d.bootCampName!,
                                      d.joinedbootcamp!.length,
                                      d.capacity,
                                      d.location!,
                                      d.bootCampDate),
                                ),
                                verticalSpace(height: 16)
                              ],
                            );
                          },
                        );
                      }
                    }
                  }
                }),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: borderProceedButton(
              text: "Create Boot Camp",
              onPressed: () async {
                await pushRoute(context, CreateBootCampPage());
                setState(() {});
              },
              color: normalBlue,
            ),
          )
        ],
      ),
    );
  }

  Widget buildBootCampCard(String description, int registeredCount,
      int? capacity, String location, String? bootCampDate) {
    return buildCard(
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              description,
              // "Speed Drills Session",
              style: Style.titleTitleTextStyle,
            ),
            // verticalSpace(height: 4),
            Row(
              children: [
                Image.asset(
                  "assets/bnb4a.png",
                  width: 9,
                  height: 10,
                ),
                horizontalSpace(),
                Text(
                  "$registeredCount/$capacity Signups",
                  style: TextStyle(
                    fontWeight: FontWeight.w100,
                    color: Color.fromRGBO(
                        153, 153, 153, 1), //rgba(153, 153, 153, 1)
                    fontFamily: "$registeredCount..$capacity".contains("4")
                        ? App.font_name2
                        : App.font_name,

                    fontSize: 12,
                  ),
                ),
              ],
            ),
            verticalSpace(height: 4),
            Row(
              // direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  child: iconTitleExpanded(
                    "assets/booking_clock.png",
                    "${toDate(bootCampDate)}",
                    Colors.red,
                  ),
                ),
                horizontalSpace(width: 4),
                Expanded(
                  child: iconTitleExpanded(
                    "assets/map_pin.png",
                    location,
                    Color.fromRGBO(25, 87, 234, 1),
                  ), //rgba(25, 87, 234, 1)
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
