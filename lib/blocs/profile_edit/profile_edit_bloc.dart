import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eathlete/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:meta/meta.dart';

import '../../database.dart';
import '../../user_repository.dart';

part 'profile_edit_event.dart';

part 'profile_edit_state.dart';

class ProfileEditBloc extends Bloc<ProfileEditEvent, ProfileEditState> {
  User updatedUser;
  UserRepository _userRepository;

  /// constructor copies over info from main user class to temporary user class to be used while updating user
  ProfileEditBloc(this._userRepository)
      : updatedUser = User()
          ..firstName = _userRepository.user.firstName
          ..lastName = _userRepository.user.lastName
          ..sex = _userRepository.user.sex
          ..dOB = _userRepository.user.dOB
          ..profilePhotos = _userRepository.user.profilePhoto
          ..height = _userRepository.user.height
          ..weight = _userRepository.user.weight
          ..sport = _userRepository.user.sport
          ..shortTermGoal = _userRepository.user.shortTermGoal
          ..mediumTermGoal = _userRepository.user.mediumTermGoal
          ..longTermGoal = _userRepository.user.longTermGoal
          ..jwt = _userRepository.user.jwt;

  @override
  ProfileEditState get initialState => InitialProfileEditState();

  @override
  Stream<ProfileEditState> mapEventToState(ProfileEditEvent event) async* {
    if (event is UpdateFirstName) {
      updatedUser.firstName = event.firstName;
      print(updatedUser.firstName);
      yield InitialProfileEditState();
    } else if (event is UpdateLastName) {
      updatedUser.lastName = event.lastName;
      yield InitialProfileEditState();
    } else if (event is UpdateSex) {
      updatedUser.sex = event.sex;
      print(updatedUser.sex);
      yield InitialProfileEditState();
    } else if (event is UpdateWeight) {
      updatedUser.weight = event.weight;
      yield InitialProfileEditState();
    } else if (event is UpdateHeight) {
      updatedUser.height = event.height;
      print(updatedUser.height);
      yield InitialProfileEditState();
    } else if (event is UpdateSport) {
      updatedUser.sport = event.sport;
      yield InitialProfileEditState();
    } else if (event is UpdateShortTermGoal) {
      updatedUser.shortTermGoal = event.shortTermGoal;
      yield InitialProfileEditState();
    } else if (event is UpdateMediumTermGoal) {
      updatedUser.mediumTermGoal = event.mediumTermGoal;
      yield InitialProfileEditState();
    } else if (event is UpdateLongTermGoal) {
      updatedUser.longTermGoal = event.longTermGoal;
      yield InitialProfileEditState();
    } else if (event is UpdateDOB) {
      updatedUser.dOB = event.dOB;
      yield InitialProfileEditState();
    }
    else if(event is UpdateTempImage){
      updatedUser.tempImage = event.tempImage;
    }
    else if (event is UpdateProfilePhotoToSend){
      updatedUser.profilePhotoToSend = event.profilePhotoToSend;
      yield InitialProfileEditState();
    }
    else if (event is SubmitForm) {
      yield IsSubmitting();
      try {
        await updatedUser.updateUserInfo();
        await _userRepository.user.getUserInfo();
        DBHelper.updateUser(_userRepository.user);
        yield SubmittedSuccessfully();
      } catch (e) {
        print(e);
        yield SubmittedUnsuccessfully();
      }
    }
  }
}
