import 'package:intl/intl.dart';

class DateUtilsHelper {
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  static String durationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}h ${minutes}m";
  }
}
