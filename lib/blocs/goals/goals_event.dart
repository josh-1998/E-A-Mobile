part of 'goals_bloc.dart';

@immutable
abstract class GoalsEvent extends Equatable{
  @override
  List<Object> get props => [];
}

/// called when a user moves a goal from one list to another
class ChangeGoalsList extends GoalsEvent{
  final Goal goal;
  final String newList;

  ChangeGoalsList(this.goal, this.newList);
  @override
  List<Object> get props => [goal, newList];
}

/// called when user clicks on the checkbox in the goal
class GoalCompleted extends GoalsEvent{
  final Goal goal;

  GoalCompleted(this.goal);
  @override
  List<Object> get props => [goal];
}

///called when user deletes a goal
class GoalDeleted extends GoalsEvent{}