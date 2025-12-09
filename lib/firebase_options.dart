import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // ⭐️ CORRECTION : Gérer les autres plateformes
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // ⚠️ REMPLISSEZ AVEC VOS VRAIES CLÉS ANDROID
        return android; 
      case TargetPlatform.iOS:
        // ⚠️ REMPLISSEZ AVEC VOS VRAIES CLÉS iOS
        return ios; 
      case TargetPlatform.macOS:
        // ⚠️ REMPLISSEZ AVEC VOS VRAIES CLÉS MACOS
        return macos;
      default:
        // Retourne une erreur non supportée uniquement pour les cas non gérés
        throw UnsupportedError(
            'DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCfmCmGfrzKBJEKuYiEoUlaW_VMVxsBjq0',
    appId: '1:406021566652:web:d2f13940555c6d8710e0b9',
    messagingSenderId: '406021566652',
    projectId: 'ecommerce-ec4ba',
    storageBucket: 'ecommerce-ec4ba.appspot.com',
  );
  
  // ⭐️ DOIT ÊTRE AJOUTÉ SI VOUS TESTEZ SUR ANDROID/EMULATEUR
  static const FirebaseOptions android = FirebaseOptions(
      // Exemple de valeurs à remplacer par vos propres clés
      apiKey: 'VOTRE_API_KEY_ANDROID',
      appId: '1:VOTRE_APP_ID_ANDROID',
      messagingSenderId: '406021566652',
      projectId: 'ecommerce-ec4ba',
      storageBucket: 'ecommerce-ec4ba.appspot.com',
  );

  // ⭐️ DOIT ÊTRE AJOUTÉ SI VOUS TESTEZ SUR iOS/SIMULATEUR
  static const FirebaseOptions ios = FirebaseOptions(
      // Exemple de valeurs à remplacer par vos propres clés
      apiKey: 'VOTRE_API_KEY_IOS',
      appId: '1:VOTRE_APP_ID_IOS',
      messagingSenderId: '406021566652',
      projectId: 'ecommerce-ec4ba',
      storageBucket: 'ecommerce-ec4ba.appspot.com',
  );

  // ⭐️ AJOUTEZ AUSSI LES AUTRES PLATEFORMES SI NÉCESSAIRE
  static const FirebaseOptions macos = FirebaseOptions(
      apiKey: 'VOTRE_API_KEY_MACOS',
      appId: '1:VOTRE_APP_ID_MACOS',
      messagingSenderId: '406021566652',
      projectId: 'ecommerce-ec4ba',
      storageBucket: 'ecommerce-ec4ba.appspot.com',
  );
}