import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import '../../misc/database.dart';
import '../../misc/user_repository.dart';
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

  // TODO: make a loading screen that will show on Uninitialized

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

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    final isSignedIn = await _userRepository.isSignedIn();
    if (isSignedIn) {
      /// uses refreshidtoken to get new data
      /// If it doesn't work log the user out
      try {
        await _userRepository.getUser();

        // TODO: remove user table, make a call to the server each time.
        await DBHelper.getUser(_userRepository.user);
        //try getting user info with jwt token
        try {
          await _userRepository.user
              .getUserInfo(await _userRepository.refreshIdToken());
          _userRepository.diary.sessionList = await DBHelper.getSessions();
          _userRepository.diary.generalDayList = await DBHelper.getGeneralDay();
          _userRepository.diary.competitionList =
              await DBHelper.getCompetitions();
          yield Authenticated();
        }
        //if that doesnt work, send back to firebase asking for another token
        //if that doesnt work, sign the user out and ask them to authenticate again
        catch (e) {
          _userRepository.signOut();
          yield Unauthenticated();
        }
      } catch (e) {
        _userRepository.signOut();
        yield Unauthenticated();
        print(e);
      }
    } else {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Authenticated();
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    await _userRepository.signOut();
    yield Unauthenticated();
  }
}
