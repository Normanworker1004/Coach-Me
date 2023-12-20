import 'dart:convert';
import 'dart:io';

import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/final.dart';
import 'package:cme/model/user_update.dart';
import 'package:cme/network/coach/request.dart';
import 'package:cme/account_pages/edit_profile.dart';
import 'package:cme/intro/splashscreen.dart';
import 'package:cme/register/whats_ur_gender.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:cme/app.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:cme/utils/navigate_effect.dart';

import 'choose_avtar.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class UploadProfilePic extends StatefulWidget {
  @override
  _UploadProfilePicState createState() => _UploadProfilePicState();
}

class _UploadProfilePicState extends State<UploadProfilePic> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  var index;
  UserModel? userModel;

  bool uploadImage = false;
  File? imageSelected;
  @override
  void initState() {
    super.initState();
    index = Final.getId();
    // print("++++++++++++$i++++++++++++");
  }

  @override
  Widget build(BuildContext context) {
    // print("Inside _UploadProfilePicState");
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, NavigatePageRoute(context, GetStartedPage()));
        return false;
      },
      child: ScopedModelDescendant<UserModel>(
        builder: (co, wid, model) {
          userModel = model;
          return Scaffold(
              key: _key,
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
                        index == 1 ? "Steps 5/7" : "Steps 6/10",
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
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
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
                            // TextSpan(text: 'Choose an image for your '),
                            // TextSpan(
                            //     text: 'Coach&Me profile',
                            //     style: TextStyle(color: colorActiveBtn)),
                            TextSpan(text: 'Upload your '),
                            TextSpan(
                              text: 'Profile Picture',
                              style: TextStyle(color: colorActiveBtn),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      // RichText(
                      //   textAlign: TextAlign.center,
                      //   text: TextSpan(
                      //     style: TextStyle(
                      //         fontSize: 28.0,
                      //         fontWeight: FontWeight.w500,
                      //         color: Colors.black,
                      //         fontFamily: App.font_name,
                      //         letterSpacing: 0.0),
                      //     children: <TextSpan>[
                      //       TextSpan(text: 'Choose an image for your '),
                      //       TextSpan(
                      //         text: 'Coach&Me profile',
                      //         style: TextStyle(color: colorActiveBtn),
                      //       ),
                      //       /*  TextSpan(text: 'Upload your '),
                      //       TextSpan(
                      //           text: 'Profile Picture',
                      //           style: TextStyle(color: colorActiveBtn)),*/
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(height: 5),
                      // Text(
                      //   "To give you a better experience we need",
                      //   style: TextStyle(
                      //       fontSize: 16.0,
                      //       fontWeight: FontWeight.w100,
                      //       color: Colors.black,
                      //       fontFamily: App.font_name,
                      //       letterSpacing: 0.0),
                      // ),
                      Text("Choose an image for your Coach&Me profile",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w100,
                              color: Colors.black,
                              fontFamily: App.font_name,
                              letterSpacing: 0.0),),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: 164,
                        height: 164,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(164),
                            image: DecorationImage(
                              image: (imageSelected == null
                                  ? AssetImage(App.img_upload_pic)
                                  : FileImage(imageSelected!)) as ImageProvider<Object>,
                            )),
                        //
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          child: TextButton(
                        onPressed: () {
                          uploadProfileImage(context, ImageSource.camera);
                        },
                            style:TextButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            ),
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Ink(
                            decoration: BoxDecoration(
                                color: colorActiveProgress,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: colorActiveProgress, width: 1.1)),
                            child: Container(
                                constraints: BoxConstraints(minHeight: 60.0),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/camera.png",
                                      width: 22,
                                      height: 18,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      index == 1
                                          ? "Take a Picture"
                                          : "Take a Picture",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontFamily: App.font_name,
                                          fontWeight: FontWeight.w100),
                                    ),
                                  ],
                                )),
                        ),
                         ),
                      )),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                          child: TextButton(
                        onPressed: () {
                          uploadProfileImage(context, ImageSource.gallery);
                          // print("inside print funcation");
                        },
                            style:TextButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Ink(
                            decoration: BoxDecoration(
                                color: colorActiveProgress,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: colorActiveProgress, width: 1.1)),
                            child: Container(
                                constraints: BoxConstraints(minHeight: 60.0),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/cloud.png",
                                      width: 22,
                                      height: 18,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      index == 1
                                          ? "Upload from Camera Roll"
                                          : "Upload from Library",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontFamily: App.font_name,
                                          fontWeight: FontWeight.w100),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      )),
                      Visibility(
                        visible: index == 0,
                        child: Container(
                            child: TextButton(
                          onPressed: () {
                            pushRoute(
                              context,
                              ChooseAvtar(
                                userModel: userModel,
                              ),
                            );
                            // print("inside print funcation");
                          },
                              style:TextButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                              ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                  color: colorActiveProgress,
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                      color: colorActiveProgress, width: 1.1)),
                              child: Container(
                                  constraints: BoxConstraints(minHeight: 60.0),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/avatar.png",
                                        color: Colors.white,
                                        width: 18,
                                        height: 23,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Choose Avatar",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontFamily: App.font_name,
                                            fontWeight: FontWeight.w100),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        )),
                      ),
                      verticalSpace(),
                      AnimatedOpacity(
                        opacity: uploadImage ? 1.0 : 0.0,
                        duration: Duration(seconds: 1),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
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
                        // Navigator.pushReplacement(context,
                        //     NavigatePageRoute(context, GetStartedPage()));
                      },
                    ),
                  ),
                  Container(
                    width: 121,
                    decoration: BoxDecoration(
                        color: colorActiveBtn,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: TextButton(
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        goToNext();
                      },
                    ),
                  ),
                  InkWell(
                    child: Text(
                      "Skip",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 19.0,
                          fontWeight: FontWeight.w100,
                          fontFamily: App.font_name),
                    ),
                    onTap: () {
                      // print("inside back");

                      goToNext();
                    },
                  ),
                ],
              ));
        },
      ),
    );
  }

  goToNext() async {
    Navigator.push(context,
        NavigatePageRoute(context, SelectGender(from: runtimeType.toString())));
  }

  void uploadProfileImage(BuildContext context, source) async {
    try {
      // print("Upload inage.......");
      File? img = await getImage(source);
      if (img == null) {
        showSnack(context, "Try again");
        return;
      }
      ProgressDialog dialog = new ProgressDialog(context, isDismissible: false);
      dialog.style(message: 'Processing...');
      await dialog.show();

      setState(() {
        imageSelected = img;
        uploadImage = true;
      });

      showSnack(context, "Image Uploading.....", seconds: 2);
      // print("Upload inage......image not null.");
      final bytes = await img.readAsBytes();
      String img64 = base64Encode(bytes);
      // print("Upload inage...encoded....");

      var map = {
        "image": img64,
        "name": "${userModel!.getUser().details!.name}.jpg"
      };

      // print("Upload inage.......mapped");
      var url = baseUrl + "api/general/uploadimage";
      http.Response r = await http.post(
        Uri.parse(url),
        body: map,
        headers: {
          "x-access-token": userModel!.getAuthToken()!,
        },
      );

      // print("Upload inage.......");
      // print(r.body);
      var pro = UserUpdate.fromJson(jsonDecode(r.body));
      userModel!.setUserDetails(pro.details);
      print("${pro.message}++++++++++++++++++");

      showSnack(context, pro.message);
      setState(() {
        uploadImage = false;
      });
      await dialog.hide();

      if (pro.message == "Image updated Successfully") {
        print("Can proceed++++++");
        await Future.delayed(Duration(seconds: 1));
        goToNext();
      }
    } catch (e) {
      setState(() {
        uploadImage = false;
      });

      showSnack(context, "Upload Failed..Image too Large.");
    }
  }
}
