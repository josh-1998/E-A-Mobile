part of 'general_day_bloc.dart';

@immutable
abstract class GeneralDayState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class InitialGeneralDayState extends GeneralDayState {}

class IsSubmitting extends GeneralDayState{}

class SubmissionSuccessful extends GeneralDayState{}

class SubmissionFailed extends GeneralDayState{}