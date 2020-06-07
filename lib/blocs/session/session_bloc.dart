import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eathlete/models/class_definitions.dart';
import 'package:eathlete/models/diary_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


import '../../misc/user_repository.dart';

part 'session_event.dart';

part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  Session _session;
  UserRepository _userRepository;

  Last7DaysChooser _last7daysChooser = Last7DaysChooser();
  /// stores result from validation
  ///0:Intensity, 1: performance, 2: feeling
  List<bool> conditions= [false, false, false,];

  SessionBloc(this._userRepository,{Session session}):_session = session ?? Session(date: DateTime.now().toIso8601String()); //  final UserRepository _userRepository;

  @override
  SessionState get initialState => InitialSessionState(_session, _last7daysChooser);

  @override
  Stream<SessionState> mapEventToState(SessionEvent event) async* {
    if(event is UpdateIntensity){
      _session.intensity = event.intensity;
      conditions[0] = true;
      yield InitialSessionState(_session, _last7daysChooser);
    }
    else if(event is UpdateTitle){
      _session.title = event.title;
      yield InitialSessionState(_session, _last7daysChooser);
    }
    else if(event is UpdatePerformance){
      _session.performance = event.performance;
      conditions[1] = true;
      yield InitialSessionState(_session, _last7daysChooser);
    }
    else if(event is UpdateFeeling){
      conditions[2] = true;
      _session.feeling = event.feeling;
      yield InitialSessionState(_session, _last7daysChooser);
    }
    else if(event is UpdateLengthOfSession){
      _session.lengthOfSession = event.lengthOfSession;
      yield InitialSessionState(_session, _last7daysChooser);
    }
    else if(event is UpdateTarget){
      _session.target = event.target;
      yield InitialSessionState(_session, _last7daysChooser);
    }
    else if(event is UpdateReflections){
      _session.reflections = event.reflections;
      yield InitialSessionState(_session, _last7daysChooser);
    }
    else if(event is Submit){
      yield IsSubmitting(_session, _last7daysChooser);
      int numberOfFalse = 0;
      for(bool value in conditions){
        if(value == false){
          numberOfFalse++;
        }
      }
      if(numberOfFalse == 0) {
        try {
          Session _newSession = await _session.uploadSession(_userRepository);
          _userRepository.diary.sessionList.add(_newSession);
          yield SuccessfullySubmitted(_session, _last7daysChooser);
        } catch (e) {
          print(e);
          yield SubmissionFailed(_session, _last7daysChooser);
        }
      }else{
        yield InformationIncomplete(_session, _last7daysChooser, conditions);
      }
    }else if(event is ChangeDateBackwards){
      _last7daysChooser.changeDateBackward();
      _session.date = _last7daysChooser.previous7Days[_last7daysChooser.dayPointer].toIso8601String();
    }else if(event is ChangeDateForwards){
      _last7daysChooser.changeDateForward();
      _session.date = _last7daysChooser.previous7Days[_last7daysChooser.dayPointer].toIso8601String();
    }
  }
}
