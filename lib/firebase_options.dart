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
    apiKey: 'AIzaSyCCDQJr4S4OzKUuStK4OrCpB_H773-9jII',
    appId: '1:1069505007966:web:baf888d9b5a9a845153fcf',
    messagingSenderId: '1069505007966',
    projectId: 'stocker-dashboard',
    authDomain: 'stocker-dashboard.firebaseapp.com',
    storageBucket: 'stocker-dashboard.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDG5XS8j1I8L6F9yM9wxRxzO4X1zy2mEzA',
    appId: '1:1069505007966:android:1889a25e2eb6f52e153fcf',
    messagingSenderId: '1069505007966',
    projectId: 'stocker-dashboard',
    storageBucket: 'stocker-dashboard.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD_9sD6kcgkrTTSJoLSMFIfGGOc_iPvO7A',
    appId: '1:1069505007966:ios:94bcfe6869c877da153fcf',
    messagingSenderId: '1069505007966',
    projectId: 'stocker-dashboard',
    storageBucket: 'stocker-dashboard.appspot.com',
    iosBundleId: 'com.example.stocker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD_9sD6kcgkrTTSJoLSMFIfGGOc_iPvO7A',
    appId: '1:1069505007966:ios:94bcfe6869c877da153fcf',
    messagingSenderId: '1069505007966',
    projectId: 'stocker-dashboard',
    storageBucket: 'stocker-dashboard.appspot.com',
    iosBundleId: 'com.example.stocker',
  );
}
