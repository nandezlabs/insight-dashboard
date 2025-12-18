import '../models/business_calendar.dart';

class BusinessCalendarService {
  static BusinessPeriod calculateCurrentPeriod(DateTime startDate) {
    final now = DateTime.now();
    final daysSinceStart = now.difference(startDate).inDays;
    
    // 7 days in a week, starting Sunday
    final week = ((daysSinceStart ~/ 7) % 4) + 1; // 1-4
    
    // 28 days (4 weeks) in a period
    final period = ((daysSinceStart ~/ 28) % 13) + 1; // 1-13
    
    // 3 periods in a quarter
    final quarter = ((period - 1) ~/ 3) + 1; // 1-4
    
    return BusinessPeriod(
      week: week,
      period: period,
      quarter: quarter,
      currentDate: now,
    );
  }

  static DateTime getWeekStart(DateTime date) {
    // Assuming Sunday is the start of the week
    final weekday = date.weekday;
    final daysToSubtract = weekday % 7; // Convert to Sunday-based
    return date.subtract(Duration(days: daysToSubtract));
  }

  static DateTime getPeriodStart(DateTime startDate, int period) {
    final periodOffset = (period - 1) * 28; // 28 days per period
    return startDate.add(Duration(days: periodOffset));
  }

  static DateTime getQuarterStart(DateTime startDate, int quarter) {
    final quarterOffset = (quarter - 1) * 84; // 3 periods * 28 days
    return startDate.add(Duration(days: quarterOffset));
  }

  static String formatPeriod(BusinessPeriod period) {
    return 'W${period.week} | P${period.period} | Q${period.quarter}';
  }
}
