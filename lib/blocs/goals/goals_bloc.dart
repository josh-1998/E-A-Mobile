import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:eathlete/models/goals.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'goals_event.dart';

part 'goals_state.dart';

class GoalsBloc extends Bloc<GoalsEvent, GoalsState> {
  final UserRepository userRepository;
  List<Goal> shortTermGoals;
  List<Goal> mediumTermGoals;
  List<Goal> longTermGoals;

  GoalsBloc({this.userRepository});

  @override
  GoalsState get initialState {
    shortTermGoals = userRepository.diary.dailyGoals;
    mediumTermGoals = userRepository.diary.mediumGoals;
    longTermGoals = userRepository.diary.crazyGoal;
    return InitialGoalsState(
        shortTermGoals: shortTermGoals,
        mediumTermGoals: mediumTermGoals,
        longTermGoals: longTermGoals);
  }

  @override
  Stream<GoalsState> mapEventToState(GoalsEvent event) async* {}
}
