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
