import 'dart:io';

///adds a 0 infront of any number less than 10
String timeToString(int time) {
  if (time > 9) {
    return '$time';
  } else {
    return '0$time';
  }
}

///converts total milliseconds into a human readable time
String formatTime(int timeInMilliSeconds) {
  int _totalSeconds = timeInMilliSeconds ~/ 1000;
  int _elapsedCentiseconds = (timeInMilliSeconds % 1000) ~/ 10;
  int _elapsedSeconds = _totalSeconds % 60;
  int totalMinutes = _totalSeconds ~/ 60;
  int _elapsedMinutes = totalMinutes % 60;
  int _elapsedHours = totalMinutes ~/ 60;
  return '${timeToString(_elapsedHours)}:${timeToString(_elapsedMinutes)}:${timeToString(_elapsedSeconds)}:${timeToString(_elapsedCentiseconds)}';
}

///converts numbers 1-12 to month
Map numberToMonth = {
  1: 'Jan',
  2:'Feb',
  3:'Mar',
  4:'Apr',
  5:'May',
  6:'Jun',
  7:'Jul',
  8:'Aug',
  9:'Sep',
  10:'Oct',
  11:'Nov',
  12:'Dec'
};

///returns current day at midnight in a DateTime
DateTime currentDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

/// checks for internet connection, returns true if connected
Future<bool> hasInternetConnection()async{

  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
}
