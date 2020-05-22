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


  CompetitionBloc(this._userRepository);

  @override
  CompetitionState get initialState => InitialCompetitionState();

  @override
  Stream<CompetitionState> mapEventToState(CompetitionEvent event) async* {
    if (event is UpdateDate) {
      competition.date = event.date;
    }
    else if (event is UpdateStartTime) {
      competition.startTime = event.startTime;
    }
    else if (event is UpdateName) {
      competition.name = event.name;
    }
    else if (event is UpdateAddress) {
      competition.address = event.address;
    }
    else if (event is Submit) {
      yield IsSubmitting();
      try {
       Competition _newCompetition = await competition.uploadCompetition(_userRepository);
        _userRepository.diary.competitionList.add(_newCompetition);
        yield SubmissionSuccessful();
      } catch (e) {
        print(e);
        yield SubmissionFailed();
      }
    }
  }

}
