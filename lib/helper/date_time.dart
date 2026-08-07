import 'package:timeago/timeago.dart' as timeago;

class TimeAgoHelper {
  TimeAgoHelper._();

  static String format(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return '';

    try {
      return timeago.format(DateTime.parse(dateTime));
    } catch (_) {
      return '';
    }
  }

  static String formatFromDate(DateTime? dateTime) {
    if (dateTime == null) return '';

    return timeago.format(dateTime);
  }
}