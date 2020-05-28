import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eathlete/models/diary_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../user_repository.dart';

part 'competition_event.dart';

part 'competition_state.dart';

class CompetitionBloc extends Bloc<CompetitionEvent, CompetitionState> {
  Competition competition = Competition();
  UserRepository _userRepository;
  List<bool> conditions= [false, false, false, false];


  CompetitionBloc(this._userRepository);

  @override
  CompetitionState get initialState => InitialCompetitionState();

  @override
  Stream<CompetitionState> mapEventToState(CompetitionEvent event) async* {
    if (event is UpdateDate) {
      competition.date = event.date;
      conditions[0] = true;
    }
    else if (event is UpdateStartTime) {
      competition.startTime = event.startTime;
      conditions[1]=true;
    }
    else if (event is UpdateName) {
      competition.name = event.name;
      if(event.name!=null && event.name != ''){
        conditions[2]=true;
      }else{
        conditions[2]=false;
      }
    }
    else if (event is UpdateAddress) {
      competition.address = event.address;
      if(event.address!=null && event.address != ''){
        conditions[3]=true;
      }else{
        conditions[3]=false;
      }
    }
    else if (event is Submit) {
      yield IsSubmitting();
      int numberOfFalse = 0;
      for(bool value in conditions){
        if(value == false){
          numberOfFalse++;
        }
      }
      if(numberOfFalse == 0) {
        try {
          Competition _newCompetition = await competition.uploadCompetition(
              _userRepository);
          _userRepository.diary.competitionList.add(_newCompetition);
          yield SubmissionSuccessful();
        } catch (e) {
          print(e);
          yield SubmissionFailed();
        }
      }else{
        yield InformationIncomplete(conditions);
      }
    }
  }

}
