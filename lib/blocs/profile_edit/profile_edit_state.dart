part of 'profile_edit_bloc.dart';

@immutable
abstract class ProfileEditState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class InitialProfileEditState extends ProfileEditState {}

class IsSubmitting extends ProfileEditState {}

class SubmittedSuccessfully extends ProfileEditState {}

class SubmittedUnsuccessfully extends ProfileEditState {}