
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


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
    apiKey: 'AIzaSyBSJ_DBpJ_HdayNsgno2T594jucBkleCg8',
    appId: '1:109752984599:web:d3705b4cd73bdb97b6a852',
    messagingSenderId: '109752984599',
    projectId: 'assignmentcafeteriaapp',
    authDomain: 'assignmentcafeteriaapp.firebaseapp.com',
    storageBucket: 'assignmentcafeteriaapp.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBWlxR1ZeTLHJKhIlMc0xY5tN1cMEArpOs',
    appId: '1:109752984599:ios:a2d702db9996149ab6a852',
    messagingSenderId: '109752984599',
    projectId: 'assignmentcafeteriaapp',
    storageBucket: 'assignmentcafeteriaapp.firebasestorage.app',
    iosBundleId: 'com.example.theCafeteriaApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBWlxR1ZeTLHJKhIlMc0xY5tN1cMEArpOs',
    appId: '1:109752984599:ios:a2d702db9996149ab6a852',
    messagingSenderId: '109752984599',
    projectId: 'assignmentcafeteriaapp',
    storageBucket: 'assignmentcafeteriaapp.firebasestorage.app',
    iosBundleId: 'com.example.theCafeteriaApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBSJ_DBpJ_HdayNsgno2T594jucBkleCg8',
    appId: '1:109752984599:web:8092e1b5a13119c4b6a852',
    messagingSenderId: '109752984599',
    projectId: 'assignmentcafeteriaapp',
    authDomain: 'assignmentcafeteriaapp.firebaseapp.com',
    storageBucket: 'assignmentcafeteriaapp.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAMtZCKKhbOk606PBSnt-x51NcjH7LI3hk',
    appId: '1:109752984599:android:02bfc0b59254b9ddb6a852',
    messagingSenderId: '109752984599',
    projectId: 'assignmentcafeteriaapp',
    storageBucket: 'assignmentcafeteriaapp.firebasestorage.app',
  );

}