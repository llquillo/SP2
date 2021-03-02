import 'package:flutter/material.dart';
import './auth.dart';
import './root_page.dart';
import 'package:overlay_support/overlay_support.dart';

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
  static const MaterialColor white = MaterialColor(
    0xffffffff,
    <int, Color>{
      50: Color(0xffffffff),
      100: Color(0xffffffff),
      200: Color(0xffffffff),
      300: Color(0xffffffff),
      400: Color(0xffffffff),
      500: Color(0xffffffff),
      600: Color(0xffffffff),
      700: Color(0xffffffff),
      800: Color(0xffffffff),
      900: Color(0xffffffff),
    },
  );
}

class GreyColor {
  static const MaterialColor lightgrey = MaterialColor(
    0xffc0c0c0,
    <int, Color>{
      50: Color(0xffc0c0c0),
      100: Color(0xffc0c0c0),
      200: Color(0xffc0c0c0),
      300: Color(0xffc0c0c0),
      400: Color(0xffc0c0c0),
      500: Color(0xffc0c0c0),
      600: Color(0xffc0c0c0),
      700: Color(0xffc0c0c0),
      800: Color(0xffc0c0c0),
      900: Color(0xffc0c0c0),
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
        child: MaterialApp(
      title: 'App Name',
      theme: new ThemeData(
        primarySwatch: MyColors.white,
      ),
      home: new RootPage(auth: new Auth()),
    ));
  }
}
