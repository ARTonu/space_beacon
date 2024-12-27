import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:space_beacon/data/repositories/open_api/response_models/iss_now_model.dart';
import 'package:space_beacon/data/repositories/open_api/response_models/iss_position_model.dart';
import 'package:space_beacon/ui/home/home_screen_controller.dart';

class MockHomeScreenController extends GetxController
    implements HomeScreenController {
  Timer? _countDownTimer;

  @override
  var issNow = Rx<IssNowModel?>(null);

  @override
  var isAboveMyCountry = false.obs;

  @override
  var isLoadingData = false.obs;

  @override
  var isLastAttemptSuccess = false.obs;

  @override
  var timeLeft = 10.obs;

  @override
  var countryIss = ''.obs;

  @override
  Future<void> determinePosition() async {
    // Simulate position determination
  }

  @override
  Future<void> fetchIssPosition() async {
    // Simulate ISS position fetching
    await Future.delayed(const Duration(seconds: 2));
    issNow.value = mockIssData();
  }

  @override
  Future<void> onInit() async {
    await fetchIssPosition();
    print("MockHomeScreenController initialized");
    super.onInit();
  }

  IssNowModel mockIssData() {
    return const IssNowModel(
      issPosition: IssPositionModel(latitude: "12.345", longitude: "67.890"),
      message: 'success',
      timestamp: 1735279372,
    );
  }

  @override
  Position? currentPosition;

  @override
  String? userCountryName;

  @override
  Future<String> getCountryName(double latitude, double longitude) async {
    // Mock implementation to simulate getting country name
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    if (latitude > 0 && longitude > 0) {
      return "Mock Country";
    } else {
      return "Unknown Country";
    }
  }

  @override
  String getLastUpdateTimeLocal() {
    // Returns a formatted local date-time string
    final now = DateTime.now();
    return "${now.hour}:${now.minute}:${now.second}, ${now.day}/${now.month}/${now.year}";
  }

  @override
  String getLastUpdateTimeUtc() {
    // Returns a formatted UTC date-time string
    final nowUtc = DateTime.now().toUtc();
    return "${nowUtc.hour}:${nowUtc.minute}:${nowUtc.second} UTC, ${nowUtc.day}/${nowUtc.month}/${nowUtc.year}";
  }

  @override
  void startCountDown() {
    // Starts a countdown and updates the observable timeLeft
    stopCountDown(); // Ensure no previous timers are running
    _countDownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft.value > 0) {
        timeLeft.value--;
      } else {
        stopCountDown(); // Stop the countdown when it reaches zero
      }
    });
  }

  @override
  void stopCountDown() {
    // Stops the countdown timer
    _countDownTimer?.cancel();
    _countDownTimer = null;
  }
}
