import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/coach_pages/coach_bio/editor_screen.dart';
import 'package:cme/model/coach_bio_full_response.dart';
import 'package:cme/model/user_class/profile_details.dart';
import 'package:cme/model/user_class/sport.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/network/coach/bio.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:cme/ui_widgets/dropdowns/custom_time_drodown.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
//import 'package:smooth_star_rating/smooth_star_rating.dart';

class EditBioPage extends StatefulWidget {
  final UserModel? userModel;

  const EditBioPage({
    Key? key,
    required this.userModel,
  }) : super(key: key);
  @override
  _EditBioPageState createState() => _EditBioPageState();
}

class _EditBioPageState extends State<EditBioPage> {
  UserModel? userModel;
  String? selectedSport = "";

  Sport? sport;
  Userdetails? userdetails;
  Profiledetails? profile;
  int currentSportIndex = 0;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  List<BioSubDetail>? bioSubDetaiList;

  fetchDataFromServer() async {
    userModel = widget.userModel;
    userdetails = userModel!.getUserDetails();
    profile = userModel!.getUserProfileDetails();
    CoachBioFullInfoResponse c =
        await fetchCompleteBio(userModel!.getAuthToken());
    bioSubDetaiList = c.bioSubDetaiList;
    if (c.status!) {
      selectedSport = bioSubDetaiList!.first.sport;
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    fetchDataFromServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: buildBaseScaffold(
        context: context,
        body: buildBody(context),
        title: "Edit Bio",
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top:8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircularNetworkImage(
                    imageUrl: "${photoUrl + userdetails!.profilePic!}",
                    size: 115,
                  ),
                  horizontalSpace(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left:2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 2),
                            child: boldText("${userdetails!.name}"),
                          ),
                          SmoothStarRating(
                            color: Color.fromRGBO(25, 87, 234, 1),
                            rating: (profile?.rating ?? 0) / 1, // 5,
                            starCount: 5,
                         //   isReadOnly: true,
                            spacing: -3.5,
                          ),
                          verticalSpace(),
                          Row(children: <Widget>[
                            textColumn("${(profile?.rating ?? 0).toStringAsFixed(1)}", "Rating"),
                            horizontalSpace(width: 32),
                            textColumn("${profile?.session ?? 0}", "Session"),
                          ]),
                          verticalSpace(),
                          Row(
                            children: <Widget>[
                              bioSubDetaiList != null
                                  ? Container(
                                      width: 100,
                                      height: 32,
                                      child: CustomBioDropDown(
                                        onItemChanged: (c) {
                                          if (bioSubDetaiList == null) {
                                            return;
                                          }
                                          for (var i = 0;
                                              i < bioSubDetaiList!.length;
                                              i++) {
                                            if ("${bioSubDetaiList![i].sport}"
                                                    .toLowerCase() ==
                                                "$c") {
                                              setState(() {
                                                currentSportIndex = i;
                                              });
                                              break;
                                            }
                                          }
                                        },
                                        borderColor: blue,
                                        padding: EdgeInsets.all(4),
                                        selectedItem: selectedSport,
                                        item: bioSubDetaiList == null
                                            ? []
                                            : List.generate(
                                                bioSubDetaiList!.length,
                                                (index) =>
                                                    bioSubDetaiList![index].sport,
                                              ),
                                      ),
                                    )
                                  : Container(),
                              horizontalSpace(),
                              Container(
                                height: 32,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color.fromRGBO(25, 87, 234, 1)),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 8),
                                  child: boldText("Upload Video",
                                      color: Color.fromRGBO(25, 87, 234, 1),
                                      size: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              bioSubDetaiList == null
                  ? Container(
                      height: 400,
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    )
                  : IndexedStack(
                      index: currentSportIndex,
                      children: List.generate(
                        bioSubDetaiList!.length,
                        (index) => BioDetailEditorScreen(
                          scaffoldKey: _key,
                          subD: bioSubDetaiList![index],
                          userModel: userModel,
                        ),
                      ),
                    )
            ],
          ),
        ),
        verticalSpace(height: 32),
      ],
    );
  }
}

Widget textColumn(text1, text2) {
  return Column(
    children: <Widget>[
      Text(
        "$text1",
        style: TextStyle(
          fontFamily: "ROBOTO",
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      boldText("$text2", color: Colors.grey, size: 10),
    ],
  );
}
