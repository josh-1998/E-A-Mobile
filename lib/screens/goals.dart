import 'package:eathlete/blocs/goal_update/goal_update_bloc.dart';
import 'package:eathlete/blocs/goals/goals_bloc.dart';
import 'package:eathlete/common_widgets/common_widgets.dart';
import 'package:eathlete/common_widgets/fancy_fab.dart';
import 'package:eathlete/common_widgets/goal_widgets.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:eathlete/models/goals.dart';
import 'package:eathlete/screens/goal_update_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'finished_goals.dart';

class Goals extends StatefulWidget {
  Goals({Key key}) : super(key: key);

  @override
  _GoalsState createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  List<Widget> mediumTermGoalsTiles = [
    GoalCard(Goal(content: 'stand up', date: '19/10/2021'), key: UniqueKey()),
  ];
  List<Widget> dailyGoalsTiles = [
    GoalCard(
      Goal(content: 'stand up', date: '19/10/2021'),
      key: UniqueKey(),
    ),
  ];
  List<Widget> crazyGoalsTiles = [
    GoalCard(
      Goal(content: 'stand up', date: '19/10/2021'),
      key: UniqueKey(),
    ),
  ];
  List<Widget> finishedGoalsTiles = [
    GoalCard(
      Goal(content: 'stand up', date: '19/10/2021'),
      key: UniqueKey(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    UserRepository _userRepository =
        Provider.of<UserRepository>(context, listen: false);
    String acceptedData = '';

    return Scaffold(
      drawer: EAthleteDrawer(),
      appBar: AppBar(
//        leading: IconButton(
//          icon: ImageIcon(
//            AssetImage('images/menu_icon@3x.png'),
//            color: Color(0xff828289),
//          ),
//          onPressed: () {
//            Scaffold.of(context).openDrawer();
//          },
//        ),
        elevation: 1,
        actions: <Widget>[NotificationButton()],
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Container(
                height: 50, child: Image.asset('images/placeholder_logo.PNG')),
            Text(
              'E-Athlete',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            )
          ],
        ),
      ),
      floatingActionButton: FancyFab(
//        backgroundColor: Colors.blue,
        topButtonOnPressed: () {
          print('Top Button Pressed');
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return BlocProvider(
                  create: (context) => GoalUpdateBloc(
                      Provider.of<UserRepository>(context, listen: false),
                      goalType: 'Long Term'),
                  child: GoalUpdateBody(),
                );
              });
        },
        middleButtonOnPressed: () {
          print('Top Button Pressed');
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return BlocProvider(
                  create: (context) => GoalUpdateBloc(
                      Provider.of<UserRepository>(context, listen: false),
                      goalType: 'Medium Term'),
                  child: GoalUpdateBody(),
                );
              });
        },
        bottomButtonOnPressed: () {
          print('Top Button Pressed');
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return BlocProvider(
                  create: (context) => GoalUpdateBloc(
                      Provider.of<UserRepository>(context, listen: false),
                      goalType: 'Short Term'),
                  child: GoalUpdateBody(),
                );
              });
        },
//        child: Icon(Icons.add, color: Colors.white,),
      ),
      body: BlocBuilder<GoalsBloc, GoalsState>(
          builder: (BuildContext context, GoalsState state) {
            dailyGoalsTiles = [for(Goal goal in state.shortTermGoals)GoalCard(goal, key: UniqueKey(),)];
            mediumTermGoalsTiles = [for(Goal goal in state.mediumTermGoals)GoalCard(goal, key: UniqueKey(),)];
            crazyGoalsTiles = [for(Goal goal in state.longTermGoals)GoalCard(goal, key: UniqueKey(),)];

        return ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Goal Setting',
                    style: TextStyle(fontSize: 20),
                  ),
                  Icon(Icons.help_outline)
                ],
              ),
            ),
            SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 10,
                      child: Container(
                        height: 100,
                        width: 250,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
//                                      color: Color(0xffecf8ea),
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      colors: [
                                        Color(0xffecf8ea),
                                        Color(0xff67db5c)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(400)),
                                child: Center(
                                  child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Color(0xffa9e1a0),
                                          borderRadius:
                                              BorderRadius.circular(400)),
                                      child: Image.asset('images/weight.png')),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Completed Goals',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Goal: ',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      Text(
                                        '8 ',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Container(
                                        width: 1,
                                        height: 10,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        'Avg: ',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      Text('6.5 ')
                                    ],
                                  ),
                                  Text(
                                    'Ends on 12/06/2020',
                                    style: TextStyle(fontSize: 9),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 16, left: 8),
                              child: Icon(Icons.radio_button_unchecked),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 10,
                      child: Container(
                        height: 100,
                        width: 250,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(400)),
                                child: Center(
                                  child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Color(0xff84b6fb),
                                          borderRadius:
                                              BorderRadius.circular(400)),
                                      child: Image.asset(
                                          'images/hours_clock.png')),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Hours Worked',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Goal: ',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      Text(
                                        '8 ',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Container(
                                        width: 1,
                                        height: 10,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        'Avg: ',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      Text('6.5 ')
                                    ],
                                  ),
                                  Text(
                                    'Ends on 12/06/2020',
                                    style: TextStyle(fontSize: 9),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 16, left: 8),
                              child: Icon(Icons.radio_button_unchecked),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            DragTarget(
              builder: (context, accepted, rejected) {
                return ExpansionTile(
                  title: Text('Crazy Goal'),
                  children: crazyGoalsTiles,
                );
              },
              onAccept: (List data) {
                deleteFromPreviousList(data[1]);
                crazyGoalsTiles.add(GoalCard(
                  data[0],
                  key: UniqueKey(),
                ));
              },
            ),
            DragTarget(
              builder: (context, accepted, rejected) {
                return ExpansionTile(
                  title: Text('Medium Goals'),
                  children: mediumTermGoalsTiles,
                );
              },
              onAccept: (List data) {
                deleteFromPreviousList(data[1]);
                mediumTermGoalsTiles.add(GoalCard(
                  data[0],
                  key: UniqueKey(),
                ));
              },
            ),
            DragTarget(
              builder: (context, accepted, rejected) {
                return ExpansionTile(
                  title: Text('Daily Goals'),
                  children: dailyGoalsTiles,
                );
              },
              onAccept: (List data) {
                deleteFromPreviousList(data[1]);
                dailyGoalsTiles.add(GoalCard(
                  data[0],
                  key: UniqueKey(),
                ));
              },
            ),
            SizedBox(
              height: 40,
            ),
            DragTarget(
              builder: (context, accepted, rejected) {
                return MaterialButton(
                  child: Text('Finished Goals'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FinishedGoals()));
                  },
                );
              },
              onAccept: (List data) {
                deleteFromPreviousList(data[1]);
                finishedGoalsTiles.add(GoalCard(
                  data[0],
                  key: UniqueKey(),
                ));
              },
            ),
          ],
        );
      }),
    );
  }

  void deleteFromPreviousList(UniqueKey key) {
    bool indaily = false;
    bool inmedium = false;
    bool incrazy = false;
    bool infinished = false;
    for (GoalCard goalCard in dailyGoalsTiles) {
      if (goalCard.key == key) {
        indaily = true;
      }
    }
    for (GoalCard goalCard in mediumTermGoalsTiles) {
      if (goalCard.key == key) {
        inmedium = true;
      }
    }
    for (GoalCard goalCard in crazyGoalsTiles) {
      if (goalCard.key == key) {
        incrazy = true;
      }
    }
    for (GoalCard goalCard in finishedGoalsTiles) {
      if (goalCard.key == key) {
        infinished = true;
      }
    }
    if (indaily == true)
      dailyGoalsTiles.removeWhere((element) => element.key == key);
    if (inmedium == true)
      mediumTermGoalsTiles.removeWhere((element) => element.key == key);
    if (incrazy == true)
      crazyGoalsTiles.removeWhere((element) => element.key == key);
    if (infinished == true)
      finishedGoalsTiles.removeWhere((element) => element.key == key);
    setState(() {});
  }
}
