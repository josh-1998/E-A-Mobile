//import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutterappdem/models/diary_model.dart';
//import 'package:flutterappdem/screens/bottom_sheet_custom.dart';
//import 'package:flutterappdem/user_repository.dart';
//import 'package:provider/provider.dart';
//
//import 'blocs/session/session_bloc.dart';
//
//class Test extends StatelessWidget {
//  static const String id = 'test';
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: BlocProvider<SessionBloc>(
//          create: (context) => SessionBloc(Provider.of<UserRepository>(context)), child: Body()),
//    );
//  }
//}
//
//class Body extends StatelessWidget {
//  const Body({
//    Key key,
//  }) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    SessionBloc sessionBloc = BlocProvider.of<SessionBloc>(context);
//    return Center(
//        child: Container(
//            child: FlatButton(
//                onPressed: () {
//                  showModalBottomSheetCustom(
//                      context: context,
//                      builder: (context) {
//                        return ThisWidget();
//                      });
//                },
//                child: Text(
//                  'hello',
//                ))));
//  }
//}
//
//class ThisWidget extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: BlocProvider(
//          create: (context) => SessionBloc(Provider.of<UserRepository>(context)),
//          child: BottomBody()),
//    );
//  }
//}
//
//class BottomBody extends StatelessWidget {
//  const BottomBody({
//    Key key,
//  }) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    SessionBloc sessionBloc = BlocProvider.of<SessionBloc>(context);
//    return Column(
//      children: <Widget>[Text('Hey')],
//    );
//  }
//}
