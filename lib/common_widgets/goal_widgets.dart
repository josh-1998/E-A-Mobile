import 'package:flutter/material.dart';

class GoalCard extends StatefulWidget {
  final String goalText;
  const GoalCard({
    this.goalText,
    Key key,

  }) : super(key: key);

  @override
  _GoalCardState createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                         widget.goalText !=
                              null
                              ? widget.goalText
                              : 'No long term goal has been set',
                          style:
                          TextStyle(color: Color(0xff828289)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}