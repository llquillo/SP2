import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sample_firebase/home_page.dart';
import './login_page.dart';
import './auth.dart';
import './home_page.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;

  @override
  _RootPageState createState() => _RootPageState();
}

enum AuthStatus { notSignedIn, signedIn }

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    print("INIT STATE!!!!!!!!!");
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print('done');
      widget.auth.currentUser().then((userId) {
        setState(() {
          authStatus =
              userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
        });
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return new LoginPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        return new HomePage(
          auth: widget.auth,
          onSignedOut: _signedOut,
        );
    }
  }
}
