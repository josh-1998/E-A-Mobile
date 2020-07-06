import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eathlete/misc/useful_functions.dart';
import 'package:eathlete/models/diary_model.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import '../../misc/database.dart';
import '../../misc/user_repository.dart';
import 'package:connectivity/connectivity.dart';
part 'authentification_event.dart';
part 'authentification_state.dart';


class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  AuthenticationState get initialState => Loading();


  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  /// called when app is started
  /// if user logged in then check for internet connection, if exists check JWT,
  /// if no internet then log in but don't do all api calls
  Stream<AuthenticationState> _mapAppStartedToState() async* {
    final isSignedIn = await _userRepository.isSignedIn();
    if (isSignedIn) {
      print(DBHelper.getSessions());
      for(Session item in await DBHelper.getSessions()){
        print(item.id);
        if(item.id[0] == "e" || item.id[0] == "x"){
          _userRepository.diaryItemsToSend.add(item);
        }
        if(item.id[0] == "d"){
          _userRepository.diaryItemsToDelete.add(item);
        }
      }

      if(await hasInternetConnection()){

      try {
        await _userRepository.getUser();


        ///update user profile from server if internet connection exists
        await DBHelper.getUser(_userRepository.user);

        try {
          await _userRepository.user
              .getUserInfo(await _userRepository.refreshIdToken());
          _userRepository.diary.sessionList = await DBHelper.getSessions();
          _userRepository.diary.generalDayList = await DBHelper.getGeneralDay();
          _userRepository.diary.competitionList =
              await DBHelper.getCompetitions();
          _userRepository.diary.resultList = await DBHelper.getResults();
          yield Authenticated();
        }
        catch (e) {
          _userRepository.signOut();
          yield Unauthenticated();
        }
      } catch (e) {
        _userRepository.signOut();
        yield Unauthenticated();
        print(e);
      }
      processDiaryItems(_userRepository);
      }
      ///login without checking user info and just loading sessions from internal
      ///DB
      else {
        await DBHelper.getUser(_userRepository.user);
        _userRepository.diary.sessionList = await DBHelper.getSessions();
        _userRepository.diary.generalDayList = await DBHelper.getGeneralDay();
        _userRepository.diary.competitionList =
        await DBHelper.getCompetitions();
        _userRepository.diary.resultList = await DBHelper.getResults();
        yield Authenticated();
      }
    }
    ///if user is not signed in then yield unauthenticated
    else {
      yield Unauthenticated();
    }
  }

  /// When user signs in
  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Authenticated();
  }
  /// When user signs out
  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    await _userRepository.signOut();
    yield Unauthenticated();
  }
}
