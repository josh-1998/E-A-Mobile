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
  List<bool> conditions= [false, false, false, false];


  CompetitionBloc(this._userRepository, {Competition competition}):_competition = competition ?? Competition();

  @override
  CompetitionState get initialState => InitialCompetitionState(_competition);

  @override
  Stream<CompetitionState> mapEventToState(CompetitionEvent event) async* {
    if (event is UpdateDate) {
      _competition.date = event.date;
      conditions[0] = true;
    }
    else if (event is UpdateStartTime) {
      _competition.startTime = event.startTime;
      conditions[1]=true;
    }
    else if (event is UpdateName) {
      _competition.name = event.name;
      if(event.name!=null && event.name != ''){
        conditions[2]=true;
      }else{
        conditions[2]=false;
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
          Competition _newCompetition = await _competition.uploadCompetition(
              _userRepository);
          _userRepository.diary.competitionList.add(_newCompetition);
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
