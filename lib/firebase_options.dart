import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError('Unsupported platform');
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCfmCmGfrzKBJEKuYiEoUlaW_VMVxsBjq0',
    appId: '1:406021566652:web:d2f13940555c6d8710e0b9',
    messagingSenderId: '406021566652',
    projectId: 'ecommerce-ec4ba',
    storageBucket: 'ecommerce-ec4ba.appspot.com',
  );
}
