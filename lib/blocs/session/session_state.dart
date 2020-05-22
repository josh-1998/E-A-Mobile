part of 'session_bloc.dart';

@immutable
abstract class SessionState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class InitialSessionState extends SessionState {}

class IsSubmitting extends SessionState{}

class SuccessfullySubmitted extends SessionState{}

class SubmissionFailed extends SessionState{}