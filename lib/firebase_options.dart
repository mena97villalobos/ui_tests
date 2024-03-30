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
        return macos;
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
    apiKey: 'AIzaSyAWokpdBo-RNl8g6oBBJWAgJ6f1Ca7II6A',
    appId: '1:172619530438:web:4237d92aec2d8699cb97c7',
    messagingSenderId: '172619530438',
    projectId: 'weddinginvitations-5a9db',
    authDomain: 'weddinginvitations-5a9db.firebaseapp.com',
    storageBucket: 'weddinginvitations-5a9db.appspot.com',
    measurementId: 'G-GW1BL6CJ5B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAAHSpxjWpuE1bni4it6u6FjrI4ha4eT5U',
    appId: '1:172619530438:android:e1a419b84b296094cb97c7',
    messagingSenderId: '172619530438',
    projectId: 'weddinginvitations-5a9db',
    storageBucket: 'weddinginvitations-5a9db.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDpzuEOQO7uUywghbOUEr-mrgMwvtrc1Jo',
    appId: '1:172619530438:ios:96e52045eb387f63cb97c7',
    messagingSenderId: '172619530438',
    projectId: 'weddinginvitations-5a9db',
    storageBucket: 'weddinginvitations-5a9db.appspot.com',
    iosBundleId: 'com.example.uiTests',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDpzuEOQO7uUywghbOUEr-mrgMwvtrc1Jo',
    appId: '1:172619530438:ios:155723978d2ec19dcb97c7',
    messagingSenderId: '172619530438',
    projectId: 'weddinginvitations-5a9db',
    storageBucket: 'weddinginvitations-5a9db.appspot.com',
    iosBundleId: 'com.example.uiTests.RunnerTests',
  );
}
