import 'package:eathlete/misc/constants.dart';
import 'package:http/http.dart' as http;
import 'package:eathlete/misc/user_repository.dart';
import 'package:eathlete/models/diary_model.dart';


class Goal extends DiaryModel{
  String content;
  String date;
  String setOnDate;
  String goalType;
  int id;

  Goal({this.content, this.date, this.setOnDate, this.id, this.goalType});

  void sendToItemsToSend(UserRepository _userRepository){
    _userRepository.diaryItemsToSend.add(Goal(
      content: content,
      date: date,
      setOnDate: setOnDate,
      id: id
    ));
  }

  Future<DiaryModel> upload(UserRepository _userRepository)async{
    Map body = {};
    if(content != null) body['content'] = content;
    if(date != null) body['deadline'] = date;
    if(setOnDate != null) body['set_on_Date'] = setOnDate;
    if(id != null) body['id'] = id;
    if(goalType != null) body['goal_type'] = goalType;
    var response = await http.post(kAPIAddress + '/api/goals/',
    headers: {'Authorization': 'JWT ${await _userRepository.refreshIdToken()}'},
      body: body
    );
    if(response.statusCode ==201){

    }else{

    }
  }

  Future<String> delete(UserRepository _userRepository){}
}