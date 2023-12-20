import 'package:cme/app.dart';
import 'package:cme/network/store_previous_user.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:local_auth/local_auth.dart';

class SecurityPage extends StatefulWidget {
  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool isOn = false;
  bool isOn2 = false;

  bool isFinger = false;
  bool isFace = false;

  final LocalAuthentication _localAuthentication = LocalAuthentication();
  @override
  void initState() {
    super.initState();
    isBiometricAvailable();
  }

  // To check if any type of biometric authentication
  // hardware is available.
  isBiometricAvailable() async {
    bool isAvailable = false;
    try {
      isAvailable = await _localAuthentication.canCheckBiometrics;
      if (isAvailable) {
        getListOfBiometricTypes();
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  // To retrieve the list of biometric types
  // (if available).
  getListOfBiometricTypes() async {
    List<BiometricType> listOfBiometrics;
    try {
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
      // print(listOfBiometrics);

      for (var item in listOfBiometrics) {
        switch (item) {
          case BiometricType.face:
            isOn = await getAllowLocal();
            setState(() {
              isFace = true;
            });

            break;
          case BiometricType.fingerprint:
            isOn2 = await getAllowLocal();
            setState(() {
              isFinger = true;
            });

            break;
          default:
        }
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildBaseScaffold(
        body: buildBody(context), context: context, title: "Security");
  }

  Widget buildBody(BuildContext context) {
    return ListView(children: [
      Visibility(
        visible: isFinger,
        child: buildCard(
          Expanded(
            child: Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(182, 9, 27, 1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      MaterialIcons.fingerprint,
                      color: Colors.white,
                    ),
                  ),
                ),
                horizontalSpace(),
                Expanded(
                  child: boldText("Finger Print", size: 14),
                ),
                horizontalSpace(),
                CupertinoSwitch(
                    value: isOn2,
                    activeColor: normalBlue,
                    onChanged: !isFinger
                        ? null
                        : (c) async {
                            setState(() {
                              isOn2 = c;
                            });

                            await saveAllowLocal(c);
                          })
              ],
            ),
          ),
        ),
      ),
      verticalSpace(height: 16),
      Visibility(
        visible: isFace,
        child: buildCard(Expanded(
            child: Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(182, 9, 27, 1),
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  FontAwesome.smile_o,
                  color: Colors.white,
                ),
              ),
            ),
            horizontalSpace(),
            Expanded(
              child: boldText("Face Unlock", size: 14),
            ),
            horizontalSpace(),
            CupertinoSwitch(
              value: isOn,
              activeColor: normalBlue,
              onChanged: !isFace
                  ? null
                  : (c) async {
                      setState(() {
                        isOn = c;
                      });
                      await saveAllowLocal(c);
                    },
            )
          ],
        ))),
      ),
    ]);
  }
}
