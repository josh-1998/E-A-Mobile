part of 'goals_bloc.dart';

@immutable
abstract class GoalsState  extends Equatable{
  List<Goal> shortTermGoals;
  List<Goal> mediumTermGoals;
  List<Goal> longTermGoals;
  @override
  List<Object> get props => [];
}

class InitialGoalsState extends GoalsState {
  final List<Goal> shortTermGoals;
  final List<Goal> mediumTermGoals;
  final List<Goal> longTermGoals;

  InitialGoalsState({this.shortTermGoals, this.mediumTermGoals, this.longTermGoals});


  @override
  List<Object> get props => [shortTermGoals, mediumTermGoals, longTermGoals];
}