import 'package:intl/intl.dart';

class DateHelper {
  // ------------------------------------------------------------
  // DATE FORMATTING
  // ------------------------------------------------------------

  /// Global formatter method
  static String formatDate(DateTime date, {String pattern = 'yyyy-MM-dd'}) {
    return DateFormat(pattern).format(date);
  }

  /// For parsing if needed later
  static DateTime parseDate(String date, {String pattern = 'yyyy-MM-dd'}) {
    return DateFormat(pattern).parse(date);
  }

  // ------------------------------------------------------------
  // TIME FORMATTING
  // ------------------------------------------------------------

  /// Convert a time string to another time format
  /// Example: "14:30" -> "2:30 PM"
  static String formatTimeString(String time, {String from = 'HH:mm', String to = 'h:mm a'}) {
    final dt = DateFormat(from).parse(time);
    return DateFormat(to).format(dt);
  }

  /// Format only time from DateTime
  /// Example: DateTime.now() -> 2:30 PM
  static String formatTime(DateTime date, {String pattern = 'h:mm a'}) {
    return DateFormat(pattern).format(date);
  }

  // ------------------------------------------------------------
  // CUSTOM DATE FORMATTING
  // ------------------------------------------------------------
  static String customFormatDate({
    required String date,
    String fromFormat = 'yyyy-MM-dd',
    String toFormat = 'dd-MM-yyyy',
  }) {
    final inputFormat = DateFormat(fromFormat);
    final outputFormat = DateFormat(toFormat);
    final dateTime = inputFormat.parse(date);
    return outputFormat.format(dateTime);
  }

  static String getCurrentDate() {
    final now = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(now);
  }

  static String formatIsoToYMD(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '';

    try {
      final dateTime = DateTime.parse(isoDate);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  // ------------------------------------------------------------
  // CONVERT TIME FORMATTING
  // ------------------------------------------------------------
  String formatDuration(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return time;

    final int hours = int.tryParse(parts[0]) ?? 0;
    final int minutes = int.tryParse(parts[1]) ?? 0;

    final List<String> result = [];

    if (hours > 0) {
      result.add('$hours Hour${hours > 1 ? 's' : ''}');
    }

    if (minutes > 0) {
      result.add('$minutes Minute${minutes > 1 ? 's' : ''}');
    }

    return result.isEmpty ? '0 Minute' : result.join(' ');
  }

}
