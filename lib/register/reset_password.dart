import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/coach_pages/homescreen.dart';
import 'package:cme/model/final.dart';
import 'package:cme/model/find_user_by_phone_response.dart';
import 'package:cme/network/auth.dart';
import 'package:cme/player_pages/homescreen.dart';
import 'package:cme/ui_widgets/back_arrow.dart';
import 'package:cme/ui_widgets/register_widgets/password_input.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:cme/app.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cme/utils/navigate_effect.dart';

class ResetPassword extends StatefulWidget {
  final UserModel? userModel;

   ResetPassword({Key? key, required  this.userModel}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confrirmPasswordController = TextEditingController();

  var i;
  bool isLoading = false;
  late UserModel userModel;

  @override
  void initState() {
    super.initState();
    i = Final.getId();
   }

  @override
  void dispose() async {
    super.dispose();
   }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (c, widget, model) {
        userModel = model;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  Scaffold(
                    key: _key,
                    appBar: AppBar(
                      elevation: 0,
                      backgroundColor: themeBkg,
                      automaticallyImplyLeading: false,
                      title: Container(),
                    ),
                    body: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Text("Update",
                                style: TextStyle(
                                    fontSize: 26,
                                    fontFamily: App.font_name,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center),
                          ),
                          Center(
                            child: Text("your Password",
                                style: TextStyle(
                                    fontSize: 26,
                                    fontFamily: App.font_name,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          SizedBox(
                            height: 10,
                          ),
                          CustomPasswordField(
                            controller: passwordController,
                          ),
                          CustomPasswordField(
                            controller: confrirmPasswordController,
                            labelText: "Re-enter Password",
                          ),


                          Container(
                              child: TextButton(
                            onPressed: ! isLoading  ? () {  completeRegistration(); }
                                : () => { },
                                style:TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    color: colorActiveBtn,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                        color: colorActiveBtn, width: 1.1)),
                                child: Container(
                                  constraints: BoxConstraints(minHeight: 60.0),
                                  alignment: Alignment.center,
                                  child: isLoading
                                      ? CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                        )
                                      : Text(
                                          "Set new password",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontFamily: App.font_name,
                                              fontWeight: FontWeight.w700),
                                        ),
                                ),
                              ),
                            ),
                          )),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                    backgroundColor: themeBkg,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: backArrow(),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }




  goToNext(BuildContext context) async {

    showSnack(context, "Your password is updated ! you can connect now ! ");
    Navigator.pop(context);
    Navigator.pop(context);

    bool isCoach = userModel.getUserDetails()!.usertype == "coach" ;

    if (!isCoach) {
      pushRoute(context, HomeScreen());
    } else {
       pushRoute(context, CoachHomeScreen());
    }
  }

  void completeRegistration() async {
    print("RESET PASSWORD USER ID : $i");
    setState(() {
      isLoading = true;
    });
    FocusScope.of(context).requestFocus(FocusNode());
    if (passwordController.text.isEmpty) {
      showSnack(context, "Enter Password");
      setState(() {
        isLoading = false;
      });
      return;
    }
    if (passwordController.text != confrirmPasswordController.text) {
      showSnack(context, "Passwords don't match");
      setState(() {
        isLoading = false;
      });
      return;
    }

    final password = "${passwordController.text}";
    FindUserByPhoneResponse up = await resetPassword(
      newPassWord:password, // password.substring(0, 7),// "resetedpasswordVal1234@"
      userId: userModel.getUserDetails()!.id,
    );

    if(up.status!){
      goToNext(context);
    }else{
      showSnack(context, "Error occured, please retry later");
    }
    print("$up");

    setState(() {
      isLoading = false;
    });

  }
}
