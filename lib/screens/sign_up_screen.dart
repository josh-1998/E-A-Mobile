
import 'package:eathlete/blocs/authentification/authentification_bloc.dart';
import 'package:eathlete/blocs/log_in/log_in_bloc.dart';
import 'package:eathlete/screens/profile_edit_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:provider/provider.dart';

import '../common_widgets/common_widgets.dart';
import '../misc/user_repository.dart';
import 'homepage_screen.dart';
import 'log_in_screen.dart';
import 'main_page.dart';

class SignUpPage extends StatefulWidget {
  static const String id = 'signup page';
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogInBloc(Provider.of<UserRepository>(context, listen: false)),
      child: SignUpPageContent(),
    );

  }
}

class SignUpPageContent extends StatelessWidget {
  const SignUpPageContent({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var gap = height*0.01;
    return BlocListener<LogInBloc,LogInState>(
      listener: (BuildContext context, LogInState state){
        if(state is SuccessfulLogin){
          AuthenticationBloc _authentificationBloc = AuthenticationBloc(userRepository: Provider.of<UserRepository>(context, listen: false));
          _authentificationBloc.add(LoggedIn());
          Navigator.pop(context);
          Navigator.popAndPushNamed(context, MainPage.id);
          Navigator.pushNamed(context, ProfileEditPage.id);
        }
      },
      child: BlocBuilder(
        bloc: BlocProvider.of<LogInBloc>(context),
      builder: (context, LogInState state) {
      if(state is SuccessfulLogin){


      }
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: height),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: Container()),
                    Image(image: AssetImage('images/placeholder_logo.PNG')),
                    Text(
                      'Welcome to E-Athlete',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      'Create your account',
                      style: TextStyle(color: Color(0xffc6c6c6), fontSize: 17),
                    ),
                    SizedBox(
                      height: gap,
                    ),
                    AppStyledTextField(
                      onChanged: (value, context){
                        LogInBloc loginBloc = BlocProvider.of<LogInBloc>(context);
                        loginBloc.add(NameChanged(value));
                      },
                      icon: Icon(Icons.person, color: Color(0xff828289)),
                      fieldName: 'Name',
                    ),
                    SizedBox(
                      height: gap,
                    ),
                    AppStyledTextField(
                      onChanged: (value, context){
                        LogInBloc loginBloc = BlocProvider.of<LogInBloc>(context);
                        loginBloc.add(EmailChanged(value));
                      },
                      icon: Icon(Icons.alternate_email, color: Color(0xff828289)),
                      fieldName: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                    ),
                    SizedBox(
                      height: gap,
                    ),
                    AppStyledTextField(
                      onChanged: (value, context){
                        LogInBloc loginBloc = BlocProvider.of<LogInBloc>(context);
                        loginBloc.add(PasswordChanged(value));
                      },
                      icon: Icon(
                        Icons.lock_outline,
                        color: Color(0xff828289),
                      ),
                      fieldName: 'Password',
                      obscured: true,
                    ),
                    SizedBox(
                      height: gap*2,
                    ),
                    Container(
                      width: 499,
                      height: 60,
                      child: MaterialButton(
                        color: Color(0xff0088ff),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          LogInBloc loginBloc = BlocProvider.of<LogInBloc>(context);
                          loginBloc.add(SignUp());
                        },
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    SizedBox(
                      height: gap*1.5,
                    ),
                    Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                          child: Divider(
                            thickness: 2,
                            color: Color(0xffeeeeef),
                          ),
                        ),
                        Center(
                            child: Container(
                          width: 30,
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              'OR',
                              style: TextStyle(
                                  color: Color(0xffc0c0c4),
                                  backgroundColor: Colors.white),
                            ),
                          ),
                        ))
                      ],
                    ),
                    SizedBox(
                      height: gap*1.5,
                    ),
                    Row(
                      children: <Widget>[
                        SocialMediaButton(
                          image: Image.asset('images/facebook_logo.png'),
                          text: 'Facebook',
                          onPressed: (context) {
                            LogInBloc loginBloc = BlocProvider.of<LogInBloc>(context);
                            loginBloc.add(FacebookLoginAttempt());
                          },
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        SocialMediaButton(
                          image: Image.asset('images/google_logo.png'),
                          text: 'Google',
                          onPressed: (context){
                            print('Google');
                            LogInBloc loginBloc = BlocProvider.of<LogInBloc>(context);
                            loginBloc.add(GoogleLogin());
                          },
                        )
                      ],
                    ),
                    Expanded(child: Container()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Already have an account?  '),
                        GestureDetector(
                          onTap: () {
                            print('User pressed sign in');
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

        );}
      ),
    );
  }
}

