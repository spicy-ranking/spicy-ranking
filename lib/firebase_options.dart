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
    apiKey: 'AIzaSyBONNcT9OQYKvOAuniKkztQQCCpyBNo_-4',
    appId: '1:923147600370:web:a817ee4e3ef16622c3eb6b',
    messagingSenderId: '923147600370',
    projectId: 'spicy-ranking',
    authDomain: 'spicy-ranking.firebaseapp.com',
    storageBucket: 'spicy-ranking.appspot.com',
    measurementId: 'G-JG23EYQRMZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCZm_odyirBXXaMCB8mFd_o_OTmBeUi1uw',
    appId: '1:923147600370:android:1682fbee2bbf17d8c3eb6b',
    messagingSenderId: '923147600370',
    projectId: 'spicy-ranking',
    storageBucket: 'spicy-ranking.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDDqpTdhzS1vGTbj-Xs59Fckgf4TxFHZ2Q',
    appId: '1:923147600370:ios:a67011ee9955de51c3eb6b',
    messagingSenderId: '923147600370',
    projectId: 'spicy-ranking',
    storageBucket: 'spicy-ranking.appspot.com',
    iosClientId: '923147600370-hcdnc5a2pqo81ck86aduh3gnitld7o5f.apps.googleusercontent.com',
    iosBundleId: 'com.example.spicyRanking',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDDqpTdhzS1vGTbj-Xs59Fckgf4TxFHZ2Q',
    appId: '1:923147600370:ios:abf2ecd9bda60fedc3eb6b',
    messagingSenderId: '923147600370',
    projectId: 'spicy-ranking',
    storageBucket: 'spicy-ranking.appspot.com',
    iosClientId: '923147600370-bs26d2fdp6ronhlm1bfqdcdg45g9pgnd.apps.googleusercontent.com',
    iosBundleId: 'com.example.spicyRanking.RunnerTests',
  );
}
