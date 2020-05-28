part of 'competition_bloc.dart';

@immutable
abstract class CompetitionState extends Equatable{
  @override
  List<Object> get props => [];
}

class InitialCompetitionState extends CompetitionState {}

class IsSubmitting extends CompetitionState{}

class SubmissionSuccessful extends CompetitionState{}

class SubmissionFailed extends CompetitionState{}

class InformationIncomplete extends CompetitionState{
  final List conditions;

  InformationIncomplete(this.conditions);

  @override
  List<Object> get props => [conditions];
}