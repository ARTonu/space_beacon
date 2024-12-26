import 'package:freezed_annotation/freezed_annotation.dart';

import 'iss_position_model.dart';

part '../../../../gen/data/repositories/open_api/response_models/iss_now_model.freezed.dart';

part '../../../../gen/data/repositories/open_api/response_models/iss_now_model.g.dart';

@freezed
class IssNowModel with _$IssNowModel {
  const factory IssNowModel({
    @JsonKey(name: 'iss_position') required IssPositionModel issPosition,
    required String message,
    required int timestamp
  }) = _IssNowModel;

  factory IssNowModel.fromJson(Map<String, dynamic> json) => _$IssNowModelFromJson(json);
}
