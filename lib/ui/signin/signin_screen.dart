import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:space_beacon/app/app_routes.dart';
import 'package:space_beacon/ui/signin/signin_screen_controller.dart';
import 'package:space_beacon/utils/snackbar_utils.dart';

import '../../gen/assets.gen.dart';
import '../../utils/text_style_utils.dart';

class SignInScreen extends StatelessWidget {
  final SignInScreenController controller = Get.put(SignInScreenController());

  SignInScreen({super.key});

  @override
  Widget build(context) {
    WidgetsBinding.instance.addPostFrameCallback((time) {
      /*
      * A delay is added to show the signing UI for sometime
      * Every app start time this screen will shown
      * This is done intentionally. In real scenario already authentication user is checked and skipped it
       */
      Future.delayed(const Duration(seconds: 2), () async {
        await controller.signIntoSpaceBeacon();
        if (controller.isSingInSuccess.value) {
          showSuccessSnackBar("Success", controller.result.value);
          Get.offNamed(AppRoute.home);
        }
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Space Beacon",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              Assets.anim.animSignin,
              repeat: true,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Obx(() => buildStatusTextWidget()),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatusTextWidget() {
    if (controller.isSingingIn.value) {
      return const Text(
        "Please wait...",
        style: infoStyle,
      );
    } else {
      if (controller.isSingInSuccess.value) {
        return Container();
      } else {
        return Text(
          controller.result.value,
          style: errorStyle,
        );
      }
    }
  }
}
