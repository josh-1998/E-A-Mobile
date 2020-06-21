import 'package:eathlete/common_widgets/common_widgets.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:eathlete/models/goals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class Goals extends StatefulWidget {
  Goals({Key key}) : super(key: key);

  @override
  _GoalsState createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {

  @override
  Widget build(BuildContext context) {
    UserRepository _userRepository = Provider.of<UserRepository>(context, listen: false);
    var successfullDrop;
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
                height: 50,
                child: Image.asset('images/placeholder_logo.PNG')),
            Text(
              'E-Athlete',
              style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            )
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Goal Setting', style: TextStyle(
                  fontSize: 20
                ),),
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
                                    colors: [Color(0xffecf8ea), Color(0xff67db5c)],

                                  ),
                                  borderRadius: BorderRadius.circular(400)
                              ),
                              child: Center(
                                child: Container(
                                    height: 50,
                                    width:  50,
                                    decoration: BoxDecoration(
                                        color: Color(0xffa9e1a0),
                                        borderRadius: BorderRadius.circular(400)
                                    ),
                                    child: Image.asset('images/weight.png')),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Completed Goals', style: TextStyle(
                                    fontSize: 18
                                ),),
                                SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Goal: ', style: TextStyle(fontSize: 10),),
                                    Text('8 ', style: TextStyle(fontSize: 14),),
                                    Container(
                                      width: 1,
                                      height: 10,
                                      color: Colors.grey,
                                    ),
                                    Text('Avg: ', style: TextStyle(fontSize: 10),),
                                    Text('6.5 ')
                                  ],
                                ),
                                Text('Ends on 12/06/2020', style: TextStyle(fontSize: 9),)
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right:16, left: 8),
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
                                  borderRadius: BorderRadius.circular(400)
                              ),
                              child: Center(
                                child: Container(
                                    height: 50,
                                    width:  50,
                                    decoration: BoxDecoration(
                                        color: Color(0xff84b6fb),
                                        borderRadius: BorderRadius.circular(400)
                                    ),
                                    child: Image.asset('images/hours_clock.png')),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Hours Worked', style: TextStyle(
                                    fontSize: 18
                                ),),
                                SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Goal: ', style: TextStyle(fontSize: 10),),
                                    Text('8 ', style: TextStyle(fontSize: 14),),
                                    Container(
                                      width: 1,
                                      height: 10,
                                      color: Colors.grey,
                                    ),
                                    Text('Avg: ', style: TextStyle(fontSize: 10),),
                                    Text('6.5 ')
                                  ],
                                ),
                                Text('Ends on 12/06/2020', style: TextStyle(fontSize: 9),)
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right:16, left: 8),
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
          ExpansionTile(
            title: Text('Crazy Goal'),
            children: <Widget>[
              GoalTile(Goal(content: 'win the olympics', date: '19/10/2021')),
            ],

          ),
          ExpansionTile(

            title: Text('Medium Goals'),
            children: <Widget>[
              GoalTile(Goal(content: 'eat more chocolate', date: '18/10/2021')),
              GoalTile(Goal(content: 'fight Tyson Fury', date: '15/10/2021')),
              GoalTile(Goal(content: 'Get swole', date: '12/10/2021')),
            ],
          ),

          ExpansionTile(
            title: Text('Daily Goals'),
            children: <Widget>[
              GoalTile(Goal(content: 'stand up', date: '19/10/2021')),
              GoalTile(Goal(content: 'breathe', date: '19/10/2021')),
              GoalTile(Goal(content: 'think', date: '19/10/2021')),
            ],
          ),
          ExpansionTile(
            title: Text('Finished Goals'),
          )
        ],
      ),
    );
  }
}



class GoalTile extends StatefulWidget {
  final Goal goal;


  GoalTile(this.goal);

  @override
  _GoalTileState createState() => _GoalTileState();
}

class _GoalTileState extends State<GoalTile> {
  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      childWhenDragging: Container(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(widget.goal.content),
              Text(widget.goal.date)
            ],
          ),
        ),
      ),
      feedback: Container(
        height: 70,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(widget.goal.content,
              style: TextStyle(
                color: Colors.black,
                fontSize: 13
              ),),
              Text(widget.goal.date)
            ],
          ),
        ),
      ),
      child: Container(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(widget.goal.content),
              Text(widget.goal.date)
            ],
          ),
        ),
      ),
    );
  }
}
