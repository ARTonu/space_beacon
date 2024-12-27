import 'package:get/get.dart';
import 'package:space_beacon/ui/home/home_screen_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeScreenController());
  }
}
