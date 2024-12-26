import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class Log {
  // Singleton instance
  static final Log _instance = Log._internal();

  // Logger instance
  late final Logger _logger;
  static bool enabled = !kReleaseMode;

  // Private constructor
  Log._internal() {
    _logger = Logger();
  }

  // Factory method to return the singleton instance
  factory Log() {
    return _instance;
  }

  // Debug log
  void d(String message) {
    if (enabled) _logger.d(message);
  }

  // Error log
  void e(String message) {
    if (enabled) _logger.e(message);
  }

  // Info log
  void i(String message) {
    if (enabled) _logger.i(message);
  }

  // Warning log
  void w(String message) {
    if (enabled) _logger.w(message);
  }

  // Verbose log
  void v(String message) {
    if (enabled) _logger.v(message);
  }
}
