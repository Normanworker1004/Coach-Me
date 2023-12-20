import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cme/model/find_user_by_phone_response.dart';
import 'package:cme/model/login_response.dart';
import 'package:cme/model/user_class/profile_details.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/model/user_profile_class.dart';
import 'package:cme/model/user_update.dart';
import 'package:cme/network/auth.dart';
import 'package:cme/ui_widgets/register_widgets/input.dart';
import 'package:cme/ui_widgets/register_widgets/password_input.dart';
import 'package:cme/utils/date_input.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:http/http.dart' as http;
import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/network/coach/request.dart';
import 'package:cme/register/choose_avtar.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';


import 'acc_choose_avtar.dart';
import 'acc_select_sport.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel? userModel;

  const EditProfilePage({Key? key, required this.userModel}) : super(key: key);
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}



class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool uploadImage = false;
  bool isCoach = false;
  bool isAbove18 = false;
  bool isLoading = false;
  String? dateOfBirth = "";
  String? phoneNumber = "";
  String? guardianDateOfBirth = "";
  String countryCode = "";

  TextEditingController playerfullnameController = TextEditingController();
  TextEditingController playerUsernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

//guardian
  TextEditingController guardianfullnameController = TextEditingController();
  TextEditingController guardianEmialController = TextEditingController();
  TextEditingController guardianPhoneController = TextEditingController();

//account
  TextEditingController accHolderNameController = TextEditingController();
  TextEditingController accBankNameController = TextEditingController();
  TextEditingController accNumberController = TextEditingController();
  TextEditingController accSortCodeController = TextEditingController();

  UserModel? userModel;
  Userdetails? details;
  Profiledetails? userProfile;

  initAll() {
    isCoach = userModel!.getUserDetails()!.usertype == "coach";
   // ageGroup = userModel.getUserDetails().ageGroup;
    details = userModel!.getUserDetails();
    userProfile = userModel!.getUserProfileDetails();
    dateOfBirth = details!.dob;
    playerfullnameController = TextEditingController(text: details!.name);
    playerUsernameController = TextEditingController(text: details!.username);
    dateOfBirth = details!.dob;
    phoneNumber = details!.phone;
    phoneController = TextEditingController(text: details!.phone);

    if (isCoach) {
      accBankNameController = TextEditingController(text: userProfile!.bankName);
      accHolderNameController =
          TextEditingController(text: userProfile!.bankAccountName);
      accNumberController =
          TextEditingController(text: userProfile!.bankAccountNumber);
      accSortCodeController =
          TextEditingController(text: userProfile!.bankSortCode);
    } else {
      // print("+++++------");
      if (guardianDateOfBirth != "") {
        guardianDateOfBirth = details!.guardianDob;
      }
      guardianfullnameController =
          TextEditingController(text: details!.guardianName);
      guardianEmialController =
          TextEditingController(text: details!.guardianEmail);
      guardianPhoneController =
          TextEditingController(text: details!.guardianEmail);
    }
  }

  bool is16yearsOlder() {
    String datePattern = "dd-MM-yyyy";

    // Current time - at this moment
    DateTime today = DateTime.now();

    // Parsed date to check
    DateTime birthDate = DateFormat(datePattern).parse(dateOfBirth!);

    // Date to check but moved 18 years ahead
    DateTime adultDate = DateTime(
      birthDate.year + 16,
      birthDate.month,
      birthDate.day,
    );

    return adultDate.isBefore(today);
  }

  @override
  void initState() {
    super.initState();

    userModel = widget.userModel;
    initAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            buildBaseScaffold(
                body: buildBody(context),
                context: context,
                title: "Profile & Account"),
            Visibility(visible: uploadImage, child: buildDialogueBody(context))
          ],
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      children: [
        verticalSpace(),
        InkWell(
          onTap: () {
            setState(() {
              uploadImage = !uploadImage;
            });
          },
          child: Column(
            children: <Widget>[
              CircularNetworkImage(
                imageUrl: "${details!.profilePic!}",
                size: 120,
              ),
              verticalSpace(),
              boldText(
                "Change Profile Photo",
                size: 16,
                color: Color.fromRGBO(202, 9, 27, 1),
                weight: FontWeight.w500,
              ),
            ],
          ),
        ),
        verticalSpace(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            boldText(
              isCoach ? "Coach Information" : "Player Information",
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  buildInputField("Full Name", playerfullnameController,
                      inputTextWeight: FontWeight.w500),
                  buildInputField("Alias", playerUsernameController),
                  customDateInput(
                    value: dateOfBirth,
                    onConfirmed: (DateTime date) {
                      setState(() {
                        dateOfBirth = "${date.day}-${date.month}-${date.year}";
                        details!.dob = dateOfBirth;
                      });
                      // print("Done...$dateOfBirth");
                    },
                    context: context,
                  ),
                  buildInputField("Phone Number", phoneController,
                      inputTextWeight: FontWeight.w500),
                  // phoneNumberInput((String p,
                  //     String internationalizedPhoneNumber, String isoCode) {
                  //   setState(() {
                  //     countryCode = isoCode;
                  //     phoneController = TextEditingController(
                  //         text: internationalizedPhoneNumber);
                  //   });
                  //   print(
                  //       "number:...$internationalizedPhoneNumber... ${phoneController.text}$isoCode");
                  // }, phoneNumber),
                ],
              ),
            )
          ],
        ),
        Visibility(
          visible: !isCoach && !is16yearsOlder(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              verticalSpace(),
              boldText("Guardian Information"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    buildInputField(
                      "Full Name",
                      guardianfullnameController,
                    ),
                    customDateInput(
                      value: guardianDateOfBirth,
                      onConfirmed: (DateTime date) {
                        setState(() {
                          guardianDateOfBirth =
                              "${date.day}-${date.month}-${date.year}";
                          details!.guardianDob = guardianDateOfBirth;
                        });
                        // print("Done...$dateOfBirth");
                      },
                      context: context,
                    ),
                    buildInputField(
                      "Email Address",
                      guardianEmialController,
                    ),
                    buildInputField(
                      "Phone Number",
                      guardianPhoneController,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Visibility(
          visible: isCoach,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              verticalSpace(),
              boldText("Account Information"),
              mediumText(
                "Enter account information to withdraw your earninigs.",
                size: 14,
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    buildInputField(
                      "Name of Account Holder",
                      accHolderNameController,
                    ),
                    buildInputField(
                      "Bank Name",
                      accBankNameController,
                    ),
                    buildInputField(
                      "Account Number",
                      accNumberController,
                      inputType: TextInputType.number,
                    ),
                    buildInputField(
                      "Sort Code",
                      accSortCodeController,
                      inputType: TextInputType.number,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        proceedButton(
            isLoading: isLoading,
            text: "Save",
            onPressed: () => updateProfile(context)
         ),
        verticalSpace(),
        borderProceedButton(
          text: "Change Password",
          onPressed: () => resetPasswordDialogue(context),
          color: blue,
        ),
        verticalSpace(),
        borderProceedButton(
          text: "Choose sports",
          onPressed: () =>
              {

                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  AcctSelectSport(
                  userModel: widget.userModel,
                )),
                )
              }
             ,
          color: blue,
        )

        ,
      ],
    );
  }

  Widget buildDialogueBody(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          uploadImage = !uploadImage;
        });
        return false;
      },
      child: GestureDetector(
        onTap: () {
          // print("outside tapped...");
          setState(() {
            if (uploadImage) {
              uploadImage = false;
            }
          });
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent.withOpacity(.2),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                verticalSpace(height: 100),
                Center(
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 70.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Card(
                            margin: EdgeInsets.all(0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Wrap(
                                direction: Axis.vertical,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.center,
                                children: <Widget>[
                                  verticalSpace(height: 48),
                                  boldText(
                                    "Change Profile Photo",
                                    size: 14,
                                    color: Colors.red,
                                  ),
                                  verticalSpace(),
                                  Visibility(
                                    visible: isCoach || is16yearsOlder(),
                                    child: Row(
                                      children: [
                                        buildImageButton(
                                          "assets/camera.png",
                                          !isCoach
                                              ? "Take a Picture"
                                              : "Upload from Camera      ",
                                          () {
                                            uploadProfileImage(context,  ImageSource.camera);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  verticalSpace(height: 16),
                                  Visibility(
                                    visible: isCoach || is16yearsOlder(),

                                    child: Row(
                                      children: [
                                        buildImageButton(
                                          "assets/cloud.png",
                                          isCoach
                                              ? "Upload from Camera Roll"
                                              : "Upload from Library",
                                          // "Upload from Library",
                                          () {
                                            uploadProfileImage(context, ImageSource.gallery);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: !isCoach ,
                                    child: Column(
                                      children: [
                                        verticalSpace(height: 16),
                                        buildImageButton(
                                          "assets/avatar.png",
                                          "Choose Avatar         ",
                                          () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) =>  AccChooseAvtar(
                                                userModel: widget.userModel,
                                              )),
                                            );

                                            setState(
                                              () {
                                                uploadImage = !uploadImage;
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              details == null
                                  ? CircularImage(
                                      size: 120,
                                      imageUrl: "images/avtar/funny-man.png",
                                    )
                                  : CircularNetworkImage(
                                      imageUrl:
                                          "${details!.profilePic!}",
                                      size: 120,
                                    ),
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImageButton(icon, text, onPressed) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          textStyle: TextStyle(color: Colors.white),
          primary: Color.fromRGBO(25, 87, 234, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                icon,
                width: 22,
                height: 18,
              ),
              horizontalSpace(),
              Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
              // Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget avatarButton() {
    return Container(
        child: TextButton(
      onPressed: () {
        pushRoute(
            context,
            ChooseAvtar(
              userModel: userModel,
            ));
        // print("inside print funcation");
      },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
       child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Ink(
          decoration: BoxDecoration(
              color: colorActiveProgress,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: colorActiveProgress, width: 1.1)),
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
    ));
  }

  updateProfile(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (playerfullnameController.text.isEmpty) {
      showSnack(context, "Name field cannot be set to empty");
      setState(() {});
      return;
    }
    if (phoneController.text.isEmpty) {
      showSnack(context, "Phone Number field cannot be set to empty");
      setState(() {});
      return;
    }
    if (isCoach) {
      if (accHolderNameController.text.isEmpty) {
        showSnack(context, "Enter Account Holder Name");
        setState(() {});
        return;
      }
      if (accBankNameController.text.isEmpty) {
        showSnack(context, "Enter Bank Name");
        setState(() {});
        return;
      }
      if (accNumberController.text.isEmpty) {
        showSnack(context, "Enter Account Number");
        setState(() {});
        return;
      }
      if (accSortCodeController.text.isEmpty) {
        showSnack(context, "Enter Sort Code");
        setState(() {});
        return;
      }
    }

    setState(() {
      isLoading = true;
    });
    UserProfile? u = await (saveAccountInfo(
      userModel!.getAuthToken(),
      fullname: playerfullnameController.text.trim(),
      alias: playerUsernameController.text.trim(),
      dob: dateOfBirth,
      accountname: accHolderNameController.text.trim(),
      bankname: accBankNameController.text.trim(),
      accountnumber: accNumberController.text.trim(),
      sortcode: accSortCodeController.text.trim(),
    ));

    if (u!.status!) {
      userModel!.setUserDetails(u.message!.userdetails);
      userModel!.setUserProfileDetails(u.message!.profiledetails);
      Navigator.pop(context);

      initAll();
    }

    setState(() {
      isLoading = false;
    });
  }

  void resetPasswordDialogue(context) {
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
            height: MediaQuery.of(context).size.height * .8,
            child: SafeArea(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                child: Card(
                  margin: EdgeInsets.all(0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ChangePasswordBody(
                      userdetails: userModel!.getUserDetails(),
                      onProceed: () {
                        Navigator.pop(context);

                        showSnack(context, "Update Password Successful");
                      },
                      onFailed: () {
                        Navigator.pop(context);

                        showSnack(context, "Update Password failed");
                      },
                    ),

                    // forgotPassWord(),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void uploadProfileImage(BuildContext context, source) async {
    ProgressDialog dialog = new ProgressDialog(context, isDismissible: false);
    dialog.style(message: 'Uploading Image...');

    try {
       print("Upload inage....aa...");
      File? img = await getImage(source);
      if (img == null) {
        print("IMAGE NULL ");
      showSnack(context, "Try again");
        return;
      }
       print("Upload inage....vv...");

      await dialog.show();
      // showSnack(context, "Image Uplading.....", seconds: 5);
      // print("Upload inage......image not null.");
      final bytes = await img.readAsBytes();
      String img64 = base64Encode(bytes);
      // print("Upload inage...encoded....");
      var j = Jiffy().millisecond;
      var map = {
        "image": img64,
        "name":
            "${playerfullnameController.text.trim()}-$j.jpg".replaceAll(" ", "")
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
       //  print(r.body);
      var pro = UserUpdate.fromJson(jsonDecode(r.body));
      userModel!.setUserDetails(pro.details);
      // print("${pro.message}++++++++++++++++++");
      showSnack(context, pro.message);

      Navigator.pop(context);

      setState(() {
        uploadImage = false;
      });

      await dialog.hide();
    } catch (e) {

      setState(() {
        uploadImage = false;
      });

      await dialog.hide();
    }
  }
}

Future<File?> getImage(source) async {
  try {
    var imagePirker = new ImagePicker();
    XFile? image = await (imagePirker.pickImage(source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front) );
    CroppedFile? image2 = await (ImageCropper.platform.cropImage(sourcePath: image!.path)  );
    File image3 = new File(image2!.path);
    return image3;
  } catch (e) {
    return null;
  }
}

class ChangePasswordBody extends StatefulWidget {
  final Userdetails? userdetails;
  final onProceed;
  final onFailed;

  const ChangePasswordBody({
    Key? key,
    required this.userdetails,
    required this.onProceed,
    required this.onFailed,
  }) : super(key: key);
  @override
  _ChangePasswordBodyState createState() => _ChangePasswordBodyState();
}

class _ChangePasswordBodyState extends State<ChangePasswordBody> {
  bool showComplete = false;
  bool isLoading = false;
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  bool canProceed() {
    if (oldPasswordController.text.length < 6) {
      return false;
    }
    if (newPasswordController.text.length < 6) {
      return false;
    }
    if (rePasswordController.text == newPasswordController.text) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: App.font_name2),

      home: Scaffold(
          resizeToAvoidBottomInset:false,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                verticalSpace(height: 16),
                Center(
                    child: Container(
                  height: 3,
                  width: 72,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(  238, 238, 238, 1), //rgba(238, 238, 238, 1)
                      borderRadius: BorderRadius.circular(4)),
                )),
                verticalSpace(height: 16),
                Image.asset("assets/pw1.png"),
                verticalSpace(),
                boldText("Change password?", size: 24),
                verticalSpace(),
                CustomPasswordField(
                  labelText: "Old Password",
                  controller: oldPasswordController,
                  onChanged: (c) {
                    setState(() {});
                  },
                ),
                verticalSpace(),
                CustomPasswordField(
                  labelText: "New Password",
                  controller: newPasswordController,
                  onChanged: (c) {
                    setState(() {});
                  },
                ),
                verticalSpace(),
                CustomPasswordField(
                  labelText: "Confirm New Password",
                  controller: rePasswordController,
                  onChanged: (c) {
                    setState(() {});
                  },
                ),
                verticalSpace(height: 16),
                proceedButton(
                  text: "Update",
                  isLoading: isLoading,
                  onPressed: canProceed()
                      ? null
                      : () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {
                            isLoading = true;
                          });
                          LogInResponse r = await loginUser(
                            username: widget.userdetails!.email,
                            password: oldPasswordController.text.trim(),
                          );
                          if (r.auth!) {
                            final password = newPasswordController.text;
                            FindUserByPhoneResponse up = await resetPassword(
                              newPassWord: password,
                              userId: "${widget.userdetails!.id}",
                            );
                            if (up.status!) {
                              widget.onProceed();
                            } else {
                              widget.onFailed();
                            }
                          } else {
                            widget.onFailed();
                          }
                          setState(() {
                            isLoading = true;
                          });
                        },


                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
