import 'package:DigiBus/ui/bottom_navs/history.dart';
import 'package:DigiBus/ui/bottom_navs/home/home.dart';
import 'package:DigiBus/ui/bottom_navs/home/new.dart';
import 'package:DigiBus/ui/bottom_navs/home/success.dart';
import 'package:DigiBus/ui/bottom_navs/home/tripDetails.dart';
import 'package:DigiBus/ui/index.dart';
import 'package:DigiBus/ui/onboard-users/signin.dart';
import 'package:DigiBus/ui/onboard-users/signup.dart';
import 'package:DigiBus/ui/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool boolValue = prefs.getBool('loggedIn');
  bool loggedIn;
  if (boolValue == true) {
    loggedIn = true;
  } else if (boolValue == false) {
    loggedIn = false;
  } else {
    loggedIn = false;
  }
  runApp(MyApp(
    loggedIn: loggedIn,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({this.loggedIn});

  final bool loggedIn;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DigiBus',
      theme: ThemeData(
        primaryColor: Color(0xff1dbc92),
        accentColor: Color(0xff1dbc92),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: loggedIn ? Index.id : Welcome.id,
      routes: {
        Welcome.id: (context) => Welcome(),
        SignIn.id: (context) => SignIn(),
        SignUp.id: (context) => SignUp(),
        Index.id: (context) => Index(),
        Home.id: (context) => Home(),
        New.id: (context) => New(),
        Success.id: (context) => Success(),
        History.id: (context) => History(),
        TripDetails.id: (context) => TripDetails(),
      },
    );
  }
}
