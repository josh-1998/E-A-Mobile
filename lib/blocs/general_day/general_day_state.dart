part of 'general_day_bloc.dart';

@immutable
abstract class GeneralDayState extends Equatable{
  GeneralDay generalDay;
  @override

  List<Object> get props => [];
}

class InitialGeneralDayState extends GeneralDayState {
  final GeneralDay generalDay;

  InitialGeneralDayState(this.generalDay);

  @override
  List<Object> get props => [generalDay];
}

class IsSubmitting extends GeneralDayState{
  final GeneralDay generalDay;

  IsSubmitting(this.generalDay);
  @override
  List<Object> get props => [generalDay];
}

class SubmissionSuccessful extends GeneralDayState{
  final GeneralDay generalDay;

  SubmissionSuccessful(this.generalDay);

  @override
  List<Object> get props => [generalDay];
}

class SubmissionFailed extends GeneralDayState{
  final GeneralDay generalDay;

  SubmissionFailed(this.generalDay);

  @override
  List<Object> get props => [generalDay];
}