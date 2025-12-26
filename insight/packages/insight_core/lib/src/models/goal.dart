import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal.freezed.dart';
part 'goal.g.dart';

enum GoalType {
  @JsonValue('sales_week')
  salesWeek,
  @JsonValue('sales_period')
  salesPeriod,
  @JsonValue('gem_period')
  gemPeriod,
  @JsonValue('labor_percentage')
  laborPercentage,
}

@freezed
class Goal with _$Goal {
  const factory Goal({
    required String id,
    required GoalType goalType,
    required double targetValue,
    required DateTime periodDate,
    required DateTime createdAt,
  }) = _Goal;

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);
}
