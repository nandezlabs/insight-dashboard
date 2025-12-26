import 'package:intl/intl.dart';

class Formatters {
  static final _dateFormat = DateFormat('MMM d, y');
  static final _timeFormat = DateFormat('h:mm a');
  static final _dateTimeFormat = DateFormat('MMM d, y h:mm a');
  static final _currencyFormat = NumberFormat.currency(symbol: '\$');
  static final _percentFormat = NumberFormat.percentPattern();
  static final _numberFormat = NumberFormat('#,##0.##');

  static String date(DateTime date) => _dateFormat.format(date);

  static String time(DateTime time) => _timeFormat.format(time);

  static String dateTime(DateTime dateTime) => _dateTimeFormat.format(dateTime);

  static String currency(double amount) => _currencyFormat.format(amount);

  static String percent(double value) => _percentFormat.format(value / 100);

  static String number(double value) => _numberFormat.format(value);

  static String relativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year(s) ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month(s) ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day(s) ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour(s) ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute(s) ago';
    } else {
      return 'Just now';
    }
  }
}
