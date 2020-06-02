import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:eathlete/models/diary_model.dart';
import 'package:eathlete/useful_functions.dart';
import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';

import '../../class_definitions.dart';
import '../../user_repository.dart';

part 'graph_event.dart';

part 'graph_state.dart';

class GraphBloc extends Bloc<GraphEvent, GraphState> {
  final UserRepository userRepository;
  ///Map with lists of all sessions with key values of day they were inputted
  Map sessionMap = {};
  /// Map with lists of all generalDays with key values of day they were inputted
  Map generalDayMap = {};
  ///List of data for the first graph
  List<GraphObject> dataForGraph1 = [];
  ///List of data for the second graph
  List<GraphObject> dataForGraph2 = [];
  ///List of values for bottom axis
  List<TickSpec<DateTime>> days = [];
  ///The current data that is being shown on graph 1
  String graph1Current = 'Intensity';
  ///The current data that is being shown on graph 2
  String graph2Current = 'Performance';
  ///String being shown on the button to change length of time
  String timeFrame = '2 weeks';
  /// String shown on change time period button
  String timePeriod = '${DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day -7).day}'
      ' ${numberToMonth[DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day -7).month]}'
      ' - ${DateTime.now().day} ${numberToMonth[DateTime.now().month]}';
  /// number of days currently being shown
  int numberOfDays = 7;
  /// way of updating the graphs from the name given
  Map nameToFunction;
  DateTime lastDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  Map daysToName = {7:'2 weeks',
  14:'3 weeks',
  21:'4 weeks',
  28:'1 week'};
  GraphBloc({@required this.userRepository}){
    nameToFunction = {
      'Intensity':getGraphDataIntensity(getLastDaysSession(lastDay)),
      'Performance': getGraphDataPerformance(getLastDaysSession(lastDay)),
      'Feeling': getGraphDataFeeling(getLastDaysSession(lastDay)),
      'Rest': getGraphDataRested(getLastDaysGeneralDay(lastDay)),
      'Nutrition': getGraphDataNutrition(getLastDaysGeneralDay(lastDay)),
      'Concentration': getGraphDataConcentration(getLastDaysGeneralDay(lastDay)),
      'None': []};
  }

  List<GraphObject> nameToFunctionFunction (String graphType){
    List<GraphObject> returnValue =[];
    if(graphType == 'Intensity'){
      returnValue = getGraphDataIntensity(getLastDaysSession(lastDay));
    }else if(graphType == 'Performance'){
      returnValue = getGraphDataPerformance(getLastDaysSession(lastDay));
    }else if(graphType == 'Feeling'){
      returnValue = getGraphDataFeeling(getLastDaysSession(lastDay));
    }else if(graphType == 'Rest'){
      returnValue = getGraphDataRested(getLastDaysGeneralDay(lastDay));
    }else if(graphType == 'Nutrition'){
      returnValue = getGraphDataNutrition(getLastDaysGeneralDay(lastDay));
    }else if(graphType == 'Concentration'){
      returnValue = getGraphDataConcentration(getLastDaysGeneralDay(lastDay));
    }else if(graphType == 'None'){
      returnValue = [];
    }

    return returnValue;
  }

  void getIndividualDays() {
    for (GeneralDay generalDay in userRepository.diary.generalDayList) {
      DateTime date = DateTime.parse(generalDay.date);
      generalDayMap.update(date, (existingValue) {
        existingValue.add(generalDay);
        return existingValue;
      }, ifAbsent: () => [generalDay]);
    }
    for (Session session in userRepository.diary.sessionList) {
      DateTime date = DateTime.parse(session.date);
      sessionMap.update(date, (existingValue) {
        existingValue.add(session);
        return existingValue;
      }, ifAbsent: () => [session]);
    }
  }

  List<List> getLastDaysSession(DateTime lastDay) {
    List<List> lastSevenDaysSessions = [];
    print(numberOfDays);
    days =[];
    for (var i = 0; i < numberOfDays; i++) {
      days.add(TickSpec( DateTime(lastDay.year, lastDay.month, lastDay.day - i)));
      DateTime _currentDay =
          DateTime(lastDay.year, lastDay.month, lastDay.day - i);
      List _currentDayEvents = sessionMap[_currentDay];
      if (_currentDayEvents != null) {
        lastSevenDaysSessions.add([_currentDay, _currentDayEvents]);
      }
    }
    //this is a list of lists with [DateTime, [Session, Session, Session etc]

    return lastSevenDaysSessions;
  }

  List<List> getLastDaysGeneralDay(DateTime lastDay) {
    List<List> lastSevenDaysSessions = [];
    print(numberOfDays);
    days = [];
    for (var i = 0; i < numberOfDays; i++) {
      days.add(TickSpec( DateTime(lastDay.year, lastDay.month, lastDay.day - i)));
      DateTime _currentDay =
          DateTime(lastDay.year, lastDay.month, lastDay.day - i);
      List _currentDayEvents = generalDayMap[_currentDay];
      if (_currentDayEvents != null) {
        lastSevenDaysSessions.add([_currentDay, _currentDayEvents]);
      }
    }
    //this is a list of lists with [DateTime, [Session, Session, Session etc]

    return lastSevenDaysSessions;
  }

  List<GraphObject> getGraphDataIntensity(List lastSevenDaySessions) {
    List<GraphObject> returnValue = [];
    for (List item in lastSevenDaySessions) {
      int _totalNumber = 0;
      for (Session _session in item[1]) {
        _totalNumber += _session.intensity;
      }
      int valueToAdd = (_totalNumber / item[1].length).round();

      returnValue.add(GraphObject(item[0], valueToAdd));
    }
    return returnValue;
  }

  List<GraphObject> getGraphDataPerformance(List lastSevenDaySessions) {
    List<GraphObject> returnValue = [];
    for (List item in lastSevenDaySessions) {
      int _totalNumber = 0;
      for (Session _session in item[1]) {
        _totalNumber += _session.performance;
      }
      int valueToAdd = ((_totalNumber / item[1].length) * 2).round();

      returnValue.add(GraphObject(item[0], valueToAdd));
    }
    return returnValue;
  }

  List<GraphObject> getGraphDataRested(List lastSevenDaySessions) {
    List<GraphObject> returnValue = [];
    for (List item in lastSevenDaySessions) {
      int _totalNumber = 0;

      for (GeneralDay _generalDay in item[1]) {
        if (_generalDay.rested != null) {
          _totalNumber += _generalDay.rested;
        }
      }

      int valueToAdd = ((_totalNumber / item[1].length)).round();

      returnValue.add(GraphObject(item[0], valueToAdd));
    }

    return returnValue;
  }

  List<GraphObject> getGraphDataConcentration(List lastSevenDaySessions) {
    List<GraphObject> returnValue = [];
    for (List item in lastSevenDaySessions) {
      int _totalNumber = 0;

      for (GeneralDay _generalDay in item[1]) {
        if (_generalDay.concentration != null) {
          _totalNumber += _generalDay.concentration;
        }
      }

      int valueToAdd = ((_totalNumber / item[1].length)).round();

      returnValue.add(GraphObject(item[0], valueToAdd));
    }

    return returnValue;
  }

  List<GraphObject> getGraphDataNutrition(List lastSevenDaySessions) {
    List<GraphObject> returnValue = [];
    for (List item in lastSevenDaySessions) {
      int _totalNumber = 0;

      for (GeneralDay _generalDay in item[1]) {
        if (_generalDay.nutrition != null) {
          _totalNumber += _generalDay.nutrition;
        }
      }

      int valueToAdd = ((_totalNumber / item[1].length)).round();

      returnValue.add(GraphObject(item[0], valueToAdd));
    }

    return returnValue;
  }

  List<GraphObject> getGraphDataFeeling(List lastSevenDaySessions) {
    Map feelingToInt = {
      'Frustrated': 2,
      'Bad': 4,
      'Neutral': 6,
      'Happy': 8,
      'Buzzing': 10
    };
    List<GraphObject> returnValue = [];
    for (List item in lastSevenDaySessions) {
      int _totalNumber = 0;

      for (Session _session in item[1]) {
        if (feelingToInt[_session.feeling] != null) {
          _totalNumber += feelingToInt[_session.feeling];
        }
      }

      int valueToAdd = ((_totalNumber / item[1].length)).round();

      returnValue.add(GraphObject(item[0], valueToAdd));
    }

    return returnValue;
  }

  @override
  GraphState get initialState {
    getIndividualDays();
    dataForGraph1 = getGraphDataIntensity(getLastDaysSession(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day)));
    dataForGraph2 = getGraphDataPerformance(getLastDaysSession(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day)));
    return InitialGraphState(dataForGraph1, dataForGraph2, timeFrame, timePeriod, days);
  }

  @override
  Stream<GraphState> mapEventToState(GraphEvent event) async* {
    if (event is ChangeGraph1) {
      graph1Current = event.valueName;
      print(graph1Current);
      dataForGraph1 = nameToFunction[event.valueName];
      yield NewGraphInfo(dataForGraph1, dataForGraph2, timeFrame, timePeriod, days);
    }
    if (event is ChangeGraph2) {
      graph2Current = event.valueName;
      print(graph2Current);
      dataForGraph2 = nameToFunction[event.valueName];
      yield NewGraphInfo(dataForGraph1, dataForGraph2, timeFrame, timePeriod, days);
    }
    if (event is ChangeTimeViewBack) {
      lastDay =
          DateTime(lastDay.year, lastDay.month, lastDay.day - numberOfDays);
      timePeriod = '${DateTime(lastDay.year, lastDay.month, lastDay.day-numberOfDays+1).day} ${numberToMonth[DateTime(lastDay.year, lastDay.month, lastDay.day-numberOfDays+1).month]}'
          ' - ${lastDay.day} ${numberToMonth[lastDay.month]}';
      getGraphDataNutrition(getLastDaysGeneralDay(lastDay));
      dataForGraph1 = nameToFunctionFunction(graph1Current);
      dataForGraph2 = nameToFunctionFunction(graph2Current);
      yield NewGraphInfo(dataForGraph1, dataForGraph2, timeFrame, timePeriod, days);
    }
    if (event is ChangeTimeViewForward) {
      lastDay =
          DateTime(lastDay.year, lastDay.month, lastDay.day + numberOfDays);
      timePeriod = '${DateTime(lastDay.year, lastDay.month, lastDay.day-numberOfDays+1).day} ${numberToMonth[DateTime(lastDay.year, lastDay.month, lastDay.day-numberOfDays+1).month]}'
          ' - ${lastDay.day} ${numberToMonth[lastDay.month]}';
      getGraphDataNutrition(getLastDaysGeneralDay(lastDay));
      dataForGraph1 =nameToFunctionFunction(graph1Current);
      dataForGraph2 =
          nameToFunctionFunction(graph2Current);

      yield NewGraphInfo(dataForGraph1, dataForGraph2, timeFrame, timePeriod, days);
    }
    if (event is ChangeTimeViewTimeFrame){
      if(numberOfDays == 28){
        numberOfDays = 7;
      }else numberOfDays += 7;
      timeFrame = daysToName[numberOfDays];
      timePeriod = '${DateTime(lastDay.year, lastDay.month, lastDay.day-numberOfDays+1).day} ${numberToMonth[DateTime(lastDay.year, lastDay.month, lastDay.day-numberOfDays+1).month]}'
          ' - ${lastDay.day} ${numberToMonth[lastDay.month]}';
      getGraphDataNutrition(getLastDaysGeneralDay(lastDay));
      getGraphDataConcentration(getLastDaysGeneralDay(lastDay));
      dataForGraph1 =nameToFunctionFunction(graph1Current);
      dataForGraph2 =
      nameToFunctionFunction(graph2Current);

      yield NewGraphInfo(dataForGraph1, dataForGraph2, timeFrame, timePeriod, days);
    }
  }
}

