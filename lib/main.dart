import 'package:flutter/material.dart';
import './auth.dart';
import './root_page.dart';

void main() {
  runApp(new MyApp());
}

class MyColors {
  static const MaterialColor paleBlue = MaterialColor(
    0xffb8e3ea,
    <int, Color>{
      50: Color(0xffb8e3ea),
      100: Color(0xffb8e3ea),
      200: Color(0xffb8e3ea),
      300: Color(0xffb8e3ea),
      400: Color(0xffb8e3ea),
      500: Color(0xffb8e3ea),
      600: Color(0xffb8e3ea),
      700: Color(0xffb8e3ea),
      800: Color(0xffb8e3ea),
      900: Color(0xffb8e3ea),
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Name',
      theme: new ThemeData(
        primarySwatch: MyColors.paleBlue,
      ),
      home: new RootPage(auth: new Auth()),
    );
  }
}
