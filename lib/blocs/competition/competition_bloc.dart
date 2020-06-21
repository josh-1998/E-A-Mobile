import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eathlete/models/diary_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../misc/user_repository.dart';

part 'competition_event.dart';

part 'competition_state.dart';

class CompetitionBloc extends Bloc<CompetitionEvent, CompetitionState> {
  Competition _competition;
  UserRepository _userRepository;
  //validation of form fields, 0: title, 1: Competition Date, 2: start time 3: address
  List<bool> conditions= [false, false, false, false];


  CompetitionBloc(this._userRepository, {Competition competition}):_competition = competition ?? Competition();

  @override
  CompetitionState get initialState {
    if(_competition.name!=null)conditions[0]=true;
    if(_competition.date!=null)conditions[1]=true;
    if(_competition.startTime!=null)conditions[2]=true;
    if(_competition.address!=null)conditions[3]=true;
    return InitialCompetitionState(_competition);}

  @override
  Stream<CompetitionState> mapEventToState(CompetitionEvent event) async* {
    if (event is UpdateDate) {
      _competition.date = event.date;
      conditions[1] = true;
    }
    else if (event is UpdateStartTime) {
      _competition.startTime = event.startTime;
      conditions[2]=true;
    }
    else if (event is UpdateName) {
      _competition.name = event.name;
      if(event.name!=null && event.name != ''){
        conditions[0]=true;
      }else{
        conditions[0]=false;
      }
    }
    else if (event is UpdateAddress) {
      _competition.address = event.address;
      if(event.address!=null && event.address != ''){
        conditions[3]=true;
      }else{
        conditions[3]=false;
      }
    }
    else if (event is Submit) {
      yield IsSubmitting(_competition);
      int numberOfFalse = 0;
      for(bool value in conditions){
        if(value == false){
          numberOfFalse++;
        }
      }
      if(numberOfFalse == 0) {
        try {
          Competition _newCompetition = await _competition.upload(
              _userRepository);
          if(_competition.id == null) _userRepository.diary.competitionList.add(_newCompetition);
          yield SubmissionSuccessful(_competition);
        } catch (e) {
          print(e);
          yield SubmissionFailed(_competition);
        }
      }else{
        yield InformationIncomplete(_competition, conditions);
      }
    }
  }

}
