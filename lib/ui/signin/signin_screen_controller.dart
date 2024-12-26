import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:space_beacon/data/repositories/firebase/firebase_auth_service.dart';

class SignInScreenController extends GetxController {
  var isSingingIn = true.obs;
  var isSingInSuccess = false.obs;
  var result = "".obs;

  Future<void> signIntoSpaceBeacon() async {
    var res = await FirebaseAuthService.signInAnonymously();
    if (res is UserCredential) {
      result.value = "You are now signed in";
      isSingInSuccess.value = true;
    } else {
      result.value = res;
      isSingInSuccess.value = false;
    }
    isSingingIn.value = false;
  }
}
