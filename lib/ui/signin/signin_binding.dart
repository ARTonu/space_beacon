import 'package:get/get.dart';
import 'package:space_beacon/ui/signin/signin_screen_controller.dart';

class SignInBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInScreenController());
  }
}
