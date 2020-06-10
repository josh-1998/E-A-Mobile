import 'package:eathlete/blocs/result/result_bloc.dart';
import 'package:eathlete/common_widgets/common_widgets.dart';
import 'package:eathlete/common_widgets/diary_widgets.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:eathlete/models/diary_model.dart';
import 'package:eathlete/screens/Result_update_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class Results extends StatefulWidget {
  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    List resultList = Provider.of<UserRepository>(context).diary.resultList;
    List<Result> sessionListReversed = List.from(resultList.reversed);
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
      body: Container(
        child: Column(
          children: <Widget>[
            FlatButton(
              child: Text('Add result'),
              onPressed: (){
                showModalBottomSheet(context: context, builder: (builder){
                  return BlocProvider(
                      create: (context) => ResultBloc(
                          Provider.of<UserRepository>(context,
                              listen: false)),
                      child: ResultUpdateBody(),
                  );
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 100),
                  itemCount:
                  Provider.of<UserRepository>(context, listen: false).diary.resultList.length,

                  itemBuilder: (context, int index) {

                    Result _result = sessionListReversed[index];
                    return ResultEntry(
                      result: _result,
                      onDelete: ()async {
                        Provider.of<UserRepository>(context, listen: false).diary.resultList =
                        await getResultList(
                            await Provider.of<UserRepository>(context, listen: false).refreshIdToken());
                        setState(() {
                        });

                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
