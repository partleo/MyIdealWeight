

String getCurrentDate() {
  DateTime now = DateTime.now();
  String date = now.toString().substring(0,10);
  return date;
}

String displayTime(int minutes) {
  var d = Duration(minutes:minutes);
  List<String> parts = d.toString().split(':');
  return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
}