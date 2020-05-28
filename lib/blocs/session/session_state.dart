part of 'session_bloc.dart';

@immutable
abstract class SessionState extends Equatable{
  @override
  List<Object> get props => [];
}

class InitialSessionState extends SessionState {}

class IsSubmitting extends SessionState{}

class SuccessfullySubmitted extends SessionState{}

class SubmissionFailed extends SessionState{}

class InformationIncomplete extends SessionState{
  final List<bool> conditions;

  InformationIncomplete(this.conditions);

  @override
  List<Object> get props => [conditions];
}