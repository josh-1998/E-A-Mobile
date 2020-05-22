part of 'calendar_bloc.dart';

@immutable
abstract class CalendarEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class ChangeDay extends CalendarEvent{
  final DateTime currentDay;

  ChangeDay({this.currentDay});

  @override
  List<Object> get props => [currentDay];

}


