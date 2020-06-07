import 'package:eathlete/misc/useful_functions.dart';
import 'package:table_calendar/table_calendar.dart';

class GraphObject {
  final DateTime xAxis;
  final int yAxis;

  GraphObject(this.xAxis, this.yAxis);
}

class PageNumber{

  int pageNumber = 0;
  CalendarController calendarController = CalendarController();


}

class Last7DaysChooser{
  final List<DateTime> previous7Days= [for(var i=0;i<7; i++)DateTime(currentDay.year, currentDay.month, currentDay.day -i)];
  int dayPointer =0;
  String displayDate;
  int currentDayInt = 6;
  int currentMonth;


  Last7DaysChooser(){displayDate = '${previous7Days[dayPointer].day} ${numberToMonth[previous7Days[dayPointer].month]}';}

  void changeDateForward(){
    if(dayPointer > 0){
      dayPointer --;
      displayDate = '${previous7Days[dayPointer].day} ${numberToMonth[previous7Days[dayPointer].month]}';
    }
  }

  void changeDateBackward(){
    if(dayPointer<6){
      dayPointer++;
      displayDate = '${previous7Days[dayPointer].day} ${numberToMonth[previous7Days[dayPointer].month]}';
    }
  }
}