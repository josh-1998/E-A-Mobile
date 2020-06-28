part of 'goals_bloc.dart';

@immutable
abstract class GoalsEvent extends Equatable{
  @override
  List<Object> get props => [];
}

/// called when a user moves a goal from one list to another
class ChangeGoalsList extends GoalsEvent{}

/// called when user clicks on the checkbox in the goal
class GoalCompleted extends GoalsEvent{}

///called when user deletes a goal
class GoalDeleted extends GoalsEvent{}