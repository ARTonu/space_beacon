import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:space_beacon/ui/home/home_screen_controller.dart';

import '../../gen/assets.gen.dart';
import '../../utils/text_style_utils.dart';

class HomeScreen extends StatelessWidget {
  final HomeScreenController controller = Get.put(HomeScreenController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((time) async {
      await controller.determinePosition();
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
                () => buildStatusWidget(),
              ),
              const SizedBox(
                height: 10,
              ),
              Lottie.asset(
                Assets.anim.animSatellite,
                repeat: true,
                height: 200,
              ),
              Obx(
                () => Visibility(
                  visible: controller.issNow.value != null,
                  child: buildPositionInfoWidget(),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: controller.isAboveMyCountry.value,
                  child: const Text(
                    "The Space Station is above your Country Now!!",
                    textAlign: TextAlign.center,
                    style: aboveMyCountryStyle,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (controller.isLoadingData.value) return;
                    await controller.fetchIssPosition();
                  },
                  child: const Text("Refresh")),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStatusWidget() {
    if (controller.isLoadingData.value) {
      return const Text(
        "Fetching space station position...",
        style: infoStyle,
      );
    } else {
      return Text(
        controller.isLastAttemptSuccess.value
            ? "Next refresh in ${controller.timeLeft.value} s"
            : "Last attempt failed. Retrying in ${controller.timeLeft.value} s",
        style: controller.isLastAttemptSuccess.value ? infoStyle : errorStyle,
      );
    }
  }

  Widget buildPositionInfoWidget() {
    return RichText(
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: "Last Update\n\n",
        style: infoHeaderStyle,
        children: <TextSpan>[
          TextSpan(
            text:
                "Latitude: ${controller.issNow.value?.issPosition.latitude} Longitude: ${controller.issNow.value?.issPosition.longitude}\n",
            style: infoMsgStyle,
          ),
          TextSpan(
            text: "Time: ${controller.getLastUpdateTimeUtc()}\n",
            style: infoMsgStyle,
          ),
          TextSpan(
            text: "Time: ${controller.getLastUpdateTimeLocal()}\n",
            style: infoMsgStyle,
          ),
          TextSpan(
            text: "Country/Region:  ${controller.countryIss.value}\n",
            style: infoMsgStyle,
          ),
        ],
      ),
    );
  }
}
