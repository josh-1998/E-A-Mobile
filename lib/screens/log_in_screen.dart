import 'package:eathlete/blocs/authentification/authentification_bloc.dart';
import 'package:eathlete/blocs/log_in/log_in_bloc.dart';
import 'package:eathlete/models/user_model.dart';
import 'package:eathlete/screens/forgotten_password.dart';
import 'package:eathlete/screens/profile_edit_page.dart';
import 'package:eathlete/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:provider/provider.dart';

import '../common_widgets.dart';

import '../user_repository.dart';
import 'main_page.dart';


class LoginPage extends StatefulWidget {
  static const String id = 'login page';
  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogInBloc(Provider.of<UserRepository>(context, listen: false)),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: Builder(
          builder: (BuildContext context) {
            return BlocListener<LogInBloc, LogInState>(
              listener: (context, state) {
                if (state is SuccessfulLogin) {
                  AuthenticationBloc _authentificationBloc = AuthenticationBloc(userRepository: Provider.of<UserRepository>(context, listen: false));
                  _authentificationBloc.add(LoggedIn());
                  if(Provider.of<UserRepository>(context, listen: false).user.firstName == ''){
                    Navigator.popAndPushNamed(context, MainPage.id);
                    Navigator.pushNamed(context, ProfileEditPage.id);
                  }else {
                    Navigator.popAndPushNamed(context, MainPage.id);
                  }
                }
                if (state is LoginFailure) {
                  Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.error),
                        SizedBox(width: 8,),
                        Text('Login Failure'),
                      ],
                    )));
                }
              },
              child: BlocBuilder<LogInBloc, LogInState>(
                builder: (BuildContext context, LogInState state) {


                  if(state is IsSubmitting){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(),
                      ),
                      Image(image: AssetImage('images/placeholder_logo.PNG')),
                      Text(
                        'Welcome back,',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        'Login to continue',
                        style: TextStyle(color: Color(0xffc6c6c6), fontSize: 17),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      AppStyledTextField(
                        onChanged: (value, context) => changeEmail(context, value),
                        icon: Icon(Icons.alternate_email, color: Color(0xff828289)),
                        fieldName: 'Email Address',
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      AppStyledTextField(
                        onChanged: (value, context) =>
                            changePassword(context, value),
                        icon: Icon(
                          Icons.lock_outline,
                          color: Color(0xff828289),
                        ),
                        fieldName: 'Password',
                        obscured: true,
                      ),
                      SizedBox(
                        height: 40,
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
                            submit(context);
                          },
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0.0),
                          child:
                              const Text('Sign In', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          print('User pressed forgotten password');
                          Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => PasswordReset(),
                            ),);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.vpn_key,
                              color: Color(0xff828289),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              'Forgot Password?',
                              style: TextStyle(color: Color(0xff828289)),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
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
                        height: 30,
                      ),
                      Row(
                        children: <Widget>[
                          SocialMediaButton(
                            image: Image.asset('images/facebook_logo.png'),
                            text: 'Facebook',
                            onPressed: (context) => facebookLogin(context),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          SocialMediaButton(
                            image: Image.asset('images/google_logo.png'),
                            text: 'Google',
                            onPressed: (context) => googleLogin(context),
                          )
                        ],
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Don\'t have an account?  '),
                          GestureDetector(
                            onTap: () {
                              print('User pressed sign in');
                              Navigator.pushNamed(context, SignUpPage.id);
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors.blue),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );}
              ),
            );
          },
        ),
      ),
    );
  }
}

void changeEmail(BuildContext context, String value) {
  LogInBloc loginBloc = BlocProvider.of<LogInBloc>(context);
  loginBloc.add(EmailChanged(value));
}

void changePassword(BuildContext context, String value) {
  LogInBloc loginBloc = BlocProvider.of<LogInBloc>(context);
  loginBloc.add(PasswordChanged(value));
}

void submit(BuildContext context) {
  LogInBloc loginBloc = BlocProvider.of<LogInBloc>(context);
  loginBloc.add(Submitted());
}

void facebookLogin(BuildContext context) {
  LogInBloc loginBloc = BlocProvider.of<LogInBloc>(context);
  loginBloc.add(FacebookLoginAttempt());
}

void googleLogin(BuildContext context) {
  LogInBloc loginBloc = BlocProvider.of<LogInBloc>(context);
  loginBloc.add(GoogleLogin());
}

void signUp(BuildContext context) {
  LogInBloc loginBloc = BlocProvider.of<LogInBloc>(context);
  loginBloc.add(SignUp());
}
