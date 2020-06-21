import 'package:eathlete/blocs/competition/competition_bloc.dart';
import 'package:eathlete/blocs/general_day/general_day_bloc.dart';
import 'package:eathlete/blocs/result/result_bloc.dart';
import 'package:eathlete/blocs/session/session_bloc.dart';
import 'package:eathlete/models/diary_model.dart';
import 'package:eathlete/screens/Result_update_body.dart';
import 'package:eathlete/screens/competition_entry.dart';
import 'package:eathlete/screens/general_day_update.dart';
import 'package:eathlete/screens/session_update_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../misc/user_repository.dart';


class GeneralDayEntry extends StatefulWidget {
  final Function onDelete;
  final GeneralDay generalDay;
  const GeneralDayEntry({
    this.generalDay,
    this.onDelete,
    Key key,
  }) : super(key: key);

  @override
  _GeneralDayEntryState createState() => _GeneralDayEntryState();
}

class _GeneralDayEntryState extends State<GeneralDayEntry> {
  var _tapPosition;
  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }
  _showPopupMenu() async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
      ),
      items: [
        PopupMenuItem(

          child: GestureDetector(
              onTap: (){
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (builder) {
                      return BlocProvider(
                          create: (context) => GeneralDayBloc(
                              Provider.of<UserRepository>(context,
                                  listen: false),
                              generalDay: widget.generalDay),
                          child: GeneralDayUpdateBody());
                    });
              },
              child: Container(child: Text('Edit'))),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: ()async {
                Navigator.pop(context);
                await deleteGeneralDayItem(await Provider.of<UserRepository>(context, listen: false).refreshIdToken(), widget.generalDay);
                widget.onDelete();
                setState(() {
                });

//               showDialog(context: context, child: CupertinoAlertDialog(content: Text('Day successfully deleted'), actions: <Widget>[
//                 CupertinoDialogAction(child: Text('Ok'),onPressed: ()=>Navigator.pop(context),)
//               ],),);
              },
              child: Text('Delete')),
        )
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: InkWell(
      onTapDown: _storePosition,
      onLongPress: () {
        _showPopupMenu();
      },
        
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(spreadRadius: 0.5, blurRadius: 1, color: Colors.grey)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          height: 16,
                          width: 16,
                          child: Center(
                              child: Icon(
                                Icons.calendar_today,
                                size: 13,
                              )),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 0.5,
                                    blurRadius: 1,
                                    color: Colors.grey)
                              ],
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'General Day',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                      ],
                    ),
                    Text(
                      widget.generalDay.date == null ? '-' : widget.generalDay.date,
                      style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'I feel well rested',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      Text(widget.generalDay.rested == null
                          ? '-'
                          : '${widget.generalDay.rested}'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'I have eaten well today',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      Text(widget.generalDay.nutrition == null
                          ? '-'
                          : '${widget.generalDay.nutrition}'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Concentration throughout day',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      Text(widget.generalDay.concentration == null
                          ? '-'
                          : '${widget.generalDay.concentration}'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Reflections',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(widget.generalDay.reflections == null
                          ? '-'
                          : widget.generalDay.reflections)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CompetitionDiaryEntry extends StatefulWidget {
  final Competition _competition;
  final Function onDelete;
  CompetitionDiaryEntry(this._competition, {this.onDelete});

  @override
  _CompetitionDiaryEntryState createState() => _CompetitionDiaryEntryState();
}

class _CompetitionDiaryEntryState extends State<CompetitionDiaryEntry> {
  var _tapPosition;
  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }
  _showPopupMenu() async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
      ),
      items: [
        PopupMenuItem(

          child: GestureDetector(
              onTap: (){
                showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (builder) {
                      return BlocProvider(
                          create: (context) => CompetitionBloc(
                              Provider.of<UserRepository>(context,
                                  listen: false),
                              competition: widget._competition),
                          child: SafeArea(
                              child: SingleChildScrollView(
                                  child: CompetitionEntry())));
                    });
              },
              child: Container(child: Text('Edit'))),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: ()async {
                Navigator.pop(context);
                await deleteCompetition(await Provider.of<UserRepository>(context, listen: false).refreshIdToken(), widget._competition);
                widget.onDelete();
              },
              child: Text('Delete')),
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: InkWell(
        onTapDown: _storePosition,
        onLongPress: (){_showPopupMenu();},
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(spreadRadius: 0.5, blurRadius: 1, color: Colors.grey)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          height: 16,
                          width: 16,
                          child: Center(
                              child: Icon(
                                Icons.calendar_today,
                                size: 13,
                              )),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 0.5,
                                    blurRadius: 1,
                                    color: Colors.grey)
                              ],
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget._competition.name == null ? '-' : widget._competition.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                      ],
                    ),
                    Text(
                      widget._competition.date == null ? '-' : widget._competition.date,
                      style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Start Time',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      Text(widget._competition.startTime == null
                          ? '-'
                          : '${widget._competition.startTime.substring(0,5)}'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Address',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(widget._competition.address == null
                          ? '-'
                          : widget._competition.address),
                      SizedBox(height: 8,),
                      DateTime.parse(widget._competition.date).isBefore(DateTime.now())?FlatButton(
                        child: Text('Convert into Result', style: TextStyle(color: Colors.blue),),
                        onPressed: (){
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (builder) {
                                return BlocProvider(
                                    create: (context) => ResultBloc(
                                        Provider.of<UserRepository>(context,
                                            listen: false),
                                        competition: widget._competition,
                                        isCompetitionConverter: true,
                                        result: Result(date: widget._competition.date,
                                        name: widget._competition.name)),
                                    child: ResultUpdateBody());
                              });
                        },
                      ):Container()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SessionEntry extends StatefulWidget {
  final Session session;
  final Function onDelete;
  const SessionEntry({
    @required this.session,
    this.onDelete,
    Key key,
  }) : super(key: key);

  @override
  _SessionEntryState createState() => _SessionEntryState();
}

class _SessionEntryState extends State<SessionEntry> {
  var _tapPosition;
  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }
  _showPopupMenu() async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
      ),
      items: [
        PopupMenuItem(

          child: GestureDetector(
              onTap: (){
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (builder) {
                      return BlocProvider(
                          create: (context) => SessionBloc(
                              Provider.of<UserRepository>(context,
                                  listen: false),
                              session: widget.session),
                          child: SafeArea(
                              child: SingleChildScrollView(
                                  child: SessionUpdateScreen())));
                    });
              },
              child: Container(child: Center(child: Text('Edit')))),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: ()async {
                Navigator.pop(context);
                await deleteSession(await Provider.of<UserRepository>(context, listen: false).refreshIdToken(), widget.session);
                widget.onDelete();
              },
              child: Container(

                  child: Center(child: Text('Delete')))),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: InkWell(
        onTapDown: _storePosition,
        onLongPress: (){
          _showPopupMenu();
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(spreadRadius: 0.5, blurRadius: 1, color: Colors.grey)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    color: Colors.blue
                ),
              ),
              Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            height: 16,
                            width: 16,
                            child: Center(
                                child: Icon(
                                  Icons.hourglass_empty,
                                  size: 13,
                                )),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 0.5,
                                      blurRadius: 1,
                                      color: Colors.grey)
                                ],
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.session.title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                          )
                        ],
                      ),
                      Text(
                        widget.session.date,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Intensity of Session',
                          style: TextStyle(color: Color(0xff828289)),
                        ),
                        Text('${widget.session.intensity}'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Performance in session',
                          style: TextStyle(color: Color(0xff828289)),
                        ),
                        Text('${widget.session.performance}'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Length of session',
                          style: TextStyle(color: Color(0xff828289)),
                        ),
                        Text(widget.session.lengthOfSession == null ? '-' : '${widget.session.lengthOfSession}'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Feeling Scale',
                          style: TextStyle(color: Color(0xff828289)),
                        ),
                        Text(widget.session.feeling),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Targets for the session',
                          style: TextStyle(color: Color(0xff828289)),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(widget.session.target == null ? '-' : widget.session.target)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Reflections on the session',
                          style: TextStyle(color: Color(0xff828289)),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(widget.session.reflections == null ? '-' : widget.session.reflections)
                      ],
                    ),
                  ),
                ],
              ),
            ),]
          ),
        ),
      ),
    );
  }
}

class ResultEntry extends StatefulWidget {
  final Function onDelete;
  final Result result;
  const ResultEntry({
    this.result,
    this.onDelete,
    Key key,
  }) : super(key: key);

  @override
  _ResultEntryState createState() => _ResultEntryState();
}

class _ResultEntryState extends State<ResultEntry> {
  var _tapPosition;
  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }
  _showPopupMenu() async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
      ),
      items: [
        PopupMenuItem(

          child: GestureDetector(
              onTap: (){
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (builder) {
                      return BlocProvider(
                          create: (context) => ResultBloc(
                              Provider.of<UserRepository>(context,
                                  listen: false),
                              result: widget.result),
                          child: ResultUpdateBody());
                    });
              },
              child: Container(child: Text('Edit'))),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: ()async {
                Navigator.pop(context);
                await deleteResult(await Provider.of<UserRepository>(context, listen: false).refreshIdToken(), widget.result);
                widget.onDelete();
                setState(() {
                });
              },
              child: Text('Delete')),
        )
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: InkWell(
        onTapDown: _storePosition,
        onLongPress: () {
          _showPopupMenu();
        },

        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(spreadRadius: 0.5, blurRadius: 1, color: Colors.grey)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          height: 16,
                          width: 16,
                          child: Center(
                              child: Icon(
                                Icons.calendar_today,
                                size: 13,
                              )),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 0.5,
                                    blurRadius: 1,
                                    color: Colors.grey)
                              ],
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.result.name==null?'Result':widget.result.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                      ],
                    ),
                    Text(
                      widget.result.date == null ? '-' : widget.result.date,
                      style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Position',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      Text(widget.result.position == null
                          ? '-'
                          : '${widget.result.position}'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Reflections',
                        style: TextStyle(color: Color(0xff828289)),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(widget.result.reflections == null
                          ? '-'
                          : widget.result.reflections)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}