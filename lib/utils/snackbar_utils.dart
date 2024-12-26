import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showErrorSnackBar(String title, String message) {
  Get.snackbar(
    title,
    message,
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.red,
    colorText: Colors.white,
  );
}

void showSuccessSnackBar(String title, String message) {
  Get.snackbar(
    title,
    message,
    duration: const Duration(seconds: 2),
    backgroundColor: Colors.green,
    colorText: Colors.white,
  );
}

void showInfoSnackBar(String title, String message) {
  Get.snackbar(
    title,
    message,
    duration: const Duration(seconds: 3),
  );
}
