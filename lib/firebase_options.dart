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
      return web;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAoOOiRCAHbBJPU-XheNh9td5pQx7_7AYo',
    appId: '1:948397507649:web:44412dff9333547afab2c0',
    messagingSenderId: '948397507649',
    projectId: 'reddit-clone-499a4',
    authDomain: 'reddit-clone-499a4.firebaseapp.com',
    storageBucket: 'reddit-clone-499a4.appspot.com',
    measurementId: 'G-KQF1NZ32SG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCZr1ziQZAgOhP1rLwdMrHJlXvFBRVE1jI',
    appId: '1:948397507649:android:d00c902eb3161e06fab2c0',
    messagingSenderId: '948397507649',
    projectId: 'reddit-clone-499a4',
    storageBucket: 'reddit-clone-499a4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDHGAshyE4M2tTHAjctY7FucQhU47Arjio',
    appId: '1:948397507649:ios:58313ab54e44b786fab2c0',
    messagingSenderId: '948397507649',
    projectId: 'reddit-clone-499a4',
    storageBucket: 'reddit-clone-499a4.appspot.com',
    iosBundleId: 'com.example.redditTutorial',
  );
}
