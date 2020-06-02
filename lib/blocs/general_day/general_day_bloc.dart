import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eathlete/models/diary_model.dart';
import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';

import '../../misc/user_repository.dart';

part 'general_day_event.dart';

part 'general_day_state.dart';

class GeneralDayBloc extends Bloc<GeneralDayEvent, GeneralDayState> {

  GeneralDay _generalDay;
  UserRepository _userRepository;


  GeneralDayBloc(this._userRepository,{GeneralDay generalDay}):_generalDay = generalDay ?? GeneralDay();

  @override
  GeneralDayState get initialState => InitialGeneralDayState(_generalDay);

  @override
  Stream<GeneralDayState> mapEventToState(GeneralDayEvent event) async* {
    if(event is UpdateRested){
        _generalDay.rested = event.rested;
        yield InitialGeneralDayState(_generalDay);
    }
    else if(event is UpdateNutrition){
      _generalDay.nutrition = event.nutrition;
      yield InitialGeneralDayState(_generalDay);
    }
    else if(event is UpdateConcentration){
      _generalDay.concentration = event.concentration;
      yield InitialGeneralDayState(_generalDay);
    }
    else if(event is UpdateReflections){
      _generalDay.reflections =event.reflections;
      yield InitialGeneralDayState(_generalDay);
    }
    else if(event is Submit){
      yield IsSubmitting(_generalDay);
      try{
        GeneralDay newGeneralDay = await _generalDay.uploadGeneralDay(_userRepository);
        _userRepository.diary.generalDayList.add(newGeneralDay);
        yield SubmissionSuccessful(_generalDay);
      }catch(e){
        print(e);
        yield SubmissionFailed(_generalDay);
      }
    }

  }
}
