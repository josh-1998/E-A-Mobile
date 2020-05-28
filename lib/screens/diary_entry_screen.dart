import 'package:eathlete/models/diary_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common_widgets.dart';
import '../database.dart';
import '../user_repository.dart';

class DiaryEntryPage extends StatefulWidget {
  static const String id = 'home page';

  @override
  _DiaryEntryPageState createState() => _DiaryEntryPageState();
}

class _DiaryEntryPageState extends State<DiaryEntryPage>
    with TickerProviderStateMixin {
  List<Widget> _children = [SessionPage(), GeneralDayPage()];

  int _currentIndex = 0;
  TabController tabController;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(
      vsync: this,
      length: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: ImageIcon(
              AssetImage('images/menu_icon@3x.png'),
              color: Color(0xff828289),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          elevation: 1,
          actions: <Widget>[NotificationButton()],
          backgroundColor: Colors.white,
          title: Row(
//          mainAxisAlignment: MainAxisAlignment.center,
//          crossAxisAlignment: CrossAxisAlignment.center,
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
          bottom: TabBar(
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Color(0xff23232f),
            labelStyle: TextStyle(fontSize: 10),
            unselectedLabelColor: Colors.grey,
            controller: tabController,
            onTap: onTabTapped,
            tabs: <Widget>[
              Tab(
                text: 'Session',
              ),
              Tab(
                text: 'General Day',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: _children,
          controller: tabController,
        ));
  }
}

class SessionPage extends StatefulWidget {
  SessionPage({Key key}) : super(key: key);

  @override
  _SessionPageState createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {

  @override
  Widget build(BuildContext context) {
    List sessionList = Provider.of<UserRepository>(context).diary.sessionList;
    List<Session> sessionListReversed = List.from(sessionList.reversed);
    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<UserRepository>(context, listen: false).diary.sessionList =
            await getSessionList(
                await Provider.of<UserRepository>(context, listen: false).refreshIdToken());
        setState(() {

        });
        DBHelper.deleteDataFromTable('Sessions');
        DBHelper.updateSessionsList(Provider.of<UserRepository>(context, listen: false).diary.sessionList);

      },
      child: ListView.builder(
          itemCount:
              Provider.of<UserRepository>(context, listen: false).diary.sessionList.length,

          itemBuilder: (context, int index) {

            Session _session =
               sessionListReversed[index];
            return SessionEntry(
              session: _session,
            );
          }),
    );
  }
}

class GeneralDayPage extends StatefulWidget {
  @override
  _GeneralDayPageState createState() => _GeneralDayPageState();
}

class _GeneralDayPageState extends State<GeneralDayPage> {

  @override
  Widget build(BuildContext context) {
    List generalDayList = Provider.of<UserRepository>(context,).diary.generalDayList;
    List<GeneralDay> generalDayListReversed = List.from(generalDayList.reversed);
    return RefreshIndicator(
      onRefresh: ()async {
        Provider.of<UserRepository>(context, listen: false).diary.generalDayList =
            await getGeneralDayList(
            await Provider.of<UserRepository>(context, listen: false).refreshIdToken());
        setState(() {

        });
        DBHelper.deleteDataFromTable('GeneralDays');
        DBHelper.updateGeneralDayList(Provider.of<UserRepository>(context, listen: false).diary.generalDayList);
      },
      child: ListView.builder(
          itemCount:
              Provider.of<UserRepository>(context).diary.generalDayList.length,
          itemBuilder: (BuildContext context, int index) {
            GeneralDay _generalDay =
                generalDayListReversed[index];
            return GeneralDayEntry(
              generalDay: _generalDay,
            );
          }),
    );
  }
}


