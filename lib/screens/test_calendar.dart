import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';


import '../class_definitions.dart';



class TestCalendar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TableCalendar(
        calendarController: Provider.of<PageNumber>(context).calendarController,
        calendarActionButton: CalendarActionButton(
          onPressed: (){},
          child: Text('Hey')
        ),
      )
    );
  }
}
