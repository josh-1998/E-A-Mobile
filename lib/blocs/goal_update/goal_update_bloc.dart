import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:eathlete/misc/validators.dart';
import 'package:eathlete/models/goals.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'goal_update_event.dart';

part 'goal_update_state.dart';

class GoalUpdateBloc extends Bloc<GoalUpdateEvent, GoalUpdateState> {
  final UserRepository userRepository;
  final String goalType;
  final Goal _goal;

  GoalUpdateBloc(this.userRepository,
      {this.goalType = 'not working', Goal goal})
      : _goal = goal ?? Goal();

  @override
  GoalUpdateState get initialState => InitialGoalUpdateState(goalType);

  @override
  Stream<GoalUpdateState> mapEventToState(GoalUpdateEvent event) async* {
    if(event is UpdateGoalDate){
      _goal.date = event.deadline.toIso8601String();
      yield(InitialGoalUpdateState(goalType));
    }
    if(event is UpdateGoalContent){
      _goal.content = event.content;
      yield(InitialGoalUpdateState(goalType));
    }
    if(event is Submit){
      _goal.setOnDate = DateTime.now().toString();
      addGoalToList();
      print(userRepository.diary.crazyGoal[0].content);
    }
  }
  /// checks all input fields against validators, returns true if all pass.
  bool runValidators(){
    bool contentValidated = stringNotEmptyValidator(_goal.content);
  }

  ///adds the goal to the right list in userRepository based on the name of the
  ///list provided when the BLoC is created
  void addGoalToList(){
    if(goalType == 'Short Term'){
      userRepository.diary.dailyGoals.add(_goal);
    }else if(goalType == 'Medium Term'){
      userRepository.diary.mediumGoals.add(_goal);
    }else if(goalType == 'Long Term'){
      userRepository.diary.crazyGoal.add(_goal);
    }
  }
}
