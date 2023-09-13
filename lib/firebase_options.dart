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
    apiKey: 'AIzaSyBCXUztUudaQzk2JUcFaJFEL7Ofta0jDR0',
    appId: '1:938471881507:web:adf25c617c72c396302a96',
    messagingSenderId: '938471881507',
    projectId: 'myplatform-37865',
    authDomain: 'myplatform-37865.firebaseapp.com',
    storageBucket: 'myplatform-37865.appspot.com',
    measurementId: 'G-VYL1CVWWXY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfo80cWuM3KtrnBJGpcyEE6YL-f4X9KG4',
    appId: '1:938471881507:android:ee36b5d8b4a0b24e302a96',
    messagingSenderId: '938471881507',
    projectId: 'myplatform-37865',
    storageBucket: 'myplatform-37865.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB4z9V8mST-tWw6MwGv7Z3GjgpHElNJ5fM',
    appId: '1:938471881507:ios:42655b4c56a88f80302a96',
    messagingSenderId: '938471881507',
    projectId: 'myplatform-37865',
    storageBucket: 'myplatform-37865.appspot.com',
    iosBundleId: 'com.example.myplatform',
  );
}