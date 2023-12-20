// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCLbSTUVhDRwwVLTOOHgWBwD78NHuHfsNk',
    appId: '1:285083201803:android:30a6ce82802577e7f9720e',
    messagingSenderId: '285083201803',
    projectId: 'coachandme-10293',
    databaseURL: 'https://coachandme-10293.firebaseio.com',
    storageBucket: 'coachandme-10293.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBVyA7kS9dVWsUaWbONhJGWUU-d3PlUmls',
    appId: '1:285083201803:ios:0a989e7bd16a25b0f9720e',
    messagingSenderId: '285083201803',
    projectId: 'coachandme-10293',
    databaseURL: 'https://coachandme-10293.firebaseio.com',
    storageBucket: 'coachandme-10293.appspot.com',
    androidClientId: '285083201803-3mg9li559ogsgc9m4hq0ree98jc2rlpv.apps.googleusercontent.com',
    iosClientId: '285083201803-722lpmahmmp8n28q8avffpc7cpe88rra.apps.googleusercontent.com',
    iosBundleId: 'com.mits.cme',
  );
}
