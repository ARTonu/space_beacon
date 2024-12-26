import 'package:get/get.dart';
import 'package:space_beacon/ui/home/home_screen.dart';
import 'package:space_beacon/ui/signin/signin_screen.dart';

class AppRoute {
  AppRoute._() {}
  static const String signIn = "/signin";
  static const String home = "/home";
}

var pages = [
  GetPage(
    name: AppRoute.signIn,
    transition: Transition.rightToLeft,
    page: () => const SigninScreen(),
  ),
  GetPage(
    name: AppRoute.home,
    transition: Transition.rightToLeft,
    page: () => const HomeScreen(),
  ),
];
