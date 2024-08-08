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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBw-7NXEXVJw1AFjfRtKt0x-xPBjHt5qfQ',
    appId: '1:482971336669:web:452211df8cade79743c034',
    messagingSenderId: '482971336669',
    projectId: 'edu-career-firebase-8c859',
    authDomain: 'edu-career-firebase-8c859.firebaseapp.com',
    storageBucket: 'edu-career-firebase-8c859.appspot.com',
    measurementId: 'G-FKLJ0MM01H',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCdZFOEW5lz8mwNVhmBP0ER4XqmosEaGTo',
    appId: '1:482971336669:android:70ab69809192013543c034',
    messagingSenderId: '482971336669',
    projectId: 'edu-career-firebase-8c859',
    storageBucket: 'edu-career-firebase-8c859.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAHFLQ80_z1_oWyIfkxxIZ4lIJ1mlJgp6k',
    appId: '1:482971336669:ios:92473851563f387343c034',
    messagingSenderId: '482971336669',
    projectId: 'edu-career-firebase-8c859',
    storageBucket: 'edu-career-firebase-8c859.appspot.com',
    iosBundleId: 'com.example.flutteradmin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAHFLQ80_z1_oWyIfkxxIZ4lIJ1mlJgp6k',
    appId: '1:482971336669:ios:92473851563f387343c034',
    messagingSenderId: '482971336669',
    projectId: 'edu-career-firebase-8c859',
    storageBucket: 'edu-career-firebase-8c859.appspot.com',
    iosBundleId: 'com.example.flutteradmin',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBw-7NXEXVJw1AFjfRtKt0x-xPBjHt5qfQ',
    appId: '1:482971336669:web:7417fcfb456e629643c034',
    messagingSenderId: '482971336669',
    projectId: 'edu-career-firebase-8c859',
    authDomain: 'edu-career-firebase-8c859.firebaseapp.com',
    storageBucket: 'edu-career-firebase-8c859.appspot.com',
    measurementId: 'G-6RW6V3QSN2',
  );
}
