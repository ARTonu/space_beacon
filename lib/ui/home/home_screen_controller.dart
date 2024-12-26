import 'dart:async';

import 'package:geocoding/geocoding.dart';
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
  Rx<String?> countryIss = Rx<String?>(null);
  var isLastAttemptSuccess = false.obs;
  var isLoadingData = false.obs;
  var isAboveMyCountry = false.obs;
  var timeLeft = 60.obs;
  Timer? _timer;
  Position? currentPosition;
  String? userCountryName;

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
    isLoadingData.value = true;
    stopCountDown();
    determinePosition();
    Log().d("fetching iss position");
    var apiTask = await AppRepository.instance.fetchIssPosition();
    isLastAttemptSuccess.value = apiTask.isSuccessful;
    if (apiTask.isSuccessful) {
      issNow.value = apiTask.response;
      try {
        var lat = double.parse(apiTask.response!.issPosition.latitude);
        var lng = double.parse(apiTask.response!.issPosition.longitude);
        var countryName = await getCountryName(lat, lng);
        countryIss.value =
            countryName.isNotEmpty ? countryName : "could not get";
        isAboveMyCountry.value = countryIss.value != null &&
            userCountryName != null &&
            countryIss.value!.isNotEmpty &&
            userCountryName!.isNotEmpty &&
            countryIss.value == userCountryName;
      } catch (e) {
        Log().e("fetchIssPosition >> failed to get country name");
      }
    } else {
      Log().e("fetchIssPosition >> ${apiTask.exception}");
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
    Log().d('Getting user current location and country name');
    currentPosition = await Geolocator.getCurrentPosition();
    if (currentPosition != null) {
      userCountryName = await getCountryName(
          currentPosition!.latitude, currentPosition!.longitude);
      Log().d("User country $userCountryName");
    }
    Log().d(
        "User location latitude: ${currentPosition?.latitude} longitude: ${currentPosition?.longitude}");
    return;
  }

  Future<String> getCountryName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        return placemarks[0].country ?? '';
      } else {
        return '';
      }
    } catch (e) {
      Log().e('Error getting country name: $e');
      return '';
    }
  }
}
