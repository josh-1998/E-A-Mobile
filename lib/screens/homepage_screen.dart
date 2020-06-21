import 'package:eathlete/blocs/graph/graph_bloc.dart';
import 'package:eathlete/misc/useful_functions.dart';
import 'package:eathlete/models/class_definitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common_widgets/common_widgets.dart';
import '../misc/user_repository.dart';

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

  List<PopupMenuItem> dropDownButtons = [
    PopupMenuItem(
      value: 'Intensity',
      child: Text('Intensity'),
    ),
    PopupMenuItem(
      value: 'Performance',
      child: Text('Performance'),
    ),
    PopupMenuItem(
      value: 'Feeling',
      child: Text('Feeling'),
    ),
    PopupMenuItem(
      value: 'Rest',
      child: Text('Rest'),
    ),
    PopupMenuItem(
      value: 'Nutrition',
      child: Text('Nutrition'),
    ),
    PopupMenuItem(
      value: 'Concentration',
      child: Text('Concentration'),
    ),
    PopupMenuItem(
      value: 'None',
      child: Text('None'),
    ),
  ];
  double sliderDouble = 5.0;
  var _value = 'Intensity';
  var _value1 = 'Performance';
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GraphBloc, GraphState>(
        builder: (BuildContext context, GraphState state) {
      DateTimeAxis xAxis = DateTimeAxis(
          majorGridLines: MajorGridLines(width: 0),
          maximum: currentDay,
//          visibleMaximum: state.limits[1],
//          visibleMinimum: state.limits[0]
      );
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  ProfilePhoto(
                    size: 60,
                    photo: Provider.of<UserRepository>(context)
                                .user
                                .profilePhoto !=
                            null
                        ? NetworkImage(Provider.of<UserRepository>(context)
                            .user
                            .profilePhoto)
                        : AssetImage('images/anon-profile-picture.png'),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(width: 1.0, color: Color(0xffbec2c9)),
                        ),
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextFormField(
                              style: TextStyle(fontSize: 13),
                              decoration: InputDecoration.collapsed(
                                  hintText:
                                      'What would you like to achieve today, ${Provider.of<UserRepository>(context).user.firstName}?'),
                            ),
                          ),
                        )),
                  ))
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                HomePageStatusButton(
                  backgroundColor: Color(0xffecf8ea),
                  circleColor: Color(0xffa9e1a0),
                  image: Image.asset(
                    'images/weight.png',
                    width: 20,
                  ),
                  text: 'Intensity',
                  textColor: Color(0xff17af00),
                ),
                HomePageStatusButton(
                  text: 'Hours Worked',
                  textColor: Color(0xff2179f4),
                  backgroundColor: Color(0xffe7f1fe),
                  circleColor: Color(0xff84b6fb),
                  image: Image.asset(
                    'images/hours_clock.png',
                    width: 20,
                  ),
                ),
                HomePageStatusButton(
                    textColor: Color(0xfff5542a),
                    text: 'Performance',
                    backgroundColor: Color(0xfffdece7),
                    circleColor: Color(0xfff5a895),
                    image: Image.asset(
                      'images/performance_indicator.png',
                      width: 20,
                    )),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 12),
                  child: Text(
                    'Today\'s Goal',
                    style: GoogleFonts.varelaRound(
                        textStyle: TextStyle(
                      fontSize: 20,
                    )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        widget.userRepository.user
                                                    .longTermGoal !=
                                                null
                                            ? widget.userRepository.user
                                                .longTermGoal
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
                  ),
                ),

//                Padding(
//                  padding: const EdgeInsets.all(14.0),
//                  child: Container(
//                    height: 200,
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(14),
//                    color: Colors.white,
//                    boxShadow: [BoxShadow(blurRadius: 10, offset: Offset(3, 3), spreadRadius: -2, color: Colors.grey)]
//                  ),
//                    child: Column(
//                      children: <Widget>[
//                        Expanded(
//                          child: Row(
//                            crossAxisAlignment:CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Column(
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                children: <Widget>[
//                                  Padding(
//                                    padding: const EdgeInsets.only(left: 12.0, top: 12),
//                                    child: Text(
//                                      'Today\'s Goal',
//                                      style: GoogleFonts.varelaRound(
//                                          textStyle: TextStyle(fontSize: 20,)),
//                                    ),
//                                  ),
//                                  Padding(
//                                    padding: const EdgeInsets.only(left: 12.0, top: 12),
//                                    child: Text(
//                                      'Lower Body Workout',
//                                      style: GoogleFonts.varelaRound(
//                                          textStyle: TextStyle(fontSize: 20, color: Colors.blue)),
//                                    ),
//                                  ),
//
//                                ],
//                              ),
//                              Padding(
//                                padding: const EdgeInsets.only(left:20.0),
//                                child: Image.asset('images/intensity_speedo.png', height: 80,),
//                              )
//                            ],
//                          ),
//                        ),
//                        Expanded(
//                          child: Row(
//                            children: <Widget>[
//                              Image.asset('images/hours_clock.png', height: 20,),
//                              Text('5 hours'),
//                              SizedBox(width: 20,),
//                              Image.asset('images/performance_stars.png', width: 100,)
//                            ],
//                          ),
//                        ),
//                        Container(
//                          height: 40,
//                          decoration: BoxDecoration(
//                            color: Colors.blue,
//                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(14), bottomLeft: Radius.circular(14))
//                          ),
//                          child: Center(
//                            child: Row(
//
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 12),
                  child: Text(
                    'My Current Objectives',
                    style: GoogleFonts.varelaRound(
                        textStyle: TextStyle(
                      fontSize: 20,
                    )),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
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
                                          colors: [
                                            Color(0xffecf8ea),
                                            Color(0xff67db5c)
                                          ],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(400)),
                                    child: Center(
                                      child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              color: Color(0xffa9e1a0),
                                              borderRadius:
                                                  BorderRadius.circular(400)),
                                          child:
                                              Image.asset('images/weight.png')),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Intensity',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Goal: ',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          Text(
                                            '8 ',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 10,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            'Avg: ',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          Text('6.5 ')
                                        ],
                                      ),
                                      Text(
                                        'Ends on 12/06/2020',
                                        style: TextStyle(fontSize: 9),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 16, left: 8),
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
                                        borderRadius:
                                            BorderRadius.circular(400)),
                                    child: Center(
                                      child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              color: Color(0xff84b6fb),
                                              borderRadius:
                                                  BorderRadius.circular(400)),
                                          child: Image.asset(
                                              'images/hours_clock.png')),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Hours Worked',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Goal: ',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          Text(
                                            '8 ',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 10,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            'Avg: ',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          Text('6.5 ')
                                        ],
                                      ),
                                      Text(
                                        'Ends on 12/06/2020',
                                        style: TextStyle(fontSize: 9),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 16, left: 8),
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
                                        borderRadius:
                                            BorderRadius.circular(400)),
                                    child: Center(
                                      child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              color: Color(0xfff5a895),
                                              borderRadius:
                                                  BorderRadius.circular(400)),
                                          child: Image.asset(
                                            'images/performance_indicator.png',
                                            width: 30,
                                          )),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Performance',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Goal: ',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          Text(
                                            '8 ',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 10,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            'Avg: ',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          Text('6.5 ')
                                        ],
                                      ),
                                      Text(
                                        'Ends on 12/06/2020',
                                        style: TextStyle(fontSize: 9),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 16, left: 8),
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
                Container(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
//                        image: DecorationImage(
//                            image: AssetImage('images/bg_img@3x.png'),
//                            fit: BoxFit.cover)
                  ),
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
                                  image: AssetImage('images/mystats_icon.png'),
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
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: PopupMenuButton(
                                    itemBuilder: (context){
                                      return dropDownButtons;
                                    },
                                    initialValue: 'Performance',
                                    onSelected: (value){
                                      setState(() {
                                        BlocProvider.of<GraphBloc>(context)
                                            .add(ChangeGraph1(value));
                                      });
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Text(_value),
                                        SizedBox(width: 8,),
                                        Icon(Icons.arrow_drop_down, color: Colors.grey,)
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: PopupMenuButton(

                                    itemBuilder: (context){
                                      return dropDownButtons;
                                    },
                                    initialValue: 'Intensity',
                                    onSelected: (value){
                                      setState(() {
                                        BlocProvider.of<GraphBloc>(context)
                                            .add(ChangeGraph1(value));
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.blue
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            Text('2nd chart'),
                                            SizedBox(width: 8,),
                                            Icon(Icons.arrow_drop_down, color: Colors.grey,)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),


                          ],
                        ),
                      ),
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                          Row(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: <Widget>[
//                              IconButton(
//                                icon: Icon(
//                                  Icons.chevron_left,
//                                ),
//                                onPressed: () {
////                                  BlocProvider.of<GraphBloc>(context).add(ChangeTimeViewBack());
////                                  zoomPan.panToDirection('left');
//                                },
//                              ),
//                              Text(state.lengthOfTime),
//                              IconButton(
//                                icon: Icon(Icons.chevron_right),
//                                onPressed: () {
////                                  BlocProvider.of<GraphBloc>(context).add(ChangeTimeViewForward());
////                                  zoomPan.panToDirection('right');
//                                },
//                              ),
//                            ],
//                          ),
//                          Padding(
//                            padding: const EdgeInsets.symmetric(horizontal: 10),
//                            child: MaterialButton(
//                              textColor: Colors.blue,
//                              shape: RoundedRectangleBorder(
//                                  borderRadius: BorderRadius.circular(30.0),
//                                  side: BorderSide(color: Colors.blue)),
//                              child: Text('${state.timePeriodName}'),
//                              onPressed: () {
//                                BlocProvider.of<GraphBloc>(context)
//                                    .add(ChangeTimeViewTimeFrame());
//                                //need to allow to zoom out to month
////                                if (zoomDouble == 0.3) {
////                                  zoomDouble = 0.7;
////                                } else {
////                                  zoomDouble = 0.3;
////                                }
////                                zoomPan.zoomToSingleAxis(
////                                    xAxis, 0.9, zoomDouble);
//                              },
//                            ),
//                          ),
//                        ],
//                      ),
                      Expanded(
                          child: SfCartesianChart(
                              primaryYAxis: NumericAxis(
                                  majorGridLines: MajorGridLines(
                                      dashArray: [20, 10], width: 3),
                                  minimum: 0.0,
                                  maximum: 10.05),
                              zoomPanBehavior: ZoomPanBehavior(
                                  enablePinching: true,
                                  enablePanning: true,
                                  zoomMode: ZoomMode.x),
                              primaryXAxis: xAxis,
                              series: <ChartSeries>[
                            SplineSeries<GraphObject, DateTime>(
                              dataSource: state.dataList1,
                              xValueMapper: (GraphObject graphObject, _) =>
                                  graphObject.xAxis,
                              yValueMapper: (GraphObject graphObject, _) =>
                                  graphObject.yAxis.toDouble(),
                              splineType: SplineType.monotonic,
                            ),
                            SplineSeries<GraphObject, DateTime>(
                              color: Colors.red,
                              dataSource: state.dataList2,
                              splineType: SplineType.monotonic,
                              xValueMapper: (GraphObject graphObject, _) =>
                                  graphObject.xAxis,
                              yValueMapper: (GraphObject graphObject, _) =>
                                  graphObject.yAxis,
                            ),
                          ])),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      );
    });
  }
}

///Button displayed under status updater, to be used with intensity, performance
///and hours worked
class HomePageStatusButton extends StatelessWidget {
  final Function onPressed;
  final Color circleColor;
  final Color backgroundColor;
  final String text;
  final Image image;
  final Color textColor;
  const HomePageStatusButton(
      {Key key,
      this.image,
      this.onPressed,
      this.backgroundColor,
      this.circleColor,
      this.text,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed,
      child: Container(
        height: 30,
        width: 120,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: <Widget>[
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: circleColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: image,
              ),
            ),
            Expanded(
              child: Container(
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(color: textColor, fontSize: 10),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
