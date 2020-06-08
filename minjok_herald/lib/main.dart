import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minjok_herald/pages/auth/authentication.dart';
import 'package:minjok_herald/pages/auth/root_page.dart';
import 'dart:async';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'SchoolDev',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new SplashScreen(),
        routes: <String, WidgetBuilder>{
        '/HomeScreen': (BuildContext context) => new RootPage(auth: new Auth())});

//        home: new RootPage(auth: new Auth()));
  }


}
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/HomeScreen');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Container(
          padding: EdgeInsets.all(80),
          child: new Image.asset('assets/test.png'),
        )

      ),
    );
  }
}