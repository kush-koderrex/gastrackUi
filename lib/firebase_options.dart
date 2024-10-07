// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyCm_ZAztVX9FHWMLkWKPKel2yTmY4Pl-F8',
    appId: '1:22846129147:android:3ef90e15a2dfdaf78b415e',
    messagingSenderId: '22846129147',
    projectId: 'gastrack-fa2c6',
    databaseURL: 'https://gastrack-fa2c6-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'gastrack-fa2c6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB45oS9PAwCkj4iUV53m1wdq5-v6z4_Yyg',
    appId: '1:22846129147:ios:36f860c8c9fcc8d68b415e',
    messagingSenderId: '22846129147',
    projectId: 'gastrack-fa2c6',
    databaseURL: 'https://gastrack-fa2c6-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'gastrack-fa2c6.appspot.com',
    iosBundleId: 'com.example.gasTrackUi',
  );
}