part of 'session_bloc.dart';

@immutable
abstract class SessionEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class UpdateTitle extends SessionEvent {
  final String title;

  UpdateTitle(this.title);

  @override
  // TODO: implement props
  List<Object> get props => [title];
}

class UpdateIntensity extends SessionEvent {
  final int intensity;

  UpdateIntensity(this.intensity);

  @override
  // TODO: implement props
  List<Object> get props => [intensity];
}

class UpdatePerformance extends SessionEvent {
  final int performance;

  UpdatePerformance(this.performance);

  @override
  // TODO: implement props
  List<Object> get props => [performance];
}

class UpdateLengthOfSession extends SessionEvent {
  int lengthOfSession;

  UpdateLengthOfSession(this.lengthOfSession);

  @override
  // TODO: implement props
  List<Object> get props => [lengthOfSession];
}

class UpdateFeeling extends SessionEvent {
  final String feeling;

  UpdateFeeling(this.feeling);

  @override
  // TODO: implement props
  List<Object> get props => [feeling];
}

class UpdateTarget extends SessionEvent {
  final String target;

  UpdateTarget(this.target);

  @override
  // TODO: implement props
  List<Object> get props => [target];
}

class UpdateReflections extends SessionEvent {
  final String reflections;

  UpdateReflections(this.reflections);

  @override
  // TODO: implement props
  List<Object> get props => [reflections];
}

class Submit extends SessionEvent {}
