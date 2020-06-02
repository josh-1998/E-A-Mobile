String timeToString(int time) {
  if (time > 9) {
    return '$time';
  } else {
    return '0$time';
  }
}

String formatTime(int timeInMilliSeconds) {
  int _totalSeconds = timeInMilliSeconds ~/ 1000;
  int _elapsedCentiseconds = (timeInMilliSeconds % 1000) ~/ 10;
  int _elapsedSeconds = _totalSeconds % 60;
  int totalMinutes = _totalSeconds ~/ 60;
  int _elapsedMinutes = totalMinutes % 60;
  int _elapsedHours = totalMinutes ~/ 60;
  return '${timeToString(_elapsedHours)}:${timeToString(_elapsedMinutes)}:${timeToString(_elapsedSeconds)}:${timeToString(_elapsedCentiseconds)}';
}

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

DateTime currentDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);