import '../models/form.dart';
import '../models/timeframe.dart';

class FormSchedulerService {
  /// Check if a form is currently available based on its schedule
  static bool isFormAvailable(
    FormModel form,
    List<Timeframe> timeframes,
    DateTime now,
  ) {
    if (form.scheduleType == FormScheduleType.manual) {
      return true;
    }

    if (form.scheduleType == FormScheduleType.tagBased) {
      return _checkTagSchedule(form.tags, timeframes, now);
    }

    if (form.scheduleType == FormScheduleType.custom) {
      return _checkCustomSchedule(form, now);
    }

    return false;
  }

  /// Check availability based on form tags and timeframes
  static bool _checkTagSchedule(
    List<String> tags,
    List<Timeframe> timeframes,
    DateTime now,
  ) {
    for (final tag in tags) {
      final timeframe = timeframes.firstWhere(
        (t) => t.tag == tag,
        orElse: () => timeframes.firstWhere(
          (t) => t.isDefault,
          orElse: () => throw Exception('No default timeframe found'),
        ),
      );

      if (_isWithinTimeframe(timeframe, now)) {
        return true;
      }
    }
    return false;
  }

  /// Check custom schedule
  static bool _checkCustomSchedule(FormModel form, DateTime now) {
    if (form.customStartDate != null && form.customEndDate != null) {
      final isWithinDateRange = now.isAfter(form.customStartDate!) &&
          now.isBefore(form.customEndDate!);

      if (!isWithinDateRange) {
        return false;
      }
    }

    if (form.customTime != null) {
      // Parse time and check if within that time
      final parts = form.customTime!.split(':');
      final customHour = int.parse(parts[0]);
      final customMinute = int.parse(parts[1]);

      final customDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        customHour,
        customMinute,
      );

      return now.isAfter(customDateTime);
    }

    return true;
  }

  /// Check if current time is within timeframe
  static bool _isWithinTimeframe(Timeframe timeframe, DateTime now) {
    final startParts = timeframe.startTime.split(':');
    final endParts = timeframe.endTime.split(':');

    final startTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(startParts[0]),
      int.parse(startParts[1]),
    );

    final endTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(endParts[0]),
      int.parse(endParts[1]),
    );

    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  /// Get auto-submit time for a form
  static DateTime? getAutoSubmitTime(
    FormModel form,
    List<Timeframe> timeframes,
    DateTime now,
  ) {
    if (form.scheduleType != FormScheduleType.tagBased) {
      return null;
    }

    for (final tag in form.tags) {
      final timeframe = timeframes.firstWhere(
        (t) => t.tag == tag,
        orElse: () => timeframes.firstWhere((t) => t.isDefault),
      );

      final parts = timeframe.autoSubmitTime.split(':');
      return DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    }

    return null;
  }

  /// Check if form should be auto-submitted
  static bool shouldAutoSubmit(
    FormModel form,
    List<Timeframe> timeframes,
    DateTime now,
  ) {
    final autoSubmitTime = getAutoSubmitTime(form, timeframes, now);
    if (autoSubmitTime == null) {
      return false;
    }

    return now.isAfter(autoSubmitTime);
  }
}
