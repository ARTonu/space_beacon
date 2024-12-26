import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:space_beacon/data/repositories/open_api/response_models/iss_now_model.dart';
import 'package:space_beacon/utils/logger.dart';

import '../../data/repositories/open_api/app_repository.dart';

class HomeScreenController extends GetxController {
  final Duration _interval = const Duration(seconds: 1);
  Rx<IssNowModel?> issNow = Rx<IssNowModel?>(null);
  var isLastAttemptSuccess = false.obs;
  var isLoadingData = false.obs;
  var isAboveMyCountry = false.obs;
  var timeLeft = 60.obs;
  Timer? _timer;

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
}
