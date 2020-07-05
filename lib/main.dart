import 'package:flutter/material.dart';
import 'package:BlogApp/pages/HomePage.dart';
import 'package:BlogApp/pages/login.dart';
import 'package:BlogApp/pages/splashscreen.dart';

import 'package:BlogApp/pages/register.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.light,
        accentColor: Colors.deepOrangeAccent,
      ),
      debugShowCheckedModeBanner: false,
      home:SplashPage(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomePage(),
        '/login': (BuildContext context) => LoginPage(),
        '/register': (BuildContext context) => RegisterPage(),

      });
  }
}
