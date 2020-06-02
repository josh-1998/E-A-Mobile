import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eathlete/models/diary_model.dart';
import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';


import '../../user_repository.dart';

part 'calendar_event.dart';

part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final UserRepository userRepository;
//  Diary diary;
  Map<DateTime, List> _competitionMap = {};
  Map<DateTime, List> eventsMap = {};

  CalendarBloc({this.userRepository}) {
//    diary = userRepository.diary;
//    getIndividualDays();
    //TODO: move getIndividualDays into the getter of initial state
  }

  void getIndividualDays() {
    for (Competition currentCompetition in userRepository.diary.competitionList) {
      DateTime date = DateTime.parse(currentCompetition.date);
      _competitionMap.update(date, (List existingValue) {
        existingValue.add(currentCompetition);
        return existingValue;
      }, ifAbsent: () => [currentCompetition]);
      eventsMap.update(date, (List existingValue) {
        existingValue.add(currentCompetition);
        return existingValue;
      }, ifAbsent: () => [currentCompetition]);
    }
    for (GeneralDay generalDay in userRepository.diary.generalDayList) {
      DateTime date = DateTime.parse(generalDay.date);
      eventsMap.update(date, (existingValue) {
        existingValue.add(generalDay);
        return existingValue;
      }, ifAbsent: () => [generalDay]);
    }
    for (Session session in userRepository.diary.sessionList) {
      DateTime date = DateTime.parse(session.date);
      eventsMap.update(date, (existingValue) {
        existingValue.add(session);
        return existingValue;
      }, ifAbsent: () => [session]);
    }

  }

//   _eventsMap[DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)]
  @override
  CalendarState get initialState{
    getIndividualDays();
    return InitialCalendarState(
      eventsMap[DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day)] ==
              null
          ? []
          : eventsMap[DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)],
      _competitionMap);}

  @override
  Stream<CalendarState> mapEventToState(CalendarEvent event) async* {
    if (event is ChangeDay) {
      print(eventsMap[event.currentDay]);
      print(_competitionMap[event.currentDay]);
      yield NewDayState(
          eventsMap[event.currentDay] != null
              ? eventsMap[event.currentDay]
              : [],
          _competitionMap);
    }
  }
}
