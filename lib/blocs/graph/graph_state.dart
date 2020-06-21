part of 'graph_bloc.dart';

@immutable
abstract class GraphState extends Equatable{
  List<GraphObject> dataList1;
  List<GraphObject> dataList2;
  List<DateTime> limits;
  String lengthOfTime;
  String timePeriodName;
  @override
  List<Object> get props => [];
}

class InitialGraphState extends GraphState {
  final List<GraphObject> dataList1;
  final List<GraphObject> dataList2;
  List<DateTime> limits;
  final String timePeriodName;
  final String lengthOfTime;

  InitialGraphState(this.dataList1, this.dataList2, this.timePeriodName, this.lengthOfTime, this.limits);

  @override
  List<Object> get props => [dataList1, dataList2, timePeriodName, lengthOfTime, limits];
}

class NewGraphInfo extends GraphState {
 final List<GraphObject> dataList1;
 final List<GraphObject> dataList2;
 List<DateTime> limits;
 final String timePeriodName;
 final String lengthOfTime;

 NewGraphInfo(this.dataList1, this.dataList2, this.timePeriodName, this.lengthOfTime, this.limits);

 @override
  List<Object> get props => [dataList1, dataList2, timePeriodName, lengthOfTime, limits];
}