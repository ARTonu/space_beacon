import 'package:firebase_auth/firebase_auth.dart';

import '../../../utils/logger.dart';

class FirebaseAuthService {
  static Future<dynamic> signInAnonymously() async {
    try {
      return await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      Log().e("signInAnonymously FirebaseAuthException $e");
      switch (e.code) {
        case "operation-not-allowed":
          return "Anonymous auth hasn't been enabled for this project";
        default:
          return "Unknown error occurred";
      }
    } catch (e) {
      Log().e("signInAnonymously exception $e");
      return "Unexpected error occurred";
    }
  }

  static Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      Log().e("signOut exception $e");
      return false;
    }
  }
}
