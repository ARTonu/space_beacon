import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:space_beacon/data/repositories/open_api/response_models/iss_now_model.dart';

part '../../../gen/data/repositories/open_api/open_notify_repo.g.dart';

@RestApi(baseUrl: "http://api.open-notify.org/")
abstract class OpenNotifyRepoRestClient {
  factory OpenNotifyRepoRestClient(Dio dio, {String baseUrl}) =
      _OpenNotifyRepoRestClient;

  @GET('/iss-now.json')
  @Headers(<String, dynamic>{'Accept': 'application/json'})
  Future<IssNowModel> fetchIssPositionNow();
}
