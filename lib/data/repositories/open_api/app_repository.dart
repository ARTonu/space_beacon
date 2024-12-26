import 'package:dio/dio.dart';
import 'package:space_beacon/data/repositories/open_api/open_notify_repo.dart';
import 'package:space_beacon/data/repositories/open_api/response_models/iss_now_model.dart';

import '../../../utils/logger.dart';
import '../api_request_task.dart';

class AppRepository {
  static final AppRepository _instance = AppRepository._internal();
  late Dio _dio;
  late OpenNotifyRepoRestClient _client; // Provide a dio instance
  OpenNotifyRepoRestClient get getOpenNotifyClient => _client;

  AppRepository._internal() {
    var options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
    );
    _dio = Dio(options);
    _dio.interceptors.add(LogInterceptor(responseBody: true));
    _client = OpenNotifyRepoRestClient(_dio);
  }

  static AppRepository get instance => _instance;

  Future<ApiRequestTask<IssNowModel>> fetchIssPosition() async {
    try {
      // Perform the API call
      var issNowModel = await _client.fetchIssPositionNow();
      return ApiRequestTask<IssNowModel>(
        isSuccessful: true,
        httpStatusCode: 200,
        response: issNowModel,
      );
    } on DioException catch (e) {
      // Handle Dio-specific errors
      final res = e.response;
      final statusCode = res == null ? 404 : res.statusCode ?? 500;
      Log().e('DioException: ${res?.statusCode} -> ${res?.statusMessage}');
      return ApiRequestTask(
        isSuccessful: false,
        httpStatusCode: statusCode,
        exception: e,
      );
    } catch (e) {
      // Handle other exceptions
      Log().e('An unexpected error occurred: $e');
      return ApiRequestTask(
        isSuccessful: false,
        httpStatusCode: 500,
        exception: Exception("Unexpected error $e"),
      );
    }
  }
}
