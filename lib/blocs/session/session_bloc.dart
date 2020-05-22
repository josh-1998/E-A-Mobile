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
  ///initialize
  Session session;
  UserRepository _userRepository;



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
      yield InitialSessionState();
    }
    else if(event is UpdateTitle){
      session.title = event.title;
      yield InitialSessionState();
    }
    else if(event is UpdatePerformance){
      session.performance = event.performance;
      yield InitialSessionState();
    }
    else if(event is UpdateFeeling){
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
      try {
        await session.uploadSession(_userRepository);
        yield SuccessfullySubmitted();
      }catch(e){
        print(e);
        yield SubmissionFailed();
      }

    }
  }
}
