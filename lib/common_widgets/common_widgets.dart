import 'package:eathlete/screens/competition_entry.dart';
import 'package:eathlete/screens/log_in_screen.dart';
import 'package:eathlete/screens/main_page.dart';
import 'package:eathlete/screens/notifications.dart';
import 'package:eathlete/screens/results.dart';
import 'package:eathlete/screens/settings.dart';
import 'package:eathlete/screens/timer.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:provider/provider.dart';

import '../blocs/authentification/authentification_bloc.dart';
import '../blocs/competition/competition_bloc.dart';
import '../models/class_definitions.dart';
import '../main.dart';
import '../models/diary_model.dart';

class SocialMediaButton extends StatelessWidget {
  final Image image;
  final String text;
  final Function onPressed;

  const SocialMediaButton({this.image, this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 50,
        child: MaterialButton(
          onPressed: () => onPressed(context),
          elevation: 0,
          color: Color(0xfff2f2f3),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: <Widget>[image, Text(text)],
          ),
        ),
      ),
    );
  }
}

class AppStyledTextField extends StatefulWidget {
  final String fieldName;
  final Icon icon;
  final bool obscured;
  final String initialValue;
  final Function onChanged;
  final int minLines;
  final int maxLines;
  final int maxLength;
  final TextInputType keyboardType;
  final bool autocorrect;
  final Color borderColor;
  final Color helpTextColor;

  AppStyledTextField(
      {this.fieldName,
      this.icon,
      this.obscured = false,
      this.initialValue = '',
      this.onChanged,
      this.minLines = 1,
      this.maxLines = 1,
      this.maxLength = 1000,
      this.keyboardType = TextInputType.text,
      this.autocorrect = true,
      this.borderColor = const Color(0xff828289),
      this.helpTextColor = const Color(0xff828289)});

  @override
  _AppStyledTextFieldState createState() => _AppStyledTextFieldState();
}

class _AppStyledTextFieldState extends State<AppStyledTextField> {
  String textValue;
  bool _hidden = true;

  @override
  void initState() {
    super.initState();
    textValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.obscured == false) {
      return Container(
        child: Stack(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: widget.borderColor),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: widget.minLines == 1 ? 0 : 8),
                child: Row(
                  children: <Widget>[
                    widget.icon == null
                        ? Container()
                        : Expanded(flex: 1, child: widget.icon),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 10,
                      child: TextFormField(
                        autocorrect: widget.autocorrect,
                        minLines: widget.minLines,
                        maxLines: widget.maxLines,
                        keyboardType: widget.keyboardType,
                        onChanged: (value) {
                          setState(() {
                            textValue = value;
                          });
                          widget.onChanged(value, context);
                        },
                        initialValue: widget.initialValue,
                        decoration: InputDecoration.collapsed(
                            hintText: widget.fieldName,
                            hintStyle: TextStyle(color: widget.helpTextColor)),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    )
                  ],
                ),
              ),
            ),
          ),
          textValue != ''
              ? Positioned(
                  top: 0,
                  left: 10,
                  child: Text(
                    ' ${widget.fieldName} ',
                    style: TextStyle(
                        backgroundColor: Colors.white,
                        color: widget.borderColor),
                  ),
                )
              : Container()
        ]),
      );
    } else {
      return Container(
        child: Stack(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: widget.borderColor),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: <Widget>[
                  Expanded(flex: 1, child: widget.icon),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 10,
                    child: TextField(
                      onChanged: (value) => widget.onChanged(value, context),
                      obscureText: _hidden,
                      decoration: new InputDecoration.collapsed(
                          hintText: widget.fieldName),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: RawMaterialButton(
                      onPressed: () {
                        setState(() {
                          _hidden = !_hidden;
                        });
                      },
                      child: Text(
                        _hidden ? 'Show' : 'Hide',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          textValue != ''
              ? Positioned(
                  top: 0,
                  left: 10,
                  child: Text(
                    ' ${widget.fieldName} ',
                    style: TextStyle(
                        backgroundColor: Colors.white,
                        color: Color(0xff828289)),
                  ),
                )
              : Container()
        ]),
      );
    }
  }
}

class ProfilePhoto extends StatefulWidget {
  final Function onPress;
  final double size;
  final ImageProvider photo;
  ProfilePhoto(
      {Key key,
      this.size = 30,
      this.photo = const AssetImage('images/anon-profile-picture.png'),
      this.onPress});

  @override
  _ProfilePhotoState createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onPress,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(400),
              image: DecorationImage(image: widget.photo, fit: BoxFit.cover)),
        ));
  }
}

class NotificationButton extends StatefulWidget {
  @override
  _NotificationButtonState createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  bool notification = false;
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      IconButton(
          icon: ImageIcon(
            AssetImage('images/bell.png'),
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Notifications()),
            );
          }),
      Positioned(
        top: 12,
        right: 12,
        child: Container(
          height: 5,
          width: 5,
          decoration: BoxDecoration(
              color: notification ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.circular(20)),
        ),
      )
    ]);
  }
}

class EAthleteDrawer extends StatefulWidget {
  const EAthleteDrawer({
    Key key,
  }) : super(key: key);

  @override
  _EAthleteDrawerState createState() => _EAthleteDrawerState();
}

class _EAthleteDrawerState extends State<EAthleteDrawer> {
  @override
  Widget build(BuildContext context) {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.10, left: 15),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ProfilePhoto(
                    size: 60,
                    photo: userRepository.user.profilePhoto != null
                        ? NetworkImage(userRepository.user.profilePhoto)
                        : AssetImage('images/anon-profile-picture.png'),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    '${userRepository.user.firstName} ${userRepository.user.lastName}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Divider(),
          ),
          EAthleteDrawerTile(
            name: 'Home',
            selected:
                Provider.of<PageNumber>(context, listen: false).pageNumber == 0
                    ? true
                    : false,
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                Provider.of<PageNumber>(context, listen: false).pageNumber = 0;
                print(
                    Provider.of<PageNumber>(context, listen: false).pageNumber);
              });
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainPage(
                            pageNumber:
                                Provider.of<PageNumber>(context, listen: false)
                                    .pageNumber,
                          )),
                  (route) => false);
            },
          ),
          EAthleteDrawerTile(
            selected:
                Provider.of<PageNumber>(context, listen: false).pageNumber == 1
                    ? true
                    : false,
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                Provider.of<PageNumber>(context, listen: false).pageNumber = 1;

                print(
                    Provider.of<PageNumber>(context, listen: false).pageNumber);
              });
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainPage(
                            pageNumber:
                                Provider.of<PageNumber>(context, listen: false)
                                    .pageNumber,
                          )),
                  (route) => false);
            },
            name: 'Update my Diary',
          ),
          EAthleteDrawerTile(
            name: 'Competition Calendar',
            selected:
                Provider.of<PageNumber>(context, listen: false).pageNumber == 2
                    ? true
                    : false,
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                Provider.of<PageNumber>(context, listen: false).pageNumber = 2;
                print(
                    Provider.of<PageNumber>(context, listen: false).pageNumber);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainPage(
                              pageNumber: Provider.of<PageNumber>(context,
                                      listen: false)
                                  .pageNumber,
                            )),
                    (route) => false);
              });
            },
          ),
          EAthleteDrawerTile(
            name: 'Results',
            selected:
                Provider.of<PageNumber>(context, listen: false).pageNumber == 4
                    ? true
                    : false,
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                Provider.of<PageNumber>(context, listen: false).pageNumber = 4;
                print(
                    Provider.of<PageNumber>(context, listen: false).pageNumber);
              });
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Results()));
            },
          ),
          EAthleteDrawerTile(
            name: 'My Profile',
            selected:
                Provider.of<PageNumber>(context, listen: false).pageNumber == 3
                    ? true
                    : false,
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                Provider.of<PageNumber>(context, listen: false).pageNumber = 3;
                print(
                    Provider.of<PageNumber>(context, listen: false).pageNumber);
              });
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainPage(
                            pageNumber:
                                Provider.of<PageNumber>(context, listen: false)
                                    .pageNumber,
                          )),
                  (route) => false);
            },
          ),
          EAthleteDrawerTile(
            name: 'Goals',
            selected:
            Provider.of<PageNumber>(context, listen: false).pageNumber == 0
                ? true
                : false,
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                Provider.of<PageNumber>(context, listen: false).pageNumber = 0;
                print(
                    Provider.of<PageNumber>(context, listen: false).pageNumber);
              });
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainPage(
                        pageNumber:
                        Provider.of<PageNumber>(context, listen: false)
                            .pageNumber,
                      )),
                      (route) => false);
            },
          ),

//          EAthleteDrawerTile(
//            name: 'My Programs',
//          ),
          EAthleteDrawerTile(
            name: 'Timer',
            onPressed: () {
              Navigator.popAndPushNamed(context, TimerPageActual.id);
            },
          ),
          EAthleteDrawerTile(
            name: 'Settings',
            onPressed: () {
              setState(() {
//                Provider.of<PageNumber>(context, listen: false).pageNumber = 2;
//                print(
//                    Provider.of<PageNumber>(context, listen: false).pageNumber);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Settings(),
                  ),
                );
              });
            },
          ),
          Expanded(
            child: Container(),
          ),
          EAthleteDrawerTile(
            name: 'Sign Out',
            selected: false,
            onPressed: () async {
              AuthenticationBloc authentificationBloc =
                  BlocProvider.of<AuthenticationBloc>(context);
              authentificationBloc.add(LoggedOut());
              await Future.delayed(Duration(milliseconds: 1));
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginPage.id, (Route<dynamic> route) => false);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 4),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Privacy Policy',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    'App V 1.0.0',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class EAthleteDrawerTile extends StatefulWidget {
  final Function onPressed;
  final String name;
  final bool selected;

  EAthleteDrawerTile(
      {this.onPressed, @required this.name, this.selected = false});

  @override
  _EAthleteDrawerTileState createState() => _EAthleteDrawerTileState();
}

class _EAthleteDrawerTileState extends State<EAthleteDrawerTile> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: widget.onPressed,
      child: Padding(
        padding: EdgeInsets.only(
            left: 0, top: MediaQuery.of(context).size.height * 0.01, right: 15),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.name,
                style: TextStyle(
                    fontWeight:
                        widget.selected ? FontWeight.bold : FontWeight.normal,
                    color: widget.selected ? Colors.black : Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: Divider(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final String category;
  final String value;

  const ProfileItem({Key key, @required this.category, this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                category,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                value,
                style: TextStyle(color: Color(0xff828289)),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider()
        ],
      ),
    );
  }
}

class NumberScale extends StatefulWidget {
  final int maxNumber;
  final Function onChanged;
  final Color selectedColor;
  final Color borderColor;
  final int initialValue;

  const NumberScale({
    Key key,
    this.initialValue = 0,
    this.selectedColor = Colors.blue,
    this.onChanged,
    this.borderColor = Colors.grey,
    @required this.maxNumber,
  }) : super(key: key);

  @override
  _NumberScaleState createState() => _NumberScaleState();
}

class _NumberScaleState extends State<NumberScale> {
  int numberChosen;
  @override
  void initState() {
    super.initState();
    numberChosen = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    List<GestureDetector> scale = [];
    for (var i = 1; i <= widget.maxNumber; i++) {
      scale.add(GestureDetector(
          onTap: () {
            setState(() {
              numberChosen = i;
            });
            widget.onChanged(i);
          },
          child: Container(
            height: 50,
            width: 30,
            decoration: BoxDecoration(
              color: i == numberChosen
                  ? Colors.lightBlue
                  : /*Color(0xfff3f3f3)*/ Colors.transparent,
              border: Border.all(color: widget.borderColor, width: 0.5),
              borderRadius: i == 1
                  ? BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5))
                  : i == widget.maxNumber
                      ? BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5))
                      : BorderRadius.zero,
            ),
            child: Center(
              child: Text(
                '$i',
                style: TextStyle(
                  color: i == numberChosen ? Colors.white : Colors.black,
                ),
              ),
            ),
          )));
    }

    return Container(
      width: widget.maxNumber * 30 + 2.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
//          border: Border.all(color: Color(0xff828289))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: scale,
      ),
    );
  }
}

class FloatingInfoCard extends StatefulWidget {
  final Widget child;

  FloatingInfoCard({Key key, this.child}) : super(key: key);

  @override
  _FloatingInfoCardState createState() => _FloatingInfoCardState();
}

class _FloatingInfoCardState extends State<FloatingInfoCard> {
  double offsetAmount = 0;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.85;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            width: MediaQuery.of(context).size.width,
            height: height,
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Container(
                    width: 40,
                    height: 10,
                    decoration: BoxDecoration(
                        color: Color(0xffd8d8d8),
                        borderRadius: BorderRadius.circular(40)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              widget.child,
            ]),
          )
        ],
      ),
    );
  }
}

class PickerEntryBox extends StatefulWidget {
  final Function onPressed;
  final String name;
  final String value;
  final Color borderColor;
  final Color textColor;
  const PickerEntryBox({
    this.borderColor = const Color(0xff828289),
    this.name,
    this.onPressed,
    this.value,
    this.textColor = const Color(0xff828289),
    Key key,
  }) : super(key: key);

  @override
  _PickerEntryBoxState createState() => _PickerEntryBoxState();
}

class _PickerEntryBoxState extends State<PickerEntryBox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        widget.onPressed();
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
        decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: widget.borderColor),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 8,
            ),
            Text(
              widget.name,
              style: TextStyle(
                  fontWeight: FontWeight.normal, color: widget.textColor),
            ),
            Expanded(
              flex: 10,
              child: Container(
                height: 45,
              ),
            ),
            Text(
              widget.value,
              style: TextStyle(color: widget.textColor),
            ),
            IconButton(
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: widget.borderColor,
              ),
              padding: EdgeInsets.all(0),
              onPressed: () {
                widget.onPressed();
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BigBlueButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color color;
  const BigBlueButton(
      {Key key,
      this.onPressed,
      this.text,
      this.color = const Color(0xff0088ff)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 90),
      child: Container(
        width: 499,
        height: 60,
        child: MaterialButton(
          color: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () {
            onPressed();
          },
          textColor: Colors.white,
          padding: const EdgeInsets.all(0.0),
          child: Text(text, style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
