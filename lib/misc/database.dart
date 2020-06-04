import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../models/diary_model.dart';
import '../models/user_model.dart';

// TODO: make base DB class that is then extended by userDB class and DiaryDB class

class DBHelper {
  static Database _db;

  static Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  //Creating a database with name test.dn in your directory
  static initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "user.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }


  static Future<void> dropTables() async {
    var dbClient = await db;
    await dbClient.execute("DROP TABLE IF EXISTS User");
    await dbClient.execute("DROP TABLE IF EXISTS Sessions");
    await dbClient.execute("DROP TABLE IF EXISTS GeneralDays");
    await dbClient.execute("DROP TABLE IF EXISTS Competitions");
  }

  
  static void deleteDataFromTable(String tableName)async{
  var dbClient = await db;
  await dbClient.execute("DELETE FROM $tableName");
  }
  
  
  static void createUserTable() async {
    var dbClient = await db;

    await dbClient.execute(
        "CREATE TABLE User(id TEXT PRIMARY KEY, firstName TEXT, " +
            "lastName TEXT, dOB TEXT, profilePhoto TEXT, sex TEXT, " +
            "height INTEGER, weight INTEGER, sport TEXT, shortTermGoal TEXT, " +
            "mediumTermGoal TEXT, longTermGoal TEXT, jwt TEXT )");
    print("Created User table");
  }

  //There may be an error at some point where sql tries to create 2 tables

  // Creating a table name User with fields
  static void _onCreate(Database db, int version) async {}

  static Future<String> getJwt() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM User');
    return list[0]['jwt'];
  }

  static Future<List> getUser(User user) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM User');
    Map userMap = list[0];

    user.firstName = userMap['firstName'];
    user.lastName = userMap['lastName'];
    user.dOB = userMap['dOB'];
    user.profilePhoto = userMap['profilePhoto'];
    user.sex = userMap['sex'];
    user.height = userMap['height'];
    user.weight = userMap['weight'];
    user.sport = userMap['sport'];
    user.shortTermGoal = userMap['shortTermGoal'];
    user.mediumTermGoal = userMap['mediumTermGoal'];
    user.longTermGoal = userMap['longTermGoal'];
    user.jwt = userMap['jwt'];

    return list;
  }

  static void updateUser(User user) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawUpdate('UPDATE User ' +
          "SET " +
          "firstName = '${user.firstName}'," +
          "lastName = '${user.lastName}'," +
          "dOB = '${user.dOB}'," +
          "profilePhoto = '${user.profilePhoto}'," +
          "sex = '${user.sex}'," +
          "height = ${user.height}," +
          "weight = ${user.weight}," +
          "sport = '${user.sport}'," +
          "shortTermGoal = '${user.shortTermGoal}'," +
          "mediumTermGoal = '${user.mediumTermGoal}'," +
          "longTermGoal = '${user.longTermGoal}'" +
          "WHERE id = 1;");
    });
  }

  static void saveUser(User user) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert('INSERT INTO User (firstName,' +
          'lastName,' +
          'dOB,' +
          'profilePhoto,' +
          'sex,' +
          'height,' +
          'weight,' +
          'sport,' +
          'shortTermGoal,' +
          'mediumTermGoal,' +
          'longTermGoal,' +
          'jwt)'
              'VALUES ('
              "'${user.firstName}'," +
          "'${user.lastName}'," +
          "'${user.dOB}'," +
          "'${user.profilePhoto}'," +
          "'${user.sex}'," +
          "${user.height}," +
          "${user.weight}," +
          "'${user.sport}'," +
          "'${user.shortTermGoal}'," +
          "'${user.mediumTermGoal}'," +
          "'${user.longTermGoal}'," +
          "'${user.jwt}'" +
          ');');
    });
  }
  /// Used for  querying the internal memory and adding sessionList to the
  /// UserRepository model. Only called when app is opened and user is logged in
  static Future<List<Session>> getSessions() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Sessions');
    List<Session> sessionsList = [];
    for (var session in list) {
      Session newSession = Session();
      newSession.id = session['id'];
      newSession.title = session['title'];
      newSession.date = session['date'];
      newSession.lengthOfSession = session['lengthOfSession'];
      newSession.intensity = session['intensity'];
      newSession.performance = session['performance'];
      newSession.feeling = session['feeling'];
      newSession.target = session['target'];
      newSession.reflections = session['reflections'];
      sessionsList.add(newSession);
    }
    return sessionsList;
  }

  static void createSessionsTable() async {
    var dbClient = await db;

    await dbClient.execute(
        "CREATE TABLE Sessions (id INTEGER PRIMARY KEY, title TEXT, " +
            "date TEXT, lengthOfSession INTEGER, intensity INTEGER, performance INTEGER, " +
            "feeling TEXT, target TEXT, reflections TEXT" +
            ")");
    print("Created Sessions table");
  }
  ///Adds the current sessionList to the sqflite internal memory
  static void updateSessionsList(List<Session> sessions) async {
    var dbClient = await db;
    for (Session session in sessions) {
      await dbClient.transaction((txn) async {
        return await txn.rawInsert('INSERT INTO  Sessions' +
            "(id, title, date, lengthOfSession, intensity, performance," +
            "feeling, target, reflections) VALUES(" +
            "?, ?, ?, ?, ?, ?, ?, ?, ?)",
            [session.id, session.title, session.date, session.lengthOfSession, session.intensity, session.performance, session.feeling, session.target, session.reflections]
        );
      });
    }
  }

  static void deleteSession(List<Session> sessions) async{
    var dbClient = await db;
    for (Session session in sessions){
      await dbClient.transaction((txn) async {
        return await txn.rawDelete('DELETE FROM Sessions WHERE id = ?',
            [session.id]);
      });
    }
  }

  /// creates generalDayTable, when user logs in. This can then be populated
  static void createGeneralDayTable() async {
    var dbClient = await db;

    await dbClient.execute("CREATE TABLE GeneralDays (id INTEGER PRIMARY KEY, " +
        "date TEXT, rested INTEGER, nutrition INTEGER, concentration INTEGER, " +
        "reflections TEXT" +
        ")");
    print("Created GeneralDays table");
  }

  /// Used for  querying the internal memory and adding generalDayList to the
  /// UserRepository model. Only called when app is opened and user is logged in
  static Future<List<GeneralDay>> getGeneralDay() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM GeneralDays');
    List<GeneralDay> generalDayList = [];
    for (var generalDay in list) {
      GeneralDay newGeneralDay = GeneralDay();
      newGeneralDay.id = generalDay['id'];
      newGeneralDay.date = generalDay['date'];
      newGeneralDay.rested = generalDay['rested'];
      newGeneralDay.nutrition = generalDay['nutrition'];
      newGeneralDay.concentration = generalDay['concentration'];
      newGeneralDay.reflections = generalDay['reflections'];
      generalDayList.add(newGeneralDay);
    }
    return generalDayList;
  }

  static void updateGeneralDayList(List<GeneralDay> generalDays) async {
    var dbClient = await db;
    for (GeneralDay generalDay in generalDays) {
      await dbClient.transaction((txn) async {
        return await txn.rawInsert('INSERT INTO  GeneralDays' +
            "(id, date, rested, nutrition, concentration," +
            "reflections) VALUES(" +
            "?, ?, ?, ?, ?, ?)",
        [generalDay.id, generalDay.date, generalDay.rested, generalDay.nutrition, generalDay.concentration, generalDay.reflections]);
      });
    }
  }

  static void updateGeneralDayValue(List<GeneralDay> generalDays) async {
    var dbClient = await db;
    for (GeneralDay generalDay in generalDays){
      await dbClient.transaction((txn) async{
        return await txn.rawUpdate('UPDATE GeneralDays' +
        ' SET date = ?, rested = ?, nutrition = ?, concentration = ?, reflections = ?' +
        ' WHERE id = ?',
        [generalDay.date, generalDay.rested, generalDay.nutrition, generalDay.concentration, generalDay.reflections, generalDay.id]);
      });
    }
  }

  static void deleteGeneralDayItem(List<GeneralDay> generalDays) async{
    var dbClient = await db;
    for (GeneralDay generalDay in generalDays){
      await dbClient.transaction((txn) async {
        return await txn.rawDelete('DELETE FROM GeneralDays WHERE id = ?',
        [generalDay.id]);
      });
    }
  }

  static void createCompetitionTable() async {
    var dbClient = await db;

    await dbClient.execute(
        "CREATE TABLE Competitions(id INTEGER PRIMARY KEY, name TEXT, " +
            "date TEXT, startTime TEXT, address TEXT)");
    print("Created Competitions table");
  }

  /// Used for  querying the internal memory and adding generalDayList to the
  /// UserRepository model. Only called when app is opened and user is logged in
  static Future<List<Competition>> getCompetitions() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Competitions');
    List<Competition> competitionList = [];
    for (var competition in list) {
      Competition newCompetition = Competition();
      newCompetition.id = competition['id'];
      newCompetition.date = competition['date'];
      newCompetition.name = competition['name'];
      newCompetition.address = competition['address'];
      newCompetition.startTime = competition['startTime'];
      competitionList.add(newCompetition);
    }
    return competitionList;
  }

  static void updateCompetitionsList(List<Competition> competitions) async {
    var dbClient = await db;
    for (Competition competition in competitions) {
      await dbClient.transaction((txn) async {
        return await txn.rawInsert('INSERT INTO  Competitions' +
            "(id, date, name, address, startTime" +
            ") VALUES(" +
            "?, ?, ?, ?, ?)",
        [competition.id, competition.date, competition.name, competition.address, competition.startTime]);
      });
    }
  }

  static void deleteCompetition(List<Competition> competitions) async{
    var dbClient = await db;
    for (Competition competition in competitions){
      await dbClient.transaction((txn) async {
        return await txn.rawDelete('DELETE FROM Competitions WHERE id = ?',
            [competition.id]);
      });
    }
  }
}
