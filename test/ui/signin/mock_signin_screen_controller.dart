import 'package:get/get.dart';
import 'package:space_beacon/ui/signin/signin_screen_controller.dart';

class MockSignInScreenController extends GetxController implements SignInScreenController {
  @override
  var isSingInSuccess = false.obs;

  @override
  var isSingingIn = false.obs;

  @override
  var result = ''.obs;

  @override
  Future<void> signIntoSpaceBeacon() async {
    isSingingIn.value = true;
    await Future.delayed(const Duration(milliseconds: 100)); // Simulate delay
    isSingingIn.value = false;
    isSingInSuccess.value = true; // Simulate success
    result.value = "Signed in successfully!";
  }
}
