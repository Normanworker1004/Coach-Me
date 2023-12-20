import 'dart:convert';
import 'dart:typed_data';

import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/user_update.dart';
import 'package:cme/network/coach/request.dart';
import 'package:cme/register/whats_ur_gender.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:cme/app.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:cme/utils/navigate_effect.dart';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ChooseAvtar extends StatefulWidget {
  final UserModel? userModel;

  const ChooseAvtar({Key? key, required this.userModel}) : super(key: key);
  @override
  _ChooseAvtarState createState() => _ChooseAvtarState();
}

class _ChooseAvtarState extends State<ChooseAvtar> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  int? selectedIndex;

  String bodyImageUrl = App.img_upload_pic;
  List<String> imgList = [
    App.ic_funny_man,
    App.ic_women,
    App.ic_women_pink,
    App.ic_man1,
    App.ic_man2,
    App.ic_man3,
  ];
  UserModel? userModel;

  bool uploadImage = false;

  @override
  void initState() {
    super.initState();

    userModel = widget.userModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: themeBkg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeBkg,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(90, 0, 90, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Steps 6/10",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w100),
              ),
              StepProgressIndicator(
                totalSteps: 10,
                currentStep: 6,
                size: 6.0,
                padding: 0,
                selectedColor: colorActiveProgress,
                unselectedColor: colorInActiveProgress,
                roundedEdges: Radius.circular(10),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontFamily: App.font_name,
                        letterSpacing: 0.0),
                    children: <TextSpan>[
                      TextSpan(text: 'Choose your '),
                      TextSpan(
                          text: 'Avatar',
                          style: TextStyle(color: colorActiveBtn)),
                    ],
                  ),
                ),
                SizedBox(height: 13),
                Center(
                  child: Text(
                    "Choose an avatar to represent you on your Coach&Me profile",
                    // "To give you a better experience we need",
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w100,
                      color: Colors.black,
                      fontFamily: App.font_name,
                      letterSpacing: 0.0,
                     ),
                  ),
                ),
                Center(
                  child: Text("you to upload your picture",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w100,
                          color: Colors.black,
                          fontFamily: App.font_name,
                          letterSpacing: 0.0)),
                ),
                SizedBox(
                  height: 30,
                ),
                // Center(
                //   child: Container(
                //     width: 150,
                //     height: 150,
                //     child: Card(
                //       shape: CircleBorder(),
                //       child: Center(
                //         child: Image.asset(
                //           bodyImageUrl,
                //           alignment: Alignment.center,
                //           width: 150,
                //           // height: 120,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                Container(
                  width: 76,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                        image: AssetImage(bodyImageUrl),
                      )),
                  //
                ),
                SizedBox(
                  height: 55,
                ),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    itemCount: imgList.length,
                    padding: EdgeInsets.all(8.0),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                bodyImageUrl = imgList[index];
                              });
                            },
                            child: avtarIcon(selectedIndex == index, index)),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 55,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            // right: 0,
            left: 16,
            child: InkWell(
              child: Text(
                "    ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 19.0,
                    fontWeight: FontWeight.w100,
                    fontFamily: App.font_name),
              ),
              onTap: () {
                // print("inside back");
             //  Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            bottom: 16,
            right: 0,
            left: 0,
            child: Center(
              child: Container(
                width: 121,
                decoration: BoxDecoration(
                    color:
                        selectedIndex == null ? colorDisable : colorActiveBtn,
                    borderRadius: BorderRadius.circular(30.0)),
                child: TextButton(
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  onPressed: selectedIndex == null
                      ? null
                      : () {
                          uploadProfileImage(context);
                          // goToNext();
                        },
                ),
              ),
            ),
          ),
          Center(
            child: Visibility(
              visible: uploadImage,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget avtarIcon(selected, index) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              ClipRRect(
                child: Image.asset(
                  imgList[index],
                  height: 100,
                  width: 76,
                  fit: BoxFit.contain,
                  alignment: Alignment.topLeft,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          child: Visibility(
            visible: selected,
            child: Card(
              shape: CircleBorder(),
              child: Icon(
                Icons.check,
                color: deepRed,
              ),
            ),
          ),
        )
      ],
    );
  }

  goToNext() async {
    await Navigator.push(context,
        NavigatePageRoute(context, SelectGender(from: runtimeType.toString())));
  }

  void uploadProfileImage(BuildContext context) async {
    try {
      ByteData bytes = await rootBundle.load(imgList[selectedIndex!]);
      var buffer = bytes.buffer;
      var img64 = base64.encode(Uint8List.view(buffer));

      setState(() {
        uploadImage = true;
      });

      showSnack(context, "Image Uploading.....", seconds: 2);
      var map = {
        "image": img64,
        "name": "${userModel!.getUserDetails()!.name}.jpg".replaceAll(" ", "") // png important
      };
      var url = baseUrl + "api/general/uploadimage";
      http.Response r = await http.post(
        Uri.parse(url),
        body: map,
        headers: {
          "x-access-token": userModel!.getAuthToken()!,
        },
      );
      var pro = UserUpdate.fromJson(jsonDecode(r.body));

      print("${pro.message}++++++++++++++++++");

      showSnack(context, pro.message);
      setState(() {
        uploadImage = false;
      });

      if (pro.message == "Image updated Successfully") {
        print("Can proceed++++++");
        await Future.delayed(Duration(seconds: 2));
        goToNext();
      }
    } catch (e) {
      setState(() {
        uploadImage = false;
      });

      showSnack(context, "Upload Failed..Image too Large."+e.toString());
    }
  }
}
