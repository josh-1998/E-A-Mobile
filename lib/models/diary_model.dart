import 'dart:convert';
import 'package:eathlete/blocs/goals/goals_bloc.dart';
import 'package:eathlete/misc/useful_functions.dart';
import 'package:eathlete/models/user_model.dart';
import '../misc/constants.dart';
import 'package:http/http.dart' as http;
import '../misc/database.dart';
import '../misc/exceptions.dart';
import '../misc/user_repository.dart';
import 'goals.dart';

abstract class DiaryModel{

  Future<DiaryModel> upload(UserRepository userRepository);

  Future<String> delete(UserRepository userRepository);
}

class Session extends DiaryModel{
  String date;
  int lengthOfSession;
  String title;
  int intensity;
  int performance;
  String feeling;
  String target;
  String reflections;
  String id;

  Session({
    this.date,
    this.lengthOfSession,
    this.title,
    this.intensity,
    this.performance,
    this.feeling,
    this.target,
    this.reflections,
    this.id,
  });
  /// Uploads current instance of session to server.
  /// If there is no internet connection then save it to a list ready to be
  /// uploaded when internet connection comes back
  Future<Session> upload(UserRepository _userRepository) async {
      Map body ={};
      if (this.lengthOfSession != null)
        body['time'] = this.lengthOfSession.toString();
      if (this.title != null) body['title'] = this.title;
      if (this.intensity != null) body['intensity'] = this.intensity.toString();
      if (this.performance != null)
        body['performance'] = this.performance.toString();
      if (this.feeling != null) body['feeling'] = this.feeling;
      if (this.target != null) body['target'] = this.target;
      if (this.reflections != null) body['reflections'] = this.reflections;
      if (this.date != null) body['date'] = this.date.substring(0, 10);
      var response;
      String tempid = this.id.substring(1);
      if (this.id[0] == "e") {
        response = await http.patch(kAPIAddress + '/api/session/$tempid/', headers: {
          'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
        },
        body:body);
      } else {
        response = await http.post(kAPIAddress + '/api/session/',
            headers: {
              'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
            },
            body: body);
      }
      Map responseBody = jsonDecode(response.body);
      print(responseBody);
      if ((response.statusCode / 100).floor() != 2) {
        throw ServerErrorException;
      }
      Session _newSession = Session()
        ..title = responseBody['title']
        ..date = responseBody['date']
        ..lengthOfSession = responseBody['time']
        ..intensity = responseBody['intensity']
        ..performance = responseBody['performance']
        ..feeling = responseBody['feeling']
        ..target = responseBody['target']
        ..reflections = responseBody['reflections']
        ..id = responseBody['id'].toString();
      var toRemove = [];
      if (response.statusCode == 201) {
        for(Session item in _userRepository.diaryItemsToSend){
          if (this.id == item.id){
            toRemove.add(item);
          }
        }
        _userRepository.diaryItemsToSend.removeWhere( (e) => toRemove.contains(e));
        DBHelper.deleteSession([this]);
        DBHelper.updateSessionsList([_newSession]);
      } else if (response.statusCode == 200) {
        for(Session item in _userRepository.diaryItemsToSend){
          if (this.id == item.id){
            toRemove.add(item);
          }
        }
        _userRepository.diaryItemsToSend.removeWhere( (e) => toRemove.contains(e));
        DBHelper.deleteSession([this]);
        DBHelper.deleteSession([_newSession]);
        DBHelper.updateSessionsList([_newSession]);
      }
      return _newSession;
  }

  Future<Session> uploadSession(UserRepository _userRepository) async {
    Map body = {};
    if (this.lengthOfSession != null)
      body['time'] = this.lengthOfSession.toString();
    if (this.title != null) body['title'] = this.title;
    if (this.intensity != null) body['intensity'] = this.intensity.toString();
    if (this.performance != null)
      body['performance'] = this.performance.toString();
    if (this.feeling != null) body['feeling'] = this.feeling;
    if (this.target != null) body['target'] = this.target;
    if (this.reflections != null) body['reflections'] = this.reflections;
    if (this.date != null) body['date'] = this.date.substring(0, 10);
    Session _newSession = Session(
        title: title??'Session',
        date: date,
        lengthOfSession: lengthOfSession,
        intensity: intensity,
        performance: performance,
        feeling: feeling,
        target: target,
        reflections: reflections,
        id: id
    );
    if(this.id == null || this.id == "x"){
      this.id = "x";
      DBHelper.updateSessionsList([_newSession]);
    }
    String temp_id = "";
    if(this.id != null){
      if(this.id[0] != 'e' && this.id[0] != 'x'){
        DBHelper.deleteSession([this]);
        temp_id = "e" + this.id;
        this.id = temp_id;
        DBHelper.updateSessionsList([_newSession]);
      }
    }
    _userRepository.diaryItemsToSend.add(this);

    if(await hasInternetConnection()){
      upload(_userRepository);
    }
    return _newSession;
  }

  Future<String> delete(UserRepository _userRepository)async {
    Session session = Session(id:this.id);

    session.id = "d" + session.id;
    //add to delete list
    _userRepository.diaryItemsToDelete.add(session);

    if(await hasInternetConnection()){
      deleteSession(session, _userRepository);
    }
  }
}



Future<void> deleteSession(Session session, UserRepository _userRepository) async {
  //store id without 'd' in temp_id string to interact with the server
  String temp_id = "";
  if(session.id[0] == "d"){
    temp_id = session.id.substring(1);
  }
  //delete from server
  var response = await http.delete(kAPIAddress + '/api/session/$temp_id/',
      headers: {'Authorization': 'JWT ' + await _userRepository.refreshIdToken()});
  //if status code correct, delete from local db and delete list
  if(response.statusCode == 200){
    //delete from local db
    DBHelper.deleteSession([session]);
    //delete from to delete list
    for(Session item in _userRepository.diaryItemsToDelete){
      if(item.id == session.id){
        _userRepository.diaryItemsToDelete.remove(item);
      }
    }//for
  }//status code
}//deleteSession

Future<List<Session>> getSessionList(String jwt) async {
  var response = await http.get(kAPIAddress + '/api/session/',
      headers: {'Authorization': 'JWT ' + jwt});
  assert(response.statusCode == 200);
  List body = jsonDecode(response.body);
  List<Session> sessions = [];
  for (var session in body) {
    Session newSession = Session()
      ..title = session['title']
      ..date = session['date']
      ..lengthOfSession = session['time']
      ..intensity = session['intensity']
      ..performance = session['performance']
      ..feeling = session['feeling']
      ..target = session['target']
      ..reflections = session['reflections']
      ..id = session['id'].toString();

    sessions.add(newSession);
  }
  return sessions;
}

class GeneralDay extends DiaryModel{
  String date;
  int rested;
  int nutrition;
  int concentration;
  String reflections;
  String id;

  GeneralDay(
      {this.date,
        this.rested,
        this.nutrition,
        this.concentration,
        this.reflections,
        this.id});

  /// Updates the server with a new general day and then adds this to the onboard
  /// sql table*
  Future<GeneralDay> upload(UserRepository _userRepository) async {
    if(await hasInternetConnection()) {
      Map body = {};
      if (this.date != null) body['date'] = this.date;
      if (this.rested != null) body['rested'] = this.rested.toString();
      if (this.nutrition != null) body['nutrition'] = this.nutrition.toString();
      if (this.concentration != null)
        body['concentration'] = this.concentration.toString();
      if (this.reflections != null) body['reflections'] = this.reflections;
      if (this.date != null) body['date'] = this.date.substring(0, 10);

      http.Response response;
      //sends new general day off to the server
      if (this.id != null) {
        response = await http.patch(kAPIAddress + '/api/general-day/$id/',
            headers: {
              'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
            },
            body: body);
      } else {
        response = await http.post(kAPIAddress + '/api/general-day/',
            headers: {
              'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
            },
            body: body);
      }

      Map responseBody = jsonDecode(response.body);
      //checks that the upload has been successful
      if ((response.statusCode / 100).floor() != 2) {
        print(response.statusCode / 100);
        throw ServerErrorException;
      }
      //uploads the new general day to the DB
      GeneralDay _newGeneralDay = GeneralDay()
        ..id = responseBody['id'].toString()
        ..date = responseBody['date']
        ..rested = responseBody['rested']
        ..nutrition = responseBody['nutrition']
        ..concentration = responseBody['concentration']
        ..reflections = responseBody['reflections'];
      if (response.statusCode == 201) {
        DBHelper.updateGeneralDayList([_newGeneralDay]);
      } else if (response.statusCode == 200) {
        DBHelper.updateGeneralDayValue([_newGeneralDay]);
      }
      //returns the new general day object
      return _newGeneralDay;
    }else{
      GeneralDay _newGeneralDay = GeneralDay(
          id: id,
          date: date,
          rested: rested,
          nutrition: nutrition,
          concentration: concentration,
          reflections: reflections
      );
      print(id);
      _userRepository.diaryItemsToSend.add(_newGeneralDay);
      if(_newGeneralDay.id != null){
        DBHelper.updateGeneralDayValue([_newGeneralDay]);
      }else{
        DBHelper.updateGeneralDayList([_newGeneralDay]);
      }

      return _newGeneralDay;
    }
  }

  Future<String> delete(UserRepository _userRepository) async {
    var response = await http.delete(kAPIAddress + '/api/general-day/$id/',
        headers: {'Authorization': 'JWT ' + await _userRepository.refreshIdToken()});

    DBHelper.deleteGeneralDayItem([GeneralDay(id: id)]);
  }

}

Future<void> deleteGeneralDayItem(String jwt, GeneralDay generalDay) async {
  String id = generalDay.id;
  var response = await http.delete(kAPIAddress + '/api/general-day/$id/',
      headers: {'Authorization': 'JWT ' + jwt});

  DBHelper.deleteGeneralDayItem([generalDay]);
}

Future<List<GeneralDay>> getGeneralDayList(String jwt) async {
  var response = await http.get(kAPIAddress + '/api/general-day/',
      headers: {'Authorization': 'JWT ' + jwt});
  List body = jsonDecode(response.body);
  List<GeneralDay> generalDays = [];
  for (var day in body) {
    GeneralDay newDay = GeneralDay()
      ..date = day['date']
      ..rested = day['rested']
      ..nutrition = day['nutrition']
      ..concentration = day['concentration']
      ..reflections = day['reflections']
      ..id = day['id'].toString();
    generalDays.add(newDay);
  }

  return generalDays;
}

class Competition extends DiaryModel{
  String date;
  String name;
  String address;
  String startTime;
  String id;

  Competition({this.date, this.name, this.address, this.startTime, this.id});

  Future<Competition> upload(UserRepository _userRepository) async {
    if(await hasInternetConnection()) {
      Map body = {};
      if (this.date != null) body['date'] = this.date;
      if (this.name != null) body['name'] = this.name;
      if (this.address != null) body['address'] = this.address;
      if (this.startTime != null) body['start_time'] = this.startTime;

      var response;
      if (id == null) {
        response = await http.post(kAPIAddress + '/api/competition/',
            headers: {
              'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
            },
            body: body);
      } else {
        response = await http.patch(kAPIAddress + '/api/competition/$id/',
            headers: {
              'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
            },
            body: body);
      }

      Map responseBody = jsonDecode(response.body);
      if ((response.statusCode / 100).floor() != 2) {
        throw ServerErrorException;
      }
      Competition _newCompetition = Competition()
        ..name = responseBody['name']
        ..date = responseBody['date']
        ..address = responseBody['address']
        ..startTime = responseBody['start_time']
        ..id = responseBody['id'].toString();
      if (response.statusCode == 201) {
        DBHelper.updateCompetitionsList([_newCompetition]);
      } else if (response.statusCode == 200) {
        DBHelper.updateCompetitionValue([_newCompetition]);
      }
      return _newCompetition;
    }else{
      Competition _newCompetition = Competition(
          name: name,
          date: date,
          address: address,
          startTime: startTime,
          id: id
      );
      _userRepository.diaryItemsToSend.add(_newCompetition);
      if(id != null){
        DBHelper.updateCompetitionValue([_newCompetition]);
      }else{
        DBHelper.updateCompetitionsList([_newCompetition]);
      }

      return _newCompetition;
    }
  }

  Future<String> delete(UserRepository _userRepository)async{

    var response = await http.delete(kAPIAddress + '/api/competition/$id/',
        headers: {'Authorization': 'JWT ' + await _userRepository.refreshIdToken()});
    DBHelper.deleteCompetition([Competition(id: id)]);
  }
}

Future<List<Competition>> getCompetitionList(String jwt) async {
  var response = await http.get(kAPIAddress + '/api/competition/',
      headers: {'Authorization': 'JWT ' + jwt});
  List body = jsonDecode(response.body);
  List<Competition> competitions = [];
  for (var competition in body) {
    Competition newComp = Competition()
      ..date = competition['date']
      ..name = competition['name']
      ..address = competition['address']
      ..startTime = competition['start_time']
      ..id = competition['id'].toString();

    competitions.add(newComp);
  }
  return competitions;
}

Future<void> deleteCompetition(String jwt, Competition competition) async {
  String id = competition.id;
  var response = await http.delete(kAPIAddress + '/api/competition/$id/',
      headers: {'Authorization': 'JWT ' + jwt});
  DBHelper.deleteCompetition([competition]);
}

class Result extends DiaryModel{
  String id;
  String date;
  String name;
  int position;
  String reflections;

  Result({this.id, this.date, this.name, this.position, this.reflections});

//photo?

  Future<Result> upload(UserRepository _userRepository) async {
    if(await hasInternetConnection()) {
      Map body = {};
      if (this.date != null) body['date'] = this.date;
      if (this.name != null) body['name'] = this.name;
      if (this.position != null) body['position'] = this.position.toString();
      if (this.reflections != null) body['reflections'] = this.reflections;

      var response;
      if (id == null) {
        response = await http.post(kAPIAddress + '/api/result/',
            headers: {
              'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
            },
            body: body);
      } else {
        response = await http.patch(kAPIAddress + '/api/result/$id/',
            headers: {
              'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
            },
            body: body);
      }

      Map responseBody = jsonDecode(response.body);
      print(responseBody);
      if ((response.statusCode / 100).floor() != 2) {
        throw ServerErrorException;
      }
      Result _newResult = Result()
        ..name = responseBody['name']
        ..date = responseBody['date']
        ..position = responseBody['position']
        ..reflections = responseBody['reflections']
        ..id = responseBody['id'].toString();
      if (response.statusCode == 201) {
        DBHelper.updateResultList([_newResult]);
      } else if (response.statusCode == 200) {
        DBHelper.updateResultValue([_newResult]);
      }
      return _newResult;
    }else{
      Result _newResult = Result(
          name: name,
          date: date,
          position: position,
          reflections: reflections,
          id: id
      );
      _userRepository.diaryItemsToSend.add(_newResult);
      if(id !=null){
        DBHelper.updateResultValue([_newResult]);
      }else{
        DBHelper.updateResultList([_newResult]);
      }

      return _newResult;
    }
  }

  Future<String> delete(UserRepository _userRepository) async{
    if(await hasInternetConnection()){
      var response = await http.delete(kAPIAddress + '/api/result/$id/',
          headers: {'Authorization': 'JWT ' + await _userRepository.refreshIdToken()});
      _userRepository.diary.resultList.removeWhere((item) => item.id == this.id);
      DBHelper.deleteResult([Result(id: id)]);
    }else{
      _userRepository.diaryItemsToDelete.add(Result(id: id));
      _userRepository.diary.resultList.removeWhere((item) => item.id == this.id);
      DBHelper.deleteResult([Result(id:id)]);
    }
  }
}

Future<List<Result>> getResultList(String jwt) async {
  var response = await http.get(kAPIAddress + '/api/result/',
      headers: {'Authorization': 'JWT ' + jwt});
  List body = jsonDecode(response.body);
  List<Result> results = [];
  for (var result in body) {
    Result newResult = Result()
      ..date = result['date']
      ..name = result['name']
      ..position = result['position']
      ..reflections = result['reflections']
      ..id = result['id'].toString();

    results.add(newResult);
  }
  print(results);
  return results;
}

Future<void> deleteResult(String jwt, Result result) async {
  String id = result.id;
  var response = await http.delete(kAPIAddress + '/api/result/$id/',
      headers: {'Authorization': 'JWT ' + jwt});
  DBHelper.deleteResult([result]);
}

class Diary {
  List<Session> sessionList = [];
  List<Competition> competitionList = [];
  List<GeneralDay> generalDayList = [];
  List<Result> resultList = [];
  List<Goal> crazyGoal = [];
  List<Goal> longTermGoal = [];
  List<Goal> mediumTermGoals = [Goal(content: 'This is content', id: '1', date: 'hehe', setOnDate: 'haha')];
  List<Goal> shortTermGoals = [];
  List<Goal> finishedGoals = [Goal(content: 'This is content', id: '1', date: 'hehe', setOnDate: 'haha')];
  List<Objective> finishedObjectives = [];
}