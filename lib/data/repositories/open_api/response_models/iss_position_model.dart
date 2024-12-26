import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../../gen/data/repositories/open_api/response_models/iss_position_model.freezed.dart';

part '../../../../gen/data/repositories/open_api/response_models/iss_position_model.g.dart';

@freezed
class IssPositionModel with _$IssPositionModel {
  const factory IssPositionModel({
    required String latitude,
    required String longitude
  }) = _IssPositionModel;

  factory IssPositionModel.fromJson(Map<String, dynamic> json) => _$IssPositionModelFromJson(json);
}
