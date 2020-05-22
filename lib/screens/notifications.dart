import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  static const String id = 'notifications';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
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
      body: Container(),
    );
  }
}
