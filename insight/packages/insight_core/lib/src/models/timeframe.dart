import 'package:freezed_annotation/freezed_annotation.dart';

part 'timeframe.freezed.dart';
part 'timeframe.g.dart';

@freezed
class Timeframe with _$Timeframe {
  const factory Timeframe({
    required String id,
    required String tag,
    required String startTime,
    required String endTime,
    required String autoSubmitTime,
    @Default(false) bool isDefault,
  }) = _Timeframe;

  factory Timeframe.fromJson(Map<String, dynamic> json) =>
      _$TimeframeFromJson(json);
}
