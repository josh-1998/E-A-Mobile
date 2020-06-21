//import 'package:flutter/material.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';
//
//
//class SimpleLineChart extends StatelessWidget {
//  final tableData1;
//  final tableData2;
//  final List<charts.TickSpec<DateTime>> days;
//
//  final bool animate;
//
//  SimpleLineChart({this.animate, this.tableData1, this.tableData2, this.days});
//
//  @override
//  Widget build(BuildContext context) {
//    List<charts.Series<GraphObject, DateTime>> myList = [];
//    print(tableData1);
//
//    if (tableData1 != null) {
//      myList.add(charts.Series(
//          data: tableData1,
//          measureFn: (GraphObject linearSales, _) => linearSales.yAxis,
//          domainFn: (GraphObject linearSales, _) => linearSales.xAxis,
//          id: 'Graph 1',
//          displayName: 'Graph 1'));
//    }
//    if (tableData2 != null) {
//      myList.add(charts.Series(
//          data: tableData2,
//          measureFn: (GraphObject linearSales, _) => linearSales.yAxis,
//          domainFn: (GraphObject linearSales, _) => linearSales.xAxis,
//          id: 'Graph 2',
//          displayName: 'Graph 2'));
//    }
//
//    return charts.TimeSeriesChart(
//      myList,
//      animate: true,
//      domainAxis: new charts.DateTimeAxisSpec(
//          tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
//              day: new charts.TimeFormatterSpec(
//                  format: 'd', transitionFormat: 'dd/MMM')),
//          tickProviderSpec: charts.StaticDateTimeTickProviderSpec(
//            days,
//          )),
//      animationDuration: Duration(seconds: 1),
//    );
//  }
//}


///old way of getting graph data

//    for (var i = 0; i < numberOfDays; i++) {
//      DateTime _currentDay =
//          DateTime(lastDay.year, lastDay.month, lastDay.day - i);
//      List _currentDayEvents = generalDayMap[_currentDay];
//      if (_currentDayEvents != null) {
//        lastSevenDaysSessions.add([_currentDay, _currentDayEvents]);
//      }
//    }