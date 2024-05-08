import 'package:intl/intl.dart';

String formatDate(DateTime dateTime) {
  return DateFormat('dd MMMM yyyy').format(dateTime);
}

String formatTime(DateTime dateTime) {
  return DateFormat('hh:mm:ss a').format(dateTime);
}
