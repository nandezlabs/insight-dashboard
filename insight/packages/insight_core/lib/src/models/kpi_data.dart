import 'package:freezed_annotation/freezed_annotation.dart';

part 'kpi_data.freezed.dart';
part 'kpi_data.g.dart';

@freezed
class KpiData with _$KpiData {
  const factory KpiData({
    required String id,
    required DateTime dataDate,
    double? gemScore,
    double? hoursScheduled,
    double? hoursRecommended,
    double? laborUsedPercentage,
    double? salesActual,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _KpiData;

  factory KpiData.fromJson(Map<String, dynamic> json) =>
      _$KpiDataFromJson(json);
}
