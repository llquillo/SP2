import 'package:flutter/material.dart';
import './auth.dart';
import './root_page.dart';

void main() {
  runApp(new MyApp());
}

class MyColors {
  static const MaterialColor timber = MaterialColor(
    0xffd6d1cd,
    <int, Color>{
      50: Color(0xffd6d1cd),
      100: Color(0xffd6d1cd),
      200: Color(0xffd6d1cd),
      300: Color(0xffd6d1cd),
      400: Color(0xffd6d1cd),
      500: Color(0xffd6d1cd),
      600: Color(0xffd6d1cd),
      700: Color(0xffd6d1cd),
      800: Color(0xffd6d1cd),
      900: Color(0xffd6d1cd),
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Name',
      theme: new ThemeData(
        primarySwatch: MyColors.timber,
      ),
      home: new RootPage(auth: new Auth()),
    );
  }
}
