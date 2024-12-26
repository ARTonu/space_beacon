import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:space_beacon/data/repositories/open_api/response_models/iss_now_model.dart';
import 'package:space_beacon/utils/logger.dart';
import 'package:space_beacon/utils/snackbar_utils.dart';

import '../../data/repositories/open_api/app_repository.dart';

class HomeScreenController extends GetxController {
  final Duration _interval = const Duration(seconds: 1);
  Rx<IssNowModel?> issNow = Rx<IssNowModel?>(null);
  var isLastAttemptSuccess = false.obs;
  var isLoadingData = false.obs;
  var isAboveMyCountry = false.obs;
  var timeLeft = 60.obs;
  Timer? _timer;
  Position? currentPosition;

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchIssPosition();
  }

  @override
  void dispose() {
    super.dispose();
    stopCountDown();
  }

  void startCountDown() {
    timeLeft.value = 60;
    _timer = Timer.periodic(_interval, (timer) async {
      if (timeLeft.value == 0) {
        timer.cancel();
        _timer = null;
        await fetchIssPosition();
      } else {
        timeLeft.value--;
      }
    });
  }

  void stopCountDown() {
    _timer?.cancel();
    _timer = null;
    timeLeft.value = 60;
  }

  Future<void> fetchIssPosition() async {
    Log().d("fetching iss position");
    isLoadingData.value = true;
    stopCountDown();
    var apiTask = await AppRepository.instance.fetchIssPosition();
    isLastAttemptSuccess.value = apiTask.isSuccessful;
    if (apiTask.isSuccessful) {
      issNow.value = apiTask.response;
    } else {
      Log().e("${apiTask.exception}");
    }
    isLoadingData.value = false;
    startCountDown();
  }

  String getLastUpdateTimeUtc() {
    if (issNow.value == null) return "";
    var dateFormat = DateFormat("dd-MM-yy hh:mm a");
    return "${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(issNow.value!.timestamp * 1000, isUtc: true))} (UTC)";
  }

  String getLastUpdateTimeLocal() {
    if (issNow.value == null) return "";
    var dateFormat = DateFormat("dd-MM-yy hh:mm a");
    return "${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(issNow.value!.timestamp * 1000))} (Local)";
  }

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showErrorSnackBar("Error", "Location permissions are denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showErrorSnackBar("Error",
          "Location permissions are permanently denied, we cannot request permissions.");
      return;
    }

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showInfoSnackBar("Error", "Location services are disabled.");
      return;
    }
    currentPosition = await Geolocator.getCurrentPosition();
    Log().d(
        "User location latitude: ${currentPosition?.latitude} longitude: ${currentPosition?.longitude}");
    return;
  }
}
