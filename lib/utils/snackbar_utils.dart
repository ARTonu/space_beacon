import 'package:flutter/material.dart';
import 'package:get/get.dart';

SnackbarController showErrorSnackBar(String title, String message) {
  return Get.snackbar(
    title,
    message,
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.red,
    colorText: Colors.white,
  );
}

SnackbarController showSuccessSnackBar(String title, String message) {
  return Get.snackbar(
    title,
    message,
    duration: const Duration(seconds: 2),
    backgroundColor: Colors.green,
    colorText: Colors.white,
  );
}

SnackbarController showInfoSnackBar(String title, String message) {
  return Get.snackbar(
    title,
    message,
    duration: const Duration(seconds: 3),
  );
}
