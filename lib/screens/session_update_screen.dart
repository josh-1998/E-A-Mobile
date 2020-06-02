import 'package:eathlete/blocs/session/session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/Picker.dart';


import 'package:provider/provider.dart';

import '../models/class_definitions.dart';
import '../common_widgets/common_widgets.dart';

import '../main.dart';
import '../misc/user_repository.dart';
import 'main_page.dart';

class SessionUpdateScreen extends StatefulWidget {

  SessionUpdateScreen({Key key}) : super(key: key);

  @override
  _SessionUpdateScreenState createState() => _SessionUpdateScreenState();
}

class _SessionUpdateScreenState extends State<SessionUpdateScreen> {
  List<bool> conditions =[true, true, true];

  @override
  Widget build(BuildContext context) {
      return BlocListener<SessionBloc, SessionState>(
        listener: (BuildContext context, SessionState state){

          if(state is InformationIncomplete){
            conditions = state.conditions;
            setState(() {

            });
          }
          if(state is SuccessfullySubmitted){
              Future.delayed(Duration(milliseconds: 1)).then((value) {
                Provider.of<PageNumber>(context, listen: false).pageNumber = 1;
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainPage(
                          pageNumber:
                          Provider.of<PageNumber>(context, listen: false)
                              .pageNumber,
                        )),
                        (route) => false);
              });
            }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              TextFormField(
                decoration: InputDecoration.collapsed(hintText: 'New Session'),
                onChanged: (value){
                  BlocProvider.of<SessionBloc>(context).add(UpdateTitle(value));
                },
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 13,
              ),
              Text(
                'Intensity',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 12,
              ),
              NumberScale(
                borderColor: conditions[0]?Colors.grey:Colors.red,
                onChanged: (value) {
                  BlocProvider.of<SessionBloc>(context).add(UpdateIntensity(value));
                  conditions[0] = true;
                  setState(() {});
                },
                maxNumber: 10,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Performance in the session',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 12,
              ),
              NumberScale(
                borderColor: conditions[1]?Colors.grey:Colors.red,
                onChanged: (value) {
                  BlocProvider.of<SessionBloc>(context)
                      .add(UpdatePerformance(value));
                  conditions[1] = true;
                  setState(() {});
                },
                maxNumber: 5,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Feeling',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              FeelingPicker(
                borderColor: conditions[2]?Colors.transparent:Colors.red,
                onChanged: (value) {
                  BlocProvider.of<SessionBloc>(context).add(UpdateFeeling(value));
                  conditions[2] = true;
                  setState(() {

                  });
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric( vertical: 12),
                child: PickerEntryBox(
                  name: 'Length of Session',
                  value:
                  BlocProvider.of<SessionBloc>(context).session.lengthOfSession==null?'-':'${BlocProvider.of<SessionBloc>(context).session.lengthOfSession}',
                  onPressed: () {
                    showTimeArray(context);
                  },
                ),
              ),
              AppStyledTextField(fieldName: 'Target', onChanged: (value, context)=>BlocProvider.of<SessionBloc>(context).add(UpdateTarget(value)),),
              SizedBox(height: 12,),
              AppStyledTextField(fieldName: 'Reflections', onChanged: (value, context)=>BlocProvider.of<SessionBloc>(context).add(UpdateReflections(value)),),
              BigBlueButton(text: 'Add', onPressed: (){BlocProvider.of<SessionBloc>(context).add(Submit());},),
              SizedBox(height: 20,)

            ],
          ),
        ),
      );

  }

  showTimeArray(BuildContext context) {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    String sex = userRepository.user.sex;

    Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: [
            [for (var i = 0; i < 600; i += 5) i]
          ],
          isArray: true,
        ),
        hideHeader: true,
        selecteds: [5],
        title: Text("Please Select"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          BlocProvider.of<SessionBloc>(context).add(
              UpdateLengthOfSession(int.parse(picker.getSelectedValues()[0])));
          print(picker.getSelectedValues());
          setState(() {

          });
        }).showDialog(context);
  }
}



class FeelingPicker extends StatefulWidget {
  final Function onChanged;
  final Color borderColor;
  const FeelingPicker({Key key, this.onChanged, this.borderColor = Colors.transparent}) : super(key: key);

  @override
  _FeelingPickerState createState() => _FeelingPickerState();
}

class _FeelingPickerState extends State<FeelingPicker> {
  String feeling;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: widget.borderColor,)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    setState(() {
                      feeling = 'Frustrated';
                    });
                    widget.onChanged(feeling);
                  },
                  child: Image(
                    image: feeling == 'Frustrated'
                        ? AssetImage('images/sad3_icon.png')
                        : AssetImage('images/unsad3_icon.png'),
                    height: feeling == 'Frustrated' ? 50 : 45,
                  )),
              SizedBox(
                height: 4,
              ),
              feeling == 'Frustrated' ? Text('Pissed') : Text(''),
            ],
          ),
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    feeling = 'Bad';
                  });
                  widget.onChanged(feeling);
                },
                child: Image(
                  image: AssetImage(feeling == 'Bad'
                      ? 'images/sad2_icon.png'
                      : 'images/unsad2_icon.png'),
                  height: feeling == 'Bad' ? 50 : 45,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(feeling == 'Bad' ? 'Bad' : '')
            ],
          ),
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    feeling = 'Neutral';
                  });
                  widget.onChanged(feeling);
                },
                child: Image(
                  image: AssetImage(feeling == 'Neutral'
                      ? 'images/sad_icon.png'
                      : 'images/unsad_icon.png'),
                  height: feeling == 'Neutral' ? 50 : 45,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(feeling == 'Neutral' ? 'Neutral' : '')
            ],
          ),
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    feeling = 'Happy';
                  });
                  widget.onChanged(feeling);
                },
                child: Image(
                  image: AssetImage(feeling == 'Happy'
                      ? 'images/happy_icon.png'
                      : 'images/unhappy_icon.png'),
                  height: feeling == 'Happy' ? 50 : 45,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(feeling == 'Happy' ? 'Happy' : '')
            ],
          ),
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    feeling = 'Buzzing';
                  });
                  widget.onChanged(feeling);
                },
                child: Image(
                  image: AssetImage('images/Unveryhappy_icon.png'),
                  height: feeling == 'Buzzing' ? 50 : 45,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(feeling == 'Buzzing' ? 'Buzzing' : '')
            ],
          ),
        ],
      ),
    );
  }
}

