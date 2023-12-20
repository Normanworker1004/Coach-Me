import 'package:cme/app.dart';
import 'package:cme/model/map_bootcamp_response.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:cme/ui_widgets/icon_title.dart';
import 'package:cme/ui_widgets/textfield_with_card.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:flutter/material.dart';

class BootCampSearchPage extends StatefulWidget {
  final List<BootCampDetails>? bootCampList;

  const BootCampSearchPage({Key? key, required this.bootCampList})
      : super(key: key);
  @override
  _BootCampSearchPageState createState() => _BootCampSearchPageState();
}

class _BootCampSearchPageState extends State<BootCampSearchPage> {
  List<BootCampDetails>? bootCampList;
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    bootCampList = widget.bootCampList;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 32),
      child: buildBaseScaffold(
        color: bgGrey,
        title: "Find Boot Camp",
        context: context,
        body: Column(
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  child: buildCardedTextField(
                    hintText: "Search for a Boot Camp",
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

                      setState(() {
                        bootCampList = c;
                      });
                    },
                  ),
                ),
              ],
            ),
            verticalSpace(height: 16),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (c, index) => verticalSpace(height: 16),
                itemCount: bootCampList!.length,
                itemBuilder: (context, index) {
                  var bc = bootCampList![index];
                  var d = bc.coachDetails!;
                  var p = bc.coachProfile!;
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context, bc);
                    },
                    child: Row(
                      children: [
                        CircularNetworkImage(
                          imageUrl: "${photoUrl + d.profilePic!}",
                          size: 48,
                        ),
                        horizontalSpace(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      mediumText("${p.rating}", size: 12),
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
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
