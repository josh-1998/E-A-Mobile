part of 'profile_edit_bloc.dart';

@immutable
abstract class ProfileEditEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateFirstName extends ProfileEditEvent {
  final String firstName;

  UpdateFirstName(this.firstName);

  @override
  List<Object> get props => [firstName];
}

class UpdateLastName extends ProfileEditEvent {
  final String lastName;

  UpdateLastName(this.lastName);

  @override
  List<Object> get props => [lastName];
}

class UpdateSex extends ProfileEditEvent {
  final String sex;

  UpdateSex(this.sex);

  @override
  List<Object> get props => [sex];
}

class UpdateDOB extends ProfileEditEvent {
  final String dOB;

  UpdateDOB(this.dOB);

  @override
  List<Object> get props => [dOB];
}

class UpdateWeight extends ProfileEditEvent {
  final int weight;

  UpdateWeight(this.weight);

  @override
  List<Object> get props => [weight];
}

class UpdateHeight extends ProfileEditEvent {
  final int height;

  UpdateHeight(this.height);

  @override
  List<Object> get props => [height];
}

class UpdatePhoto extends ProfileEditEvent {}

class UpdateSport extends ProfileEditEvent {
  final String sport;
  UpdateSport(this.sport);

  @override
  List<Object> get props => [sport];
}

class UpdateShortTermGoal extends ProfileEditEvent {
  final String shortTermGoal;

  UpdateShortTermGoal(this.shortTermGoal);

  @override
  List<Object> get props => [shortTermGoal];
}

class UpdateMediumTermGoal extends ProfileEditEvent {
  final String mediumTermGoal;

  UpdateMediumTermGoal(this.mediumTermGoal);

  @override
  List<Object> get props => [mediumTermGoal];
}

class UpdateLongTermGoal extends ProfileEditEvent {
  final String longTermGoal;

  UpdateLongTermGoal(this.longTermGoal);

  @override
  List<Object> get props => [longTermGoal];
}

class UpdateProfilePhotoToSend extends ProfileEditEvent{
  final String profilePhotoToSend;

  UpdateProfilePhotoToSend(this.profilePhotoToSend);

  @override
  // TODO: implement props
  List<Object> get props => [profilePhotoToSend];
}
class UpdateTempImage extends ProfileEditEvent{
  final ImageProvider tempImage;

  UpdateTempImage(this.tempImage);

  @override
  // TODO: implement props
  List<Object> get props => [tempImage];
}

class SubmitForm extends ProfileEditEvent {}
