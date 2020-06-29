import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eathlete/common_widgets/goal_widgets.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:eathlete/models/goals.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'goals_event.dart';

part 'goals_state.dart';

class GoalsBloc extends Bloc<GoalsEvent, GoalsState> {
  final UserRepository userRepository;


  GoalsBloc({this.userRepository});

  @override
  GoalsState get initialState {

    return InitialGoalsState(
        shortTermGoals: userRepository.diary.shortTermGoals,
        mediumTermGoals: userRepository.diary.mediumTermGoals,
        longTermGoals: userRepository.diary.longTermGoal);
  }

  @override
  Stream<GoalsState> mapEventToState(GoalsEvent event) async* {
    if(event is ChangeGoalsList){
      deleteFromPreviousGoalList(event.goal);
      addToNewGoalList(event.newList, event.goal);
    }
  }

  void deleteFromPreviousGoalList(Goal eventGoal){
    bool isLong = false;
    bool isMedium = false;
    bool isShort = false;
    for(Goal goal in userRepository.diary.shortTermGoals){
      if(eventGoal.id == goal.id)isShort=true;
    }
    for(Goal goal in userRepository.diary.mediumTermGoals){
      if(eventGoal.id == goal.id)isMedium=true;
    }
    for(Goal goal in userRepository.diary.longTermGoal){
      if(eventGoal.id == goal.id)isLong=true;
    }
    if(isShort == true) userRepository.diary.shortTermGoals.removeWhere((element) => element.id == eventGoal.id);
    if(isMedium == true) userRepository.diary.mediumTermGoals.removeWhere((element) => element.id == eventGoal.id);
    if(isLong == true) userRepository.diary.longTermGoal.removeWhere((element) => element.id == eventGoal.id);

  }

  void addToNewGoalList(String newList, Goal newGoal){
    if(newList == 'Short Term'){
      newGoal.goalType = 'Short Term';
      userRepository.diary.shortTermGoals.add(newGoal);}
    if(newList == 'Medium Term'){
      newGoal.goalType = 'Medium Term';
      userRepository.diary.mediumTermGoals.add(newGoal);}
    if(newList == 'Long Term'){
      newGoal.goalType = 'Long Term';
      userRepository.diary.longTermGoal.add(newGoal);}
  }

}
