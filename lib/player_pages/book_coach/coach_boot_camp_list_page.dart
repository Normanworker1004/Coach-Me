import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/map_bootcamp_response.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:cme/ui_widgets/icon_title.dart';
import 'package:cme/ui_widgets/textfield_with_card.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:cme/utils/functions.dart';
import 'package:flutter/material.dart';

class CoachBootCampListPage extends StatefulWidget {
  final List<BootCampDetails>? bootCampList;
  final List<Userdetails> coachList;
  final UserModel? userModel;

  const CoachBootCampListPage({
    Key? key,
    required this.bootCampList,
    required this.coachList,
    required this.userModel,
  }) : super(key: key);
  @override
  _CoachBootCampListPageState createState() => _CoachBootCampListPageState();
}

class _CoachBootCampListPageState extends State<CoachBootCampListPage> {
  List<BootCampDetails>? bootCampList;
  late List<Userdetails> coachList;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    try {
      bootCampList = widget.bootCampList;
      coachList = widget.coachList;
    } catch (c) {
      print("errror...$c");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 32),
      child: buildBaseScaffold(
        color: bgGrey,
        // title: "You can expect to pay £75-100/hour for a top coach",
        title: " List of coaches near you.",
        // title: "Find Coach/Boot Camp",
        context: context,
        body: Column(
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  child: buildCardedTextField(
                    hintText: "Search for a Coach and Boot Camp",
                    color: white,
                    textColor: Colors.grey,
                    controller: searchController,
                    onChange: (text) {
                      if (text.isEmpty) {
                        setState(() {
                          bootCampList = widget.bootCampList;
                        });
                        return;
                      }
                      List<BootCampDetails> c = [];

                      for (var i in widget.bootCampList!) {
                        if (i.bootCampName!.toLowerCase().contains("$text")) {
                          c.add(i);
                        }
                      }
                      List<Userdetails> coah = [];

                      for (var i in widget.coachList) {
                        if (i.name!.toLowerCase().contains("$text")) {
                          coah.add(i);
                        }
                      }

                      setState(() {
                        bootCampList = c;
                        coachList = coah;
                      });
                    },
                  ),
                ),
              ],
            ),
            verticalSpace(height: 16),
            Expanded(
              child: ListView(
                children: [
                  Column(
                      children: List.generate(coachList.length, (index) {
                    var d = coachList[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context, d);
                      },
                      child: buildCoachSearchItem(d, widget.userModel!.getUserDetails()!,
                          sport: "football"),
                    );
                  })),
                  Column(
                    children: List.generate(
                      bootCampList!.length,
                      (index) {
                        var bc = bootCampList![index];
                        var d = bc.coachDetails!;
                        var p = bc.coachProfile;
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context, bc);
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircularNetworkImage(
                                    imageUrl: "${photoUrl + d.profilePic!}",
                                    size: 48,
                                  ),
                                  horizontalSpace(),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        boldText("${d.name}", size: 16),
                                        mediumText(
                                          "${bc.bootCampName}",
                                          size: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.star, size: 12),
                                                horizontalSpace(width: 4),
                                                mediumText(
                                                    "${(p?.rating ?? 0).toStringAsFixed(1)}",
                                                    size: 12),
                                              ],
                                            ),
                                            horizontalSpace(),
                                            Expanded(
                                              child: iconTitleExpanded(
                                                "assets/booking_clock.png",
                                                "${toDateNormal(bc.bootCampDate)}",
                                                red,
                                              ),
                                            ),
                                            horizontalSpace(width: 4),
                                            Expanded(
                                              child: iconTitleExpanded(
                                                "assets/map_pin.png",
                                                "${bc.location}",
                                                blue,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Divider(),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
