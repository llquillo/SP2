import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sample_firebase/home_page.dart';
import './login_page.dart';
import './auth.dart';
import './home_page.dart';
import 'package:firebase_database/firebase_database.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;
  // FirebaseApp app;

  @override
  _RootPageState createState() => _RootPageState();
}

enum AuthStatus { notSignedIn, signedIn }

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;
  FirebaseDatabase database;

  // final databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      widget.auth.currentUser().then((userId) {
        setState(() {
          authStatus =
              userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
        });
      });
    });
    // _initializeDB();
    // databaseReference.once().then((DataSnapshot snapshot) {});
  }

  Future<void> _initializeDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    final FirebaseApp app = await Firebase.initializeApp(
        name: 'corpus',
        options: FirebaseOptions(
          appId: '1:674402710105:android:0698523e6cbbcd3ee23748',
          apiKey: 'AIzaSyCedtY1vXSXCw5l_LWgBr8nI2PBqlyB4Rc',
          projectId: 'login-demo-70531',
          databaseURL: 'https://login-demo-70531.firebaseio.com/',
          messagingSenderId: '674402710105',
        ));
    database = FirebaseDatabase(app: app);

    // databaseReference.once().then((DataSnapshot snapshot) {
    //   print('Data: ${snapshot.value}');
    // });
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
