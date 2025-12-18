import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_calendar.freezed.dart';
part 'business_calendar.g.dart';

@freezed
class BusinessCalendar with _$BusinessCalendar {
  const factory BusinessCalendar({
    required String id,
    required DateTime startDate,
    required int currentWeek,
    required int currentPeriod,
    required int currentQuarter,
    required DateTime updatedAt,
  }) = _BusinessCalendar;

  factory BusinessCalendar.fromJson(Map<String, dynamic> json) =>
      _$BusinessCalendarFromJson(json);
}

@freezed
class BusinessPeriod with _$BusinessPeriod {
  const factory BusinessPeriod({
    required int week,
    required int period,
    required int quarter,
    required DateTime currentDate,
  }) = _BusinessPeriod;

  factory BusinessPeriod.fromJson(Map<String, dynamic> json) =>
      _$BusinessPeriodFromJson(json);
}
