import 'package:eathlete/models/goals.dart';
import 'package:flutter/material.dart';

class GoalCard extends StatefulWidget {
  final Function onPressed;
  final Goal goal;
  const GoalCard(
    this.goal, {
      this.onPressed,
    Key key,
  }) : super(key: key);

  @override
  _GoalCardState createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  bool isSuccessful = false;
  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(

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
      data: [widget.goal, widget.key],
      child: Card(
        color: Colors.white,
        elevation: 10,
        child: Container(
          height: 88,
          width: MediaQuery.of(context).size.width * 0.95,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'images/test_export.png',
                  height: 80,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            widget.goal.content != null
                                ? widget.goal.content
                                : 'No long term goal has been set',
                            style: TextStyle(color: Color(0xff828289)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: GestureDetector(
                              onTap: (){
                                isSuccessful = !isSuccessful;
                                setState(() {});

                                widget.onPressed(widget.key);
                              },
                              child: Icon(isSuccessful?Icons.check_circle:Icons.radio_button_unchecked, color: isSuccessful?Colors.green:Colors.grey,),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
