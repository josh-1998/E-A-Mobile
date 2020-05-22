import 'dart:convert';

import 'package:eathlete/blocs/profile_edit/profile_edit_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/flutter_picker.dart';

import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../common_widgets.dart';
import '../useful_functions.dart';
import '../user_repository.dart';


class ProfileEditPage extends StatefulWidget {
  static const String id = 'profile edit page';
  ProfileEditPage({Key key}) : super(key: key);

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {




  @override
  Widget build(BuildContext context) {
    /// returning an extracted widget to allow the BlocProvider to add a bloc that all methods have access to.
    return BlocProvider<ProfileEditBloc>(
      create: (context) =>
          ProfileEditBloc(Provider.of<UserRepository>(context, listen: false)),
      child: ProfileUpdateBody(),
    );
  }
}

class ProfileUpdateBody extends StatefulWidget {
  const ProfileUpdateBody({
    Key key,
  }) : super(key: key);

  @override
  _ProfileUpdateBodyState createState() => _ProfileUpdateBodyState();
}

class _ProfileUpdateBodyState extends State<ProfileUpdateBody> {
  @override
  Widget build(BuildContext context) {
    ProfileEditBloc profileEditBloc = BlocProvider.of<ProfileEditBloc>(context);
    return BlocBuilder(
        bloc: profileEditBloc,
        builder: (context, ProfileEditState state) {
          if(state is SubmittedSuccessfully){
            Future.delayed(Duration(milliseconds: 1)).then((value) =>  Navigator.pop(context));

          }
          return Scaffold(
            appBar: AppBar(
              elevation: 1,
              actions: <Widget>[NotificationButton()],
              backgroundColor: Colors.white,
              title: Row(
//          mainAxisAlignment: MainAxisAlignment.center,
//          crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: 50,
                      child: Image.asset('images/placeholder_logo.PNG')),
                  Text(
                    'E-Athlete',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  )
                ],
              ),
            ),
            body: ListView(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(top: 30.0, left: 30, right: 30),
                  child: Row(
                    children: <Widget>[
                      ProfilePhoto(
                        size: 90,
                        photo: profileEditBloc.updatedUser.tempImage != null
                            ? profileEditBloc.updatedUser.tempImage
                            : NetworkImage(profileEditBloc.updatedUser.profilePhoto),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(child: Container()),
                      MaterialButton(
                        color: Color(0xfff2f2f3),
                        padding: EdgeInsets.all(8),
                        elevation: 0,
                        onPressed: () {
                          showMaterialModalBottomSheet(context: context, builder: (builder, scrollController){
                            return ImagePickerMenu(onPressedPhoto: (image, file){
                              ProfileEditBloc profileEditBloc =
                              BlocProvider.of<ProfileEditBloc>(context);
                              profileEditBloc.add(UpdateProfilePhotoToSend(file));
                              Navigator.pop(context);
                              setState(() {

                              });
                            },
                            onPressedGallery: (image, file){
                              ProfileEditBloc profileEditBloc =
                              BlocProvider.of<ProfileEditBloc>(context);
                              profileEditBloc.add(UpdateProfilePhotoToSend(file));
                              Navigator.pop(context);
                              setState(() {

                              });

                            },);
                          });
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(200)),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.edit,
                              color: Color(0xff828289),
                            ),
                            Text('Edit Photo'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Divider(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: AppStyledTextField(
                    onChanged: (value, context) {
                      ProfileEditBloc profileEditBloc =
                          BlocProvider.of<ProfileEditBloc>(context);
                      profileEditBloc.add(UpdateFirstName(value));
                    },
                    fieldName: 'First Name',
                    initialValue: profileEditBloc.updatedUser.firstName != null
                        ? profileEditBloc.updatedUser.firstName
                        : null,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: AppStyledTextField(
                    onChanged: (value, context) {
                      ProfileEditBloc profileEditBloc =
                          BlocProvider.of<ProfileEditBloc>(context);
                      profileEditBloc.add(UpdateLastName(value));
                    },
                    fieldName: 'Last Name',
                    initialValue: profileEditBloc.updatedUser.lastName != null
                        ? profileEditBloc.updatedUser.lastName
                        : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: PickerEntryBox(
                    name: 'Age',
                    value:
                        '${profileEditBloc.updatedUser.dOB != null ? profileEditBloc.updatedUser.age : '-'} years old',
                    onPressed: () {
                      showPickerDate(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: PickerEntryBox(
                    name: 'Height',
                    value:
                        '${profileEditBloc.updatedUser.height != null ? profileEditBloc.updatedUser.height : '-'} cm',
                    onPressed: () {
                      showHeightArray(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: PickerEntryBox(
                    name: 'Weight',
                    value:
                        '${profileEditBloc.updatedUser.weight != null ? profileEditBloc.updatedUser.weight : '-'} kg',
                    onPressed: () {
                      showWeightArray(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: PickerEntryBox(
                    name: 'Sex',
                    value:
                        '${profileEditBloc.updatedUser.sex != null ? profileEditBloc.updatedUser.sex : '-'}',
                    onPressed: () {
                      showSexArray(context);
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: AppStyledTextField(
                    onChanged: (value, context) {
                      ProfileEditBloc profileEditBloc =
                          BlocProvider.of<ProfileEditBloc>(context);
                      profileEditBloc.add(UpdateSport(value));
                    },
                    fieldName: 'Sport',
                    initialValue: profileEditBloc.updatedUser.sport != null
                        ? profileEditBloc.updatedUser.sport
                        : null,
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: AppStyledTextField(
                    onChanged: (value, context) {
                      ProfileEditBloc profileEditBloc =
                      BlocProvider.of<ProfileEditBloc>(context);
                      profileEditBloc.add(UpdateShortTermGoal(value));
                    },
                    fieldName: 'shortTermGoal',
                    initialValue: profileEditBloc.updatedUser.shortTermGoal != null
                        ? profileEditBloc.updatedUser.shortTermGoal
                        : null,
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: AppStyledTextField(
                    onChanged: (value, context) {
                      ProfileEditBloc profileEditBloc =
                      BlocProvider.of<ProfileEditBloc>(context);
                      profileEditBloc.add(UpdateMediumTermGoal(value));
                    },
                    fieldName: 'mediumTermGoal',
                    initialValue: profileEditBloc.updatedUser.mediumTermGoal != null
                        ? profileEditBloc.updatedUser.mediumTermGoal
                        : null,
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: AppStyledTextField(
                    onChanged: (value, context) {
                      ProfileEditBloc profileEditBloc =
                      BlocProvider.of<ProfileEditBloc>(context);
                      profileEditBloc.add(UpdateLongTermGoal(value));
                    },
                    fieldName: 'longTermGoal',
                    initialValue: profileEditBloc.updatedUser.longTermGoal != null
                        ? profileEditBloc.updatedUser.longTermGoal
                        : null,
                  ),
                ),
                BigBlueButton(onPressed: (){
                                          ProfileEditBloc profileEditBloc =
                        BlocProvider.of<ProfileEditBloc>(context);
                        profileEditBloc.add(SubmitForm());
                        print('user pressed save changes');
                },
                text: 'Update',),
              ],
            ),
          );
        });
  }

  ///functions for the different pickers

  showPickerDate(BuildContext context) {
    Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(),
        title: Text("Date of Birth"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          String date = '${timeToString((picker.adapter as DateTimePickerAdapter).value.year)}-${timeToString((picker.adapter as DateTimePickerAdapter).value.month)}-${timeToString((picker.adapter as DateTimePickerAdapter).value.day)}';
//          (picker.adapter as DateTimePickerAdapter).value.year;
          // add 0 infront of single numbers
          print(date);
          UserRepository userRepository = Provider.of<UserRepository>(context, listen: false);
          print(userRepository.user.dOB);
          print(DateTime.parse(date));

          ProfileEditBloc profileEditBloc =
          BlocProvider.of<ProfileEditBloc>(context);
          profileEditBloc
              .add(UpdateDOB(date));
          setState(() {

          });
        }).showDialog(context);
  }

  showWeightArray(BuildContext context) {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: [
            [for (var i = 0; i < 360; i += 1) i],
            ['kg', 'lbs']
          ],
          isArray: true,
        ),
        hideHeader: true,
        selecteds: [
          userRepository.user.weight != null ? userRepository.user.weight : 70,
          0,
        ],
        title: Text("Please Select"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          ProfileEditBloc profileEditBloc =
              BlocProvider.of<ProfileEditBloc>(context);
          profileEditBloc
              .add(UpdateWeight(int.parse(picker.getSelectedValues()[0])));

          print(picker.getSelectedValues());
          setState(() {

          });
        }).showDialog(context);
  }

  showHeightArray(BuildContext context) {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: [
            [for (var i = 0; i < 360; i += 1) i],
            ['cm', 'ft']
          ],
          isArray: true,
        ),
        hideHeader: true,
        selecteds: [
          userRepository.user.height != null ? userRepository.user.height : 160,
          0,
        ],
        title: Text("Please Select"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          ProfileEditBloc profileEditBloc =
              BlocProvider.of<ProfileEditBloc>(context);
          profileEditBloc
              .add(UpdateHeight(int.parse(picker.getSelectedValues()[0])));
          print(picker.getSelectedValues()[0].runtimeType);
          print(picker.getSelectedValues());
          setState(() {

          });
        }).showDialog(context);
  }

  showSexArray(BuildContext context) {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    String sex = userRepository.user.sex;
    int selecteds = sex == 'Female' ? 1 : 0;
    Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: [
            ['Male', 'Female']
          ],
          isArray: true,
        ),
        hideHeader: true,
        selecteds: [selecteds],
        title: Text("Please Select"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          ProfileEditBloc profileEditBloc =
              BlocProvider.of<ProfileEditBloc>(context);
          profileEditBloc.add(UpdateSex(picker.getSelectedValues()[0]));
          print(picker.getSelectedValues());
          setState(() {
            
          });
        }).showDialog(context);
  }
}



class ImagePickerMenu extends StatelessWidget {

  final Function onPressedPhoto;
  final Function onPressedGallery;

  ImagePickerMenu({this.onPressedGallery, this.onPressedPhoto});

  Future getImageFromCamera () async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {

        var _image = image;

        List<int> fileContent = image.readAsBytesSync();
        String fileContentBase64 = base64.encode(fileContent);
        onPressedPhoto(_image, fileContentBase64);

    }
  }
  Future getImageFromGallery () async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {

      var _image = image;

      List<int> fileContent = image.readAsBytesSync();
      String fileContentBase64 = base64.encode(fileContent);
      onPressedGallery(_image, fileContentBase64);

    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: ()=> getImageFromCamera(),
              child: Container(
                child: Center(
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: ()=> getImageFromGallery(),
              child: Container(
                child: Center(
                  child: Icon(
                      Icons.photo_library,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}

