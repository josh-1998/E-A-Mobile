import 'package:eathlete/blocs/graph/graph_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../class_definitions.dart';
import '../common_widgets.dart';
import '../user_repository.dart';

class HomePage extends StatelessWidget {
  static const String id = 'diary page';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GraphBloc(
          userRepository: Provider.of<UserRepository>(context, listen: false)),
      child: HomePageContent(
        userRepository: Provider.of<UserRepository>(context, listen: false),
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  final UserRepository userRepository;

  HomePageContent({this.userRepository});

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  List<DropdownMenuItem> dropDownButtons = [
    DropdownMenuItem(
      value: 'Intensity',
      child: Text('Intensity'),
    ),
    DropdownMenuItem(
      value: 'Performance',
      child: Text('Performance'),
    ),
    DropdownMenuItem(
      value: 'Feeling',
      child: Text('Feeling'),
    ),
    DropdownMenuItem(
      value: 'Rest',
      child: Text('Rest'),
    ),
    DropdownMenuItem(
      value: 'Nutrition',
      child: Text('Nutrition'),
    ),
    DropdownMenuItem(
      value: 'Concentration',
      child: Text('Concentration'),
    ),
    DropdownMenuItem(
      value: 'None',
      child: Text('None'),
    ),
  ];

  var _value = 'Intensity';
  var _value1 = 'Performance';
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GraphBloc, GraphState>(
        builder: (BuildContext context, GraphState state) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: ImageIcon(
              AssetImage('images/menu_icon@3x.png'),
              color: Color(0xff828289),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
              setState(() {});
            },
          ),
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
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('One Step closer to your goal of'),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    widget.userRepository.user.longTermGoal != null
                        ? widget.userRepository.user.longTermGoal
                        : 'No long term goal has been set',
                    style: TextStyle(color: Color(0xff828289)),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text('We\'re here with you every step of the way'),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.height * 0.6,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: AssetImage('images/bg_img@3x.png'),
                            fit: BoxFit.cover)),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Image(
                                    image:
                                        AssetImage('images/mystats_icon.png'),
                                    height: 30,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text('My Stats',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14))
                                ],
                              ),
                              DropdownButton(
                                items: dropDownButtons,
                                onChanged: (value) {
                                  setState(() {
                                    _value = value;
                                    BlocProvider.of<GraphBloc>(context)
                                        .add(ChangeGraph1(value));
                                  });
                                },
                                value: _value,
                              ),
                              DropdownButton(
                                isExpanded: false,
                                items: dropDownButtons,
                                onChanged: (value) {
                                  setState(() {
                                    _value1 = value;
                                    BlocProvider.of<GraphBloc>(context)
                                        .add(ChangeGraph2(value));
                                  });
                                },
                                value: _value1,
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(icon: Icon(Icons.chevron_left,
                                ),
                                onPressed: (){
                                  BlocProvider.of<GraphBloc>(context).add(ChangeTimeViewBack());
                                },),
                                Text(state.lengthOfTime),
                                IconButton(icon: Icon(Icons.chevron_right),
                                onPressed: (){
                                  BlocProvider.of<GraphBloc>(context).add(ChangeTimeViewForward());
                                },),

                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: MaterialButton(
                                textColor: Colors.blue,

                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),
                                    side: BorderSide(color: Colors.blue)),
                                child: Text('${state.timePeriodName}'),
                                onPressed: (){
                                  BlocProvider.of<GraphBloc>(context).add(ChangeTimeViewTimeFrame());
                                },
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                            child: SimpleLineChart(
                          tableData1: state.dataList1,
                          tableData2: state.dataList2,
                              days: state.days,
                        )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 100,)
          ],
        ),
      );
    });
  }
}

class SimpleLineChart extends StatelessWidget {
  final tableData1;
  final tableData2;
  final List<charts.TickSpec<DateTime>> days;

  final bool animate;

  SimpleLineChart({this.animate, this.tableData1, this.tableData2, this.days});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<GraphObject, DateTime>> myList = [];
    print(tableData1);

    if (tableData1 != null) {
      myList.add(charts.Series(
          data: tableData1,
          measureFn: (GraphObject linearSales, _) => linearSales.yAxis,
          domainFn: (GraphObject linearSales, _) => linearSales.xAxis,
          id: 'Graph 1',
          displayName: 'Graph 1'));
    }
    if (tableData2 != null) {
      myList.add(charts.Series(
          data: tableData2,
          measureFn: (GraphObject linearSales, _) => linearSales.yAxis,
          domainFn: (GraphObject linearSales, _) => linearSales.xAxis,
          id: 'Graph 2',
          displayName: 'Graph 2'));
    }

    return charts.TimeSeriesChart(
      myList,
      animate: true,
        domainAxis: new charts.DateTimeAxisSpec(
          tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
              day: new charts.TimeFormatterSpec(
                  format: 'd', transitionFormat: 'dd/MMM')),
            tickProviderSpec: charts.StaticDateTimeTickProviderSpec(
              days,
            )),
      animationDuration: Duration(seconds: 1),
    );
  }
}

