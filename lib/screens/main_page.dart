//import 'dart:html';

import 'package:eathlete/blocs/general_day/general_day_bloc.dart';
import 'package:eathlete/blocs/session/session_bloc.dart';
import 'package:eathlete/models/diary_model.dart';
import 'package:eathlete/screens/profile_page.dart';
import 'package:eathlete/screens/session_update_screen.dart';
import 'package:eathlete/screens/update_chooser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../models/class_definitions.dart';
import '../common_widgets/common_widgets.dart';
import '../common_widgets/navbar.dart';
import '../misc/useful_functions.dart';
import '../misc/user_repository.dart';
import 'calendar_page.dart';
import 'diary_entry_screen.dart';
import 'general_day_update.dart';
import 'homepage_screen.dart';

class MainPage extends StatefulWidget {
  static const String id = 'MainAppPage';
  int pageNumber;
  MainPage({Key key, this.pageNumber = 0}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool showUpdatePicker = false;
  List<Session> sessions = [];

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomePage(),
      DiaryEntryPage(),
      CalendarPage(),
      ProfilePage()
    ];
    return Provider(
      create: (context) => sessions,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        drawer: EAthleteDrawer(),
        body: Stack(children: <Widget>[
          pages[Provider.of<PageNumber>(
            context,
          ).pageNumber],
          EAthleteNavBar(
            pageNumber: Provider.of<PageNumber>(
              context,
            ).pageNumber,
            button1OnPressed: () {
              setState(() {
                Provider.of<PageNumber>(context, listen: false).pageNumber = 0;
                print(
                    Provider.of<PageNumber>(context, listen: false).pageNumber);
              });
            },
            button2OnPressed: () {
              setState(() {
                widget.pageNumber = 1;
                Provider.of<PageNumber>(context, listen: false).pageNumber = 1;
                print(
                    Provider.of<PageNumber>(context, listen: false).pageNumber);
              });
            },
            button3OnPressed: () {
              setState(() {
                showUpdatePicker = true;
              });
//            Navigator.pushNamed(context, UpdateChooser.id);
            },
            button4OnPressed: () {
              setState(() {
                Provider.of<PageNumber>(context, listen: false).pageNumber = 2;
              });
            },
            button5OnPressed: () {
              setState(() {
                Provider.of<PageNumber>(context, listen: false).pageNumber = 3;
              });
            },
          ),
          showUpdatePicker == true
              ? UpdatePicker(
                  button1Function: () {
                    UserRepository _userRepository =
                        Provider.of<UserRepository>(context, listen: false);
                    Map eventsMap = {};
                    for (GeneralDay generalDay
                        in _userRepository.diary.generalDayList) {
                      DateTime date = DateTime.parse(generalDay.date);
                      eventsMap.update(date, (existingValue) {
                        existingValue.add(generalDay);
                        return existingValue;
                      }, ifAbsent: () => [generalDay]);
                    }

                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                        builder: (builder) {
                          return Container(
                            height: MediaQuery.of(context).size.height*0.9,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 10,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(40)
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: SingleChildScrollView(
                                      child: BlocProvider(
                                        create: (context) => GeneralDayBloc(
                                              Provider.of<UserRepository>(context,
                                                  listen: false),
                                              generalDay: eventsMap[currentDay]!=null?eventsMap[currentDay][0]:GeneralDay()),
                                        child: SafeArea(
                                            child: GeneralDayUpdateBody(),
                                          ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).then((value) {
                      setState(() {});
                    });
                    setState(() {
                      showUpdatePicker = false;
                    });
                  },
                  button2Function: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                        context: context,
                        builder: (builder) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            height: MediaQuery.of(context).size.height*0.9,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 10,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(40)
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                    child: SingleChildScrollView(
                                      child: BlocProvider(
                                        create: (context) => SessionBloc(
                                              Provider.of<UserRepository>(context,
                                                  listen: false)),
                                        child: SafeArea(
                                              child: SessionUpdateScreen()),
                                      ),
                                      physics: ClampingScrollPhysics(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                    setState(() {
                      showUpdatePicker = false;
                    });
                  },
                  button3Function: () {
                    setState(() {
                      showUpdatePicker = false;
                    });
                  },
                )
              : Container()
        ]),
      ),
    );
  }
}

