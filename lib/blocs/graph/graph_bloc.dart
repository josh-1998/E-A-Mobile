import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eathlete/models/diary_model.dart';
import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';

import '../../class_definitions.dart';
import '../../user_repository.dart';

part 'graph_event.dart';

part 'graph_state.dart';

class GraphBloc extends Bloc<GraphEvent, GraphState> {
  final UserRepository userRepository;
  Map sessionMap = {};
  Map generalDayMap = {};
  List<GraphObject> dataForGraph1 = [];
  List<GraphObject> dataForGraph2=[];
  GraphBloc({@required this.userRepository}){

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

  List<List> getLastSevenDays(DateTime lastDay){
    List<List> lastSevenDaysSessions = [];
    for(var i = 0; i< 7; i++){
      DateTime _currentDay = DateTime(lastDay.year, lastDay.month, lastDay.day - i);
      List _currentDayEvents = sessionMap[_currentDay];
      if(_currentDayEvents != null){
        lastSevenDaysSessions.add([_currentDay, _currentDayEvents]);
      }
    }
    //this is a list of lists with [DateTime, [Session, Session, Session etc]

    return lastSevenDaysSessions;
  }

  List<List> getLastSevenDaysGeneralDay(DateTime lastDay){
    List<List> lastSevenDaysSessions = [];
    for(var i = 0; i< 7; i++){
      DateTime _currentDay = DateTime(lastDay.year, lastDay.month, lastDay.day - i);
      List _currentDayEvents = generalDayMap[_currentDay];
      if(_currentDayEvents != null){
        lastSevenDaysSessions.add([_currentDay, _currentDayEvents]);
      }
    }
    //this is a list of lists with [DateTime, [Session, Session, Session etc]

    return lastSevenDaysSessions;
  }

  List<GraphObject> getGraphDataIntensity(List lastSevenDaySessions){
    List<GraphObject> returnValue=[];
    for(List item in lastSevenDaySessions){

      int _totalNumber=0;
      for(Session _session in item[1]){
        _totalNumber += _session.intensity;

      }
      int valueToAdd = (_totalNumber/item[1].length).round();

      returnValue.add(GraphObject(item[0], valueToAdd));
    }
    return returnValue;
  }

  List<GraphObject> getGraphDataPerformance(List lastSevenDaySessions){
    List<GraphObject> returnValue=[];
    for(List item in lastSevenDaySessions){

      int _totalNumber=0;
      for(Session _session in item[1]){
        _totalNumber += _session.performance;

      }
      int valueToAdd = ((_totalNumber/item[1].length)*2).round();

      returnValue.add(GraphObject(item[0], valueToAdd));
    }
    return returnValue;
  }

  List<GraphObject> getGraphDataRested(List lastSevenDaySessions){
    List<GraphObject> returnValue=[];
    for(List item in lastSevenDaySessions){

      int _totalNumber=0;

      for(GeneralDay _generalDay in item[1]){
        if(_generalDay.rested != null) {
          _totalNumber += _generalDay.rested;

        }
      }

      int valueToAdd = ((_totalNumber/item[1].length)).round();


      returnValue.add(GraphObject(item[0], valueToAdd));


    }

    return returnValue;
  }

  List<GraphObject> getGraphDataConcentration(List lastSevenDaySessions){
    List<GraphObject> returnValue=[];
    for(List item in lastSevenDaySessions){

      int _totalNumber=0;

      for(GeneralDay _generalDay in item[1]){
        if(_generalDay.concentration != null) {
          _totalNumber += _generalDay.concentration;

        }
      }

      int valueToAdd = ((_totalNumber/item[1].length)).round();


      returnValue.add(GraphObject(item[0], valueToAdd));


    }

    return returnValue;
  }

  List<GraphObject> getGraphDataNutrition(List lastSevenDaySessions){
    List<GraphObject> returnValue=[];
    for(List item in lastSevenDaySessions){

      int _totalNumber=0;

      for(GeneralDay _generalDay in item[1]){
        if(_generalDay.nutrition != null) {
          _totalNumber += _generalDay.nutrition;

        }
      }

      int valueToAdd = ((_totalNumber/item[1].length)).round();


      returnValue.add(GraphObject(item[0], valueToAdd));


    }

    return returnValue;
  }

  List<GraphObject> getGraphDataFeeling(List lastSevenDaySessions){
    Map feelingToInt = {
      'Pissed':2,
      'Bad':4,
      'Neutral': 6,
      'Happy': 8,
      'Buzzing': 10


    };
    List<GraphObject> returnValue=[];
    for(List item in lastSevenDaySessions){

      int _totalNumber=0;

      for(Session _session in item[1]){
        if(feelingToInt[_session.feeling] != null) {
          _totalNumber += feelingToInt[_session.feeling];

        }
      }

      int valueToAdd = ((_totalNumber/item[1].length)).round();


      returnValue.add(GraphObject(item[0], valueToAdd));


    }

    return returnValue;
  }

  @override
  GraphState get initialState {
    getIndividualDays();
    dataForGraph1 = getGraphDataIntensity(getLastSevenDays(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)));
    dataForGraph2 = getGraphDataPerformance(getLastSevenDays(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)));
    return InitialGraphState(dataForGraph1,dataForGraph2);
  }

  @override
  Stream<GraphState> mapEventToState(GraphEvent event) async* {
    if(event is ChangeGraph1){
        if(event.valueName=='Intensity'){
          dataForGraph1 = getGraphDataIntensity(getLastSevenDays(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)));
          yield NewGraphInfo(dataForGraph1, dataForGraph2);
        }else if(event.valueName=='Performance'){
          dataForGraph1 = getGraphDataPerformance(getLastSevenDays(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)));
          yield NewGraphInfo(dataForGraph1, dataForGraph2);
        }else if(event.valueName == 'Feeling'){
          dataForGraph1 = getGraphDataFeeling(getLastSevenDays(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)));
          yield NewGraphInfo(dataForGraph1, dataForGraph2);
        }else if(event.valueName == 'Rest'){
          dataForGraph1 = getGraphDataRested(getLastSevenDaysGeneralDay(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)));
          yield NewGraphInfo(dataForGraph1, dataForGraph2);
        }else if(event.valueName == 'Nutrition'){
          dataForGraph1 = getGraphDataNutrition(getLastSevenDaysGeneralDay(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)));
          yield NewGraphInfo(dataForGraph1, dataForGraph2);
        }else if(event.valueName == 'Concentration'){
          dataForGraph1 = getGraphDataConcentration(getLastSevenDaysGeneralDay(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)));
          yield NewGraphInfo(dataForGraph1, dataForGraph2);
        }else if(event.valueName == 'None'){
          dataForGraph1 = [];
          yield NewGraphInfo(dataForGraph1, dataForGraph2);
        }
    }
    if (event is ChangeGraph2) {
      if(event.valueName=='Intensity'){

        dataForGraph2 = getGraphDataIntensity(getLastSevenDays(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)));

        yield NewGraphInfo(dataForGraph1, dataForGraph2);
      }else if(event.valueName=='Performance'){
        dataForGraph2 = getGraphDataPerformance(getLastSevenDays(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)));
        yield NewGraphInfo(dataForGraph1, dataForGraph2);
      }else if(event.valueName == 'Feeling'){
        dataForGraph2 = getGraphDataFeeling(getLastSevenDays(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)));
        yield NewGraphInfo(dataForGraph1, dataForGraph2);
      }else if(event.valueName == 'Rest'){
        dataForGraph2 = getGraphDataRested(getLastSevenDaysGeneralDay(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)));
        yield NewGraphInfo(dataForGraph1, dataForGraph2);
      }else if(event.valueName == 'Nutrition'){
        dataForGraph2 = getGraphDataNutrition(getLastSevenDaysGeneralDay(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)));
        yield NewGraphInfo(dataForGraph1, dataForGraph2);
      }else if(event.valueName == 'Concentration'){
        dataForGraph2 = getGraphDataConcentration(getLastSevenDaysGeneralDay(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)));
        yield NewGraphInfo(dataForGraph1, dataForGraph2);
      }else if(event.valueName == 'None'){
        dataForGraph2 = [];
        yield NewGraphInfo(dataForGraph1, dataForGraph2);
      }
    }

  }
}
