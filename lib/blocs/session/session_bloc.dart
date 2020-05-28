import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eathlete/models/diary_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

import '../../user_repository.dart';

part 'session_event.dart';

part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  Session session;
  UserRepository _userRepository;
  /// stores result from validation
  ///0:Intensity, 1: performance, 2: feeling
  List<bool> conditions= [false, false, false,];



  SessionBloc(this._userRepository,):session = Session(); //  final UserRepository _userRepository;
//
//
//  SessionBloc(this._userRepository);

  @override
  SessionState get initialState => InitialSessionState();

  @override
  Stream<SessionState> mapEventToState(SessionEvent event) async* {
    if(event is UpdateIntensity){
      session.intensity = event.intensity;
      conditions[0] = true;
      yield InitialSessionState();
    }
    else if(event is UpdateTitle){
      session.title = event.title;
      yield InitialSessionState();
    }
    else if(event is UpdatePerformance){
      session.performance = event.performance;
      conditions[1] = true;
      yield InitialSessionState();
    }
    else if(event is UpdateFeeling){
      conditions[2] = true;
      session.feeling = event.feeling;
      yield InitialSessionState();
    }
    else if(event is UpdateLengthOfSession){
      session.lengthOfSession = event.lengthOfSession;
      yield InitialSessionState();
    }
    else if(event is UpdateTarget){
      session.target = event.target;
      yield InitialSessionState();
    }
    else if(event is UpdateReflections){
      session.reflections = event.reflections;
      yield InitialSessionState();
    }
    else if(event is Submit){
      yield IsSubmitting();
      int numberOfFalse = 0;
      for(bool value in conditions){
        if(value == false){
          numberOfFalse++;
        }
      }
      if(numberOfFalse == 0) {
        try {
          Session _newSession = await session.uploadSession(_userRepository);
          _userRepository.diary.sessionList.add(_newSession);
          yield SuccessfullySubmitted();
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
