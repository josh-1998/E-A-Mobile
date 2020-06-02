import 'package:eathlete/blocs/general_day/general_day_bloc.dart';
import 'package:eathlete/models/diary_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:provider/provider.dart';


import '../class_definitions.dart';
import '../common_widgets.dart';
import '../main.dart';
import 'main_page.dart';





class GeneralDayUpdateBody extends StatefulWidget {
  //TODO: move existing general day into generalDay bloc, then add update method if day already exists.
  final GeneralDay generalDay;
  const GeneralDayUpdateBody({
    this.generalDay,
    Key key,
  }) : super(key: key);

  @override
  _GeneralDayUpdateBodyState createState() => _GeneralDayUpdateBodyState();
}

class _GeneralDayUpdateBodyState extends State<GeneralDayUpdateBody> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<GeneralDayBloc, GeneralDayState>(
      listener: (BuildContext context, GeneralDayState state){
        if(state is SubmissionSuccessful){
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
      child: BlocBuilder(
        bloc: BlocProvider.of<GeneralDayBloc>(context),
        builder: (BuildContext context, state){
          return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'General Day',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 13,
                ),
                Text(
                  'I feel well rested',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 12,
                ),
                NumberScale(
                  initialValue: widget.generalDay.rested,
                  onChanged: (value)=> BlocProvider.of<GeneralDayBloc>(context).add(UpdateRested(value)),
                  maxNumber: 5,
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'I have eaten well today',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 12,
                ),
                NumberScale(
                  initialValue: widget.generalDay.nutrition,
                  onChanged: (value)=> BlocProvider.of<GeneralDayBloc>(context).add(UpdateNutrition(value)),
                  maxNumber: 10,
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'I was able to maintain concentration in my tasks today',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 12,
                ),
                NumberScale(
                  initialValue: widget.generalDay.concentration,
                  onChanged: (value)=> BlocProvider.of<GeneralDayBloc>(context).add(UpdateConcentration(value)),
                  maxNumber: 10,
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: AppStyledTextField(
                    initialValue: widget.generalDay.reflections==''?null:widget.generalDay.reflections,
                    minLines: 5,
                    maxLines: 5,
                    onChanged: (value, context) => BlocProvider.of<GeneralDayBloc>(context).add(UpdateReflections(value)),
                    fieldName: 'Reflections on today',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                BigBlueButton(text: 'Add',
                onPressed: (){BlocProvider.of<GeneralDayBloc>(context).add(Submit());
//                Navigator.pop(context);
                },),
                SizedBox(height: 20,)
              ],
            ),
          ),
        );}
      ),
    );
  }
}
