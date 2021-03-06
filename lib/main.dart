import 'package:eathlete/misc/message_handler.dart';
import 'package:eathlete/misc/network_handler.dart';
import 'package:eathlete/screens/goals.dart';
import 'package:eathlete/screens/loading_screen.dart';

import 'package:eathlete/screens/log_in_screen.dart';
import 'package:eathlete/screens/main_page.dart';

import 'package:eathlete/screens/new_graph.dart';
import 'package:eathlete/screens/notifications.dart';
import 'package:eathlete/screens/profile_edit_page.dart';
import 'package:eathlete/screens/settings.dart';
import 'package:eathlete/screens/sign_up_screen.dart';
import 'package:eathlete/screens/timer.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'blocs/authentification/authentification_bloc.dart';
import 'blocs/goals/goals_bloc.dart';
import 'models/class_definitions.dart';
import 'misc/simple_bloc_delegate.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  int pageNumber = 1;
  // TODO: change provider to proxy provider to allow for everything to update
  runApp(ProxyProvider0(
    update: (a, b) => PageNumber(),
    child: ListenableProvider<UserRepository>(
      create: (context) => UserRepository(),
      child: BlocProvider(
          create: (context) => AuthenticationBloc(
              userRepository:
                  Provider.of<UserRepository>(context, listen: false))
            ..add(AppStarted()),
          child: MyApp(userRepository: userRepository)),
    ),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        super(key: key);


  @override
  Widget build(BuildContext context) {

    return NetworkHandler(
      child: MyMessageHandler(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            buttonColor: Colors.grey,
            primarySwatch: Colors.grey,

          ),
          routes: {
            LoginPage.id: (context) => LoginPage(),
            SignUpPage.id: (context) => SignUpPage(),
            MainPage.id: (context) => MainPage(),
            ProfileEditPage.id: (context) => ProfileEditPage(),
            TimerPageActual.id: (context) => TimerPageActual(),
            Notifications.id: (context) => Notifications(),
            Settings.id: (context) => Settings(),
          },
          home:
//          BlocProvider(
//              create: (context) => GoalsBloc(userRepository: Provider.of<UserRepository>(context, listen: false)),
//              child:
//              Goals())
//        NewGraphTest()
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state is Loading) {
                  return LoadingScreen();
                }
                if (state is Uninitialized) {
                  return LoginPage();
                }
                if (state is Authenticated) {
                  return MainPage(
                    pageNumber: Provider.of<PageNumber>(context).pageNumber,
                  );
                }
                if (state is Unauthenticated) {
                  return LoginPage();
                }
                return Container();
              },
            ),
        ),
      ),
    );
  }
}
