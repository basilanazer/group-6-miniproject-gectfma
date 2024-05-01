String formatDate(DateTime dateTime) {
  return "${dateTime.day}-${dateTime.month}-${dateTime.year}";
}

String formatTime(DateTime dateTime) {
  return "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
}
