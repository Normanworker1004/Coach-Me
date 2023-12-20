import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/coach_pages/coach_bio/upload_document.dart';
import 'package:cme/map/pick_location.dart';
import 'package:cme/model/bnb_item.dart';
import 'package:cme/model/coach_bio_full_response.dart';
import 'package:cme/network/coach/bio.dart';
import 'package:cme/ui_widgets/build_card_input.dart';
import 'package:cme/ui_widgets/build_filter_card.dart';
import 'package:cme/ui_widgets/build_tooltip.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/dot_divider.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/address_function.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BioDetailEditorScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  BioSubDetail subD;
  final UserModel? userModel;

  BioDetailEditorScreen({
    Key? key,
    required this.scaffoldKey,
    required this.userModel,
    required this.subD,
  }) : super(key: key);
  @override
  _BioDetailEditorScreenState createState() => _BioDetailEditorScreenState();
}

class _BioDetailEditorScreenState extends State<BioDetailEditorScreen> {
  late GlobalKey<ScaffoldState> scaffoldKey;
  late BioSubDetail subD;
  String? selectedGamePlay;
  String? selectedExpertise;
  String? selectedAgeGroup;
  double? sliderValue;
  TextEditingController? sessionPriceController;
  TextEditingController? aboutMeController;
  String? addressText;
  LatLng? currentLocation;
  int? expLevel;

  bool isLoading = false;

  List<BNBItem> cLevel = [
    BNBItem("Amateur", "assets/badge1.png"),
    BNBItem("Intermediate", "assets/badge2.png"),
    BNBItem("Professional", "assets/badge3.png"),
    BNBItem("Expert", "assets/badge4.png"),
  ];

  List<BNBItem> expertiseList = [
    BNBItem("Endurance", "assets/e1.png"),
    BNBItem("Strength", "assets/e2.png"),
    BNBItem("Conditioning", "assets/e3.png"),
    BNBItem("Weight Loss", "assets/e4.png"),
  ];
  List<BNBItem> gameType = [
    BNBItem("Futsal", "assets/gt1.png"),
    BNBItem("11 a side", "assets/gt2.png"),
    BNBItem("Small Sided", "assets/gt3.png"),
  ];

  List<String> ageGroup = [
    "3-6",
    "7-11",
    "12-17",
    "18+",
  ];

  @override
  void initState() {
    super.initState();
    initAll();
  }

  initAll() async {
    try {
      scaffoldKey = widget.scaffoldKey;
      subD = widget.subD;
      selectedGamePlay = subD.bioGameplay;
      selectedExpertise = subD.bioExpertise;
      selectedAgeGroup = subD.bioAge;
      sliderValue = (subD.bioRadius ?? 25) / 1; //25 / 1;
      sessionPriceController = TextEditingController(text: "${subD.bioPrice}");
      aboutMeController = TextEditingController(text: "${subD.bioAbout}");
      currentLocation = LatLng(
              (subD.bioLat ?? 51.5074) / 1.0, (subD.bioLon ?? 0.1278) / 1.0) ;
      expLevel = subD.bioLevel;
      addressText = subD.bioLocation!.isEmpty
          ? await convertCordinaeToAddress(currentLocation!)
          : subD.bioLocation;

      setState(() {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      verticalSpace(height: 8),
      Row(
        children: [
          mediumText("Coach level", size: 15),
          horizontalSpace(),
          buildToolTip(),
        ],
      ),
      Container(
        height: 120,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (c, index) => InkWell(
                  onTap: () {
                    // showSelectionDialogue();
                    setState(() {
                      expLevel = index;
                    });
                  },
                  child: buildFilterCard(
                      cLevel[index].title, cLevel[index].icon,
                      isSelected: index == expLevel),
                ),
            separatorBuilder: (c, i) => horizontalSpace(),
            itemCount: 4),
      ),
      verticalSpace(height: 16),
      InkWell(
        onTap: () {
          showUploadsBody(context);
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Color.fromRGBO(25, 87, 234, 1)),
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 4),
            child: Center(
              child: boldText("Upload Certificates",
                  color: Color.fromRGBO(25, 87, 234, 1), size: 12),
            ),
          ),
        ),
      ),
      verticalSpace(height: 16),

      buildDivider(),
      Row(
        children: [
          boldText("Choose Location", size: 14),
          horizontalSpace(),
          Expanded(
            child: InkWell(
              onTap: () async {
                var c = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (con) =>
                        PickLoactionPage(currentLocation: currentLocation),
                  ),
                );

                if (c == null) {
                  showSnack(context, "No Location was selected");
                } else {
                  var add = await convertCordinaeToAddress(c);
                  setState(() {
                    currentLocation = c;
                    addressText = add;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 4),
                child: currentLocation == null
                    ? Row(
                        children: [
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: Colors.black)),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                              child: lightText("Open Map"),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: lightText("$addressText",
                                size: 12, color: Colors.black),
                          ),
                          horizontalSpace(width: 4),
                          Image.asset(
                            "assets/edit_red.png",
                            height: 11,
                          )
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
      buildDivider(),
      verticalSpace(),
      Row(
        children: [
          boldText("Radius: 25mi", size: 14),
          horizontalSpace(),
          buildToolTipWithText(
              text:
                  "Estimated Distance between you and propestive Player/Students that can Book a session."),
        ],
      ),
      SizedBox(
        width: double.infinity,
        // TODO: This was where I edited the slider
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 12.0),
            thumbColor: Colors.white,
            overlayColor: Colors.red,
            activeTrackColor: Colors.red,
            inactiveTrackColor: Colors.red[50],
            // overlappingShapeStrokeColor: Colors.red,
            showValueIndicator: ShowValueIndicator.onlyForContinuous,
            valueIndicatorShape: PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: Colors.white,
            valueIndicatorTextStyle: TextStyle(color: Colors.red),
            trackHeight: 1.0,
            // tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 23),
          ),
          child: Slider(
            min: 0,
            max: 100,
            divisions:sliderValue!<50 ? 20 : 2,
            value: sliderValue!,
            // activeColor: Colors.red,
            // thumbColor: CupertinoColors.systemRed,
            label: "$sliderValue",
            onChanged: (v) {
              setState(() {
                sliderValue = v.roundToDouble();
              });
            },
          ),
        ),
      ),
      Row(
        children: <Widget>[
          rLightText("0mi", size: 16),
          Expanded(
              child: Center(
                  child: rLightText(
            "${sliderValue}mi",
            size: 16,
          ))),
          rLightText("National", size: 16),
        ],
      ),
      verticalSpace(height: 16),
      Row(
         children: [
          Text(
            "Your Session Price",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          horizontalSpace(),
          buildToolTipWithText(text: "Price Per Session"),
        ],
      ),
        Align(
          alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(top:8.0,bottom:8.0),
          child: Container(
            width: 110,
            height: 56,
            child: buildInputField("",
                prefix: mediumText("£ "),
                hideTitle: true,
                controller: sessionPriceController,
                numbersOnly:true),

          ),
        ),
      ),
      verticalSpace(height: 18),
      buildInputField(
        "About Me",
        hideTitle: false,
        maxLines: 8,
        controller: aboutMeController,
      ),
      verticalSpace(height: 16),
      Text(
        "Select Age Groups",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      verticalSpace(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          ageGroup.length,
          (index) => InkWell(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              setState(() {
                selectedAgeGroup = ageGroup[index];
              });
            },
            child: ageGroup[index] != selectedAgeGroup
                ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                          color: Color.fromRGBO(
                              229, 229, 231, 1), //rgba(229, 229, 231, 1)
                        ),
                        color: white),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 4),
                      child: Text(ageGroup[index]),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        // border:
                        //     Border.all(color: Colors.grey),
                        color: Color.fromRGBO(25, 87, 234, 1)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 4),
                      child: Text(
                        ageGroup[index],
                        style: TextStyle(color: white),
                      ),
                    ),
                  ),
          ),
        ),
      ),
      verticalSpace(height: 16),
      Text(
        "Select Expertise",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      // verticalSpace(height: 16),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 100,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (c, index) {
                BNBItem item = expertiseList[index];
                bool isSelected =
                    selectedExpertise!.toLowerCase() == item.title.toLowerCase();

                return InkWell(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    setState(() {
                      if(selectedExpertise == item.title)
                        selectedExpertise = "";
                      else
                      selectedExpertise = item.title;
                    });
                  },
                  child: buildFilterCardColored(
                    text: expertiseList[index].title,
                    image: expertiseList[index].icon,
                    bgColor: isSelected
                        ? Color.fromRGBO(25, 87, 234, 1)
                        : Colors.white,
                    imageColor: !isSelected
                        ? Color.fromRGBO(25, 87, 234, 1)
                        : Colors.white,
                    textColor: !isSelected ? Colors.black : Colors.white,
                  ),
                );
              },
              separatorBuilder: (c, i) => horizontalSpace(),
              itemCount: expertiseList.length),
        ),
      ),
      verticalSpace(height: 16),
      Text(
        "Select Gameplay Type",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      // verticalSpace(height: 16),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 100,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (c, index) {
                BNBItem item = gameType[index];
                bool isSelected =
                    selectedGamePlay!.toLowerCase() == item.title.toLowerCase();
                return InkWell(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    setState(() {
                      selectedGamePlay = item.title;
                    });
                  },
                  child: buildFilterCardColored(
                    text: gameType[index].title,
                    image: gameType[index].icon,
                    bgColor: isSelected
                        ? Color.fromRGBO(25, 87, 234, 1)
                        : Colors.white,
                    imageColor: !isSelected
                        ? Color.fromRGBO(25, 87, 234, 1)
                        : Colors.white,
                    textColor: !isSelected ? Colors.black : Colors.white,
                  ),
                );
              },
              separatorBuilder: (c, i) => horizontalSpace(),
              itemCount: gameType.length),
        ),
      ),
      verticalSpace(height: 32),
      proceedButton(
        isLoading: isLoading,
        text: "Save Bio",
        onPressed: () => saveBio(context),
      )
    ]);
  }

  void saveBio(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      isLoading = true;
    });
    var res = await saveCoachBioDetail(
      widget.userModel!.getAuthToken(),
      bioid: "${subD.id}",
      sport: "${subD.sport}",
      level: "$expLevel",
      lat: "${currentLocation!.latitude}",
      lon: "${currentLocation!.longitude}",
      location: "$addressText",
      radius: "${sliderValue!.floor()}",
      sessionPrice: "${sessionPriceController!.text}",
      ageGroup: "$selectedAgeGroup".toLowerCase(),
      expertise: "$selectedExpertise".toLowerCase(),
      gamePlay: "$selectedGamePlay".toLowerCase(),
      aboutme: "${aboutMeController!.text}",
    );

    setState(() {
      isLoading = false;
    });

    showSnack(
        context,
        res.status!
            ? "${subD.sport} Details updated"
            : "${subD.sport} Details update failed");
  }

  void showUploadsBody(context) {
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (BuildContext bc) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * .65,
          child: SafeArea(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              child: Card(
                margin: EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: UploadCertificate(
                    userModel: widget.userModel,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
