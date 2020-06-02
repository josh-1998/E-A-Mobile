import 'package:eathlete/blocs/authentification/authentification_bloc.dart';
import 'package:eathlete/common_widgets/common_widgets.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

import 'log_in_screen.dart';

class Settings extends StatelessWidget {
  static const String id = 'settings';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
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
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            )
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          BigBlueButton(
            color: Colors.red,
            text: 'Delete Account',
            onPressed: (){
              Platform.isAndroid?showDialog
              <
              void>(
              context: context,
              barrierDismissible: true, // false = user must tap button, true = tap outside dialog
              builder: (BuildContext dialogContext){
              return AlertDialog(
              title: Text('Delete Account'),
              content: Text('Are you sure you want to delete your account? All data associated with this account will be permanently lost'),
              actions: <Widget>[
              FlatButton(
              child: Text('Cancel'),
              onPressed: () {
              Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
              ),
                FlatButton(
                  child: Text('Delete', style: TextStyle(color: Colors.red),),
                  onPressed: () async {
                    Provider.of<UserRepository>(context, listen: false).deleteUser();
                    AuthenticationBloc authentificationBloc =
                    BlocProvider.of<AuthenticationBloc>(context);
                    authentificationBloc.add(LoggedOut());
                    await Future.delayed(Duration(milliseconds: 1));
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginPage.id, (Route<dynamic> route) => false);
//                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  },
                ),
              ],
              );
              },
              ):showCupertinoDialog(context: context, builder: (BuildContext dialogContext){
                return CupertinoAlertDialog(
                  title: Text('Delete Account'),
                  content: Text('Are you sure you want to delete your account? All data associated with this account will be permanently lost'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                      },
                    ),
                    FlatButton(
                      child: Text('Delete', style: TextStyle(color: Colors.red),),
                      onPressed: () async {
                        Provider.of<UserRepository>(context, listen: false).deleteUser();
                        AuthenticationBloc authentificationBloc =
                        BlocProvider.of<AuthenticationBloc>(context);
                        authentificationBloc.add(LoggedOut());
                        await Future.delayed(Duration(milliseconds: 1));
                        Navigator.pushNamedAndRemoveUntil(
                            context, LoginPage.id, (Route<dynamic> route) => false);
//                        Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                      },
                    ),
                  ],
                );
              },);
              Provider.of<UserRepository>(context, listen: false).deleteUser();
            },
          )
        ],
      ),
    );
  }
}
