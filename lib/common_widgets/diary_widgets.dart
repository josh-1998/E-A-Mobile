import 'package:eathlete/blocs/competition/competition_bloc.dart';
import 'package:eathlete/models/diary_model.dart';
import 'package:eathlete/screens/competition_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../misc/user_repository.dart';

class GeneralDayEntry extends StatelessWidget {
  final GeneralDay generalDay;
  const GeneralDayEntry({
    this.generalDay,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: InkWell(
        onTap: () {
          showMaterialModalBottomSheet(
              expand: true,
              bounce: true,
              context: context,
              builder: (builder, scrollController) {
                return BlocProvider(
                    create: (context) => CompetitionBloc(
                        Provider.of<UserRepository>(context,
                            listen: false)),
                    child: SafeArea(
                        child: SingleChildScrollView(
                            child: CompetitionEntry())));
              });

        },
        onLongPress: (){
          print('longPressed');},
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(spreadRadius: 0.5, blurRadius: 1, color: Colors.grey)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          height: 16,
                          width: 16,
                          child: Center(
                              child: Icon(
                                Icons.calendar_today,
                                size: 13,
                              )),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 0.5,
                                    blurRadius: 1,
                                    color: Colors.grey)
                              ],
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'General Day',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                      ],
                    ),
                    Text(
                      generalDay.date == null ? '-' : generalDay.date,
                      style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'I feel well rested',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      Text(generalDay.rested == null
                          ? '-'
                          : '${generalDay.rested}'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'I have eaten well today',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      Text(generalDay.nutrition == null
                          ? '-'
                          : '${generalDay.nutrition}'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Concentration throughout day',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      Text(generalDay.concentration == null
                          ? '-'
                          : '${generalDay.concentration}'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Reflections',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(generalDay.reflections == null
                          ? '-'
                          : generalDay.reflections)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CompetitionDiaryEntry extends StatelessWidget {
  final Competition _competition;

  CompetitionDiaryEntry(this._competition);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: InkWell(
        onTap: (){print('tapped');},
        onLongPress: (){print('longPressed');},
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(spreadRadius: 0.5, blurRadius: 1, color: Colors.grey)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          height: 16,
                          width: 16,
                          child: Center(
                              child: Icon(
                                Icons.calendar_today,
                                size: 13,
                              )),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 0.5,
                                    blurRadius: 1,
                                    color: Colors.grey)
                              ],
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          _competition.name == null ? '-' : _competition.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                      ],
                    ),
                    Text(
                      _competition.date == null ? '-' : _competition.date,
                      style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Start Time',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      Text(_competition.startTime == null
                          ? '-'
                          : '${_competition.startTime.substring(0,5)}'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Address',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(_competition.address == null
                          ? '-'
                          : _competition.address)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SessionEntry extends StatelessWidget {
  final Session session;
  const SessionEntry({
    @required this.session,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: InkWell(
        onTap: () {
          showMaterialModalBottomSheet(
              expand: true,
              bounce: true,
              context: context,
              builder: (builder, scrollController) {
                return BlocProvider(
                    create: (context) => CompetitionBloc(
                        Provider.of<UserRepository>(context,
                            listen: false)),
                    child: SafeArea(
                        child: SingleChildScrollView(
                            child: CompetitionEntry())));
              });

        },
        onLongPress: (){
          print('longPressed');
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(spreadRadius: 0.5, blurRadius: 1, color: Colors.grey)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          height: 16,
                          width: 16,
                          child: Center(
                              child: Icon(
                                Icons.hourglass_empty,
                                size: 13,
                              )),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 0.5,
                                    blurRadius: 1,
                                    color: Colors.grey)
                              ],
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          session.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                      ],
                    ),
                    Text(
                      session.date,
                      style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Intensity of Session',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      Text('${session.intensity}'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Performance in session',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      Text('${session.performance}'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Length of session',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      Text(session.lengthOfSession == null ? '-' : '${session.lengthOfSession}'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Feeling Scale',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      Text(session.feeling),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Targets for the session',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(session.target == null ? '-' : session.target)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Reflections on the session',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(session.reflections == null ? '-' : session.reflections)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}