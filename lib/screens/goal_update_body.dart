import 'package:eathlete/blocs/goal_update/goal_update_bloc.dart';
import 'package:eathlete/common_widgets/common_widgets.dart';
import 'package:eathlete/misc/useful_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoalUpdateBody extends StatefulWidget {
  GoalUpdateBody({Key key}) : super(key: key);

  @override
  _GoalUpdateBodyState createState() => _GoalUpdateBodyState();
}

class _GoalUpdateBodyState extends State<GoalUpdateBody> {
  DateTime myDateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {

    return BlocBuilder<GoalUpdateBloc, GoalUpdateState>(
        builder: (BuildContext context, GoalUpdateState state) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('New ${ state.goalType} Goal',
            style: TextStyle(fontSize: 24),),
          ),
          SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PickerEntryBox(
              name: 'Deadline Date',
              value:
                  '${timeToString(myDateTime.day)}-${timeToString(myDateTime.month)}-${myDateTime.year}',
              onPressed: () async {
                myDateTime = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100, 12, 31),
                  builder:(BuildContext context, Widget child){
                    return Theme(
                      data: ThemeData.light().copyWith(
                          primaryColor: const Color(0xFF4A5BF6),//Head background
                          accentColor: const Color(0xFF4A5BF6)
                      ),
                      child: child,
                    );
                  }
                );
                BlocProvider.of<GoalUpdateBloc>(context).add(UpdateGoalDate(myDateTime));
                print(myDateTime);
                setState(() {});
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppStyledTextField(
              maxLines: 5,
              minLines: 5,
              keyboardType: TextInputType.multiline,
              fieldName: 'Goal Content',
              onChanged: (value, context){
                print(value);
                BlocProvider.of<GoalUpdateBloc>(context).add(UpdateGoalContent(value));
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          BigBlueButton(
            text: ('Add'),
            onPressed: (){
              BlocProvider.of<GoalUpdateBloc>(context).add(Submit());
            },
          ),
          SizedBox(
            height: 20,
          )
        ],
      );
    });
  }
}
