import 'package:cme/auth_scope_model/ui_provider.dart';
import 'package:cme/initial_bindings.dart';
import 'package:cme/intro/splashscreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/intro/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );

  runApp(

    MainContainer(
      child: MultiProvider(
        providers: [
          ListenableProvider(create: (context) => UIProvider()),
        ],
        child: ScopedModel(
          model: UserModel(),
          child: GetMaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  brightness: Brightness.light,
                  fontFamily: App.font_name,
                ),
                home:GetStartedPage(),
                routes: <String, WidgetBuilder>{
                  '/Onboarding': (BuildContext context) => Onboarding()
                },
            initialBinding: InitialBindings(),

          ),
        ),
      ),
    ),
  );
}

class MainContainer  extends StatefulWidget{
  final Widget child;

  MainContainer({required this.child});

  @override
  State<StatefulWidget> createState() => MainContainerState();


}

class MainContainerState extends State<MainContainer>{
  @override
  initState()  {
    var _ = SharedPreferences.getInstance().then((value) async  { // first init there so it retains after restarting apps.
      var alreadyShowed = await value.getInt('homeTooltip') ;
      print("ALREADY SHWED ? :: ${alreadyShowed}");
    });


    // if(alreadyShowed == 1)doneToolTip= true;


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
        gestures: [GestureType.onTap, GestureType.onPanUpdateDownDirection],
        child:  Container( child: widget.child,));
  }
}

class TestMessages extends StatefulWidget {
  @override
  _TestMessagesState createState() => _TestMessagesState();
}

class _TestMessagesState extends State<TestMessages> {
  // FirebaseMessaging fcm = FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fcm.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     // _showItemDialog(message);
    //   },
    //   onBackgroundMessage: (Map<String, dynamic> message) async {
    //     print("onBackgroundMessage: $message");
    //     // _navigateToItemDetail(message);
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     // _navigateToItemDetail(message);
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     // _navigateToItemDetail(message);
    //   },
    // );

    // workaround for onLaunch: When the app is completely closed (not in the background) and opened directly from the push notification
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      print('getInitialMessage data: ${message!.data}');
      // _serialiseAndNavigate(message);
    });

    // onMessage: When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage data: ${message.data}");
    });

    // replacement for onResume: When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp data: ${message.data}');
      // _serialiseAndNavigate(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
