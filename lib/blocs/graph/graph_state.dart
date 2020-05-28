part of 'graph_bloc.dart';

@immutable
abstract class GraphState extends Equatable{
  List<GraphObject> dataList1;
  List<GraphObject> dataList2;
  List<TickSpec<DateTime>> days;
  String lengthOfTime;
  String timePeriodName;
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class InitialGraphState extends GraphState {
  final List<GraphObject> dataList1;
  final List<GraphObject> dataList2;
  final List<TickSpec<DateTime>> days;
  final String timePeriodName;
  final String lengthOfTime;

  InitialGraphState(this.dataList1, this.dataList2, this.timePeriodName, this.lengthOfTime, this.days);

  @override
  List<Object> get props => [dataList1, dataList2, timePeriodName, lengthOfTime, days];
}

class NewGraphInfo extends GraphState {
 final List<GraphObject> dataList1;
 final List<GraphObject> dataList2;
 List<TickSpec<DateTime>> days;
 final String timePeriodName;
 final String lengthOfTime;

 NewGraphInfo(this.dataList1, this.dataList2, this.timePeriodName, this.lengthOfTime, this.days);

 @override
  List<Object> get props => [dataList1, dataList2, timePeriodName, lengthOfTime, days];
}