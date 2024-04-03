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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyB0u8UbX60ocFXIhciUEAWclWOseAynsOA',
    appId: '1:847882197453:android:d1e2ad83a2fbbdf9814c84',
    messagingSenderId: '847882197453',
    projectId: 'vitaflowplus-96701',
    storageBucket: 'vitaflowplus-96701.appspot.com',
  );

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyALSYFKjOnn_EwuEFVqHYU8DE0cbM2LUeA",
      authDomain: "vitaflowplus-96701.firebaseapp.com",
      projectId: "vitaflowplus-96701",
      storageBucket: "vitaflowplus-96701.appspot.com",
      messagingSenderId: "847882197453",
      appId: "1:847882197453:web:e9ab468909f80b93814c84");
}
