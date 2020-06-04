// TODO: implement general day and session model

import 'dart:convert';
import 'dart:io';

import '../misc/constants.dart';
import 'package:http/http.dart' as http;

import '../misc/database.dart';
import '../misc/exceptions.dart';
import '../misc/user_repository.dart';

class Session {
  String date;
  int lengthOfSession;
  String title;
  int intensity;
  int performance;
  String feeling;
  String target;
  String reflections;
  int id;

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

    var response = await http.post(kAPIAddress + '/api/session/',
        headers: {'Authorization': 'JWT ' + await _userRepository.refreshIdToken()},
        body: body);
//    print(response.body);
    Map responseBody = jsonDecode(response.body);
    if (response.statusCode != 201) {
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
      ..id = responseBody['id'];
    DBHelper.updateSessionsList([_newSession]);
    return _newSession;
  }

}

Future<void> deleteSession(String jwt, Session session) async {
  int id = session.id;
  print(id);
  var response = await http.delete(kAPIAddress + '/api/general-day/$id/');
  print(response.statusCode);
  DBHelper.deleteSession([session]);
}

Future<List<Session>> getSessionList(String jwt) async {
  var response = await http.get(kAPIAddress + '/api/session/',
      headers: {'Authorization': 'JWT ' + jwt});
  assert(response.statusCode == 200);
  print(response.body);
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
      ..id = session['id'];

    sessions.add(newSession);
  }
//  print(sessions);
  return sessions;
}

class GeneralDay {
  String date;
  int rested;
  int nutrition;
  int concentration;
  String reflections;
  int id;

  GeneralDay(
      {this.date,
      this.rested,
      this.nutrition,
      this.concentration,
      this.reflections,
      this.id});

  /// Updates the server with a new general day and then adds this to the onboard
  /// sql table*
  Future<GeneralDay> uploadGeneralDay(UserRepository _userRepository) async {
    Map body = {};
    if (this.date != null) body['date'] = this.date;
    if (this.rested != null) body['rested'] = this.rested.toString();
    if (this.nutrition != null) body['nutrition'] = this.nutrition.toString();
    if (this.concentration != null)
      body['concentration'] = this.concentration.toString();
    if (this.reflections != null) body['reflections'] = this.reflections;

    http.Response response;
    //sends new general day off to the server
    if(this.id!=null){
      response = await http.patch(kAPIAddress + '/api/general-day/$id/',
          headers: {
            'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
          },
          body: body);
    }else{
      response = await http.post(kAPIAddress + '/api/general-day/',
          headers: {
            'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
          },
          body: body);
    }

    print(response.statusCode);
    print(response.body);
    Map responseBody = jsonDecode(response.body);
    //checks that the upload has been successful
    if ((response.statusCode/100).floor() != 2) {
      print(response.statusCode/100);
      throw ServerErrorException;
    }
    //uploads the new general day to the DB
    GeneralDay _newGeneralDay = GeneralDay()
      ..id = responseBody['id']
      ..date = responseBody['date']
      ..rested = responseBody['rested']
      ..nutrition = responseBody['nutrition']
      ..concentration = responseBody['concentration']
      ..reflections = responseBody['reflections'];
    if(response.statusCode == 201) {
      DBHelper.updateGeneralDayList([_newGeneralDay]);
    }else if(response.statusCode == 200){
      DBHelper.updateGeneralDayValue([_newGeneralDay]);
    }
    //returns the new general day object
    return _newGeneralDay;
  }

}

Future<void> deleteGeneralDayItem(String jwt, GeneralDay generalDay) async {
  int id = generalDay.id;
  print(id);
  var response = await http.delete(kAPIAddress + '/api/general-day/$id/');
  print(response.statusCode);
  DBHelper.deleteGeneralDayItem([generalDay]);
}



Future<List<GeneralDay>> getGeneralDayList(String jwt) async {
  var response = await http.get(kAPIAddress + '/api/general-day/',
      headers: {'Authorization': 'JWT ' + jwt});
  print(response.body);
  List body = jsonDecode(response.body);
  List<GeneralDay> generalDays = [];
  for (var day in body) {
    GeneralDay newDay = GeneralDay()
      ..date = day['date']
      ..rested = day['rested']
      ..nutrition = day['nutrition']
      ..concentration = day['concentration']
      ..reflections = day['reflections']
      ..id = day['id'];
    generalDays.add(newDay);
  }

  return generalDays;
}

class Competition {
  String date; // look  at this
  String name;
  String address;
  String startTime;
  int id;

  Competition({this.date, this.name, this.address, this.startTime, this.id});

  Future<Competition> uploadCompetition(UserRepository _userRepository) async {
    Map body = {};
    if (this.date != null) body['date'] = this.date;
    if (this.name != null) body['name'] = this.name;
    if (this.address != null) body['address'] = this.address;
    if (this.startTime != null) body['start_time'] = this.startTime;

    var response = await http.post(kAPIAddress + '/api/competition/',
        headers: {
          'Authorization': 'JWT ' + await _userRepository.refreshIdToken()
        },
        body: body);
    print(response.statusCode);
    print(response.body);
    Map responseBody = jsonDecode(response.body);
    print(responseBody);
    if (response.statusCode != 201) {
      throw ServerErrorException;
    }
    Competition _newCompetition = Competition()
      ..name = responseBody['name']
    ..date = responseBody['date']
    ..address = responseBody['address']
    ..startTime = responseBody['start_time']
    ..id = responseBody['id'];
    DBHelper.updateCompetitionsList([_newCompetition]);
    return _newCompetition;
  }
}

Future<List<Competition>> getCompetitionList(String jwt) async {
  var response = await http.get(kAPIAddress + '/api/competition/',
      headers: {'Authorization': 'JWT ' + jwt});
  print(response.body);
  List body = jsonDecode(response.body);
  List<Competition> competitions = [];
  for (var competition in body) {
    Competition newComp = Competition()
      ..date = competition['date']
      ..name = competition['name']
      ..address = competition['address']
      ..startTime = competition['start_time']
      ..id = competition['id'];

    competitions.add(newComp);
  }
  print(competitions);
  return competitions;
}

Future<void> deleteCompetition(String jwt, Competition competition) async {
  int id = competition.id;
  print(id);
  var response = await http.delete(kAPIAddress + '/api/general-day/$id/');
  print(response.statusCode);
  DBHelper.deleteCompetition([competition]);
}

class Diary {
  List<Session> sessionList = [];
  List<Competition> competitionList = [];
  List<GeneralDay> generalDayList = [];
}
