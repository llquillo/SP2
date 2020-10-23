import 'package:flutter/material.dart';
import 'package:sample_firebase/auth.dart';
import './auth.dart';
import 'package:google_fonts/google_fonts.dart';
import './pages/drills.dart';
import './pages/stories.dart';
import './pages/dictionary.dart';

class HomePage extends StatelessWidget {
  HomePage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  final buttonsInfo = [
    ['images/drills.png', 'Drills'],
    ['images/stories.png', 'Stories'],
    ['images/dictionary.png', 'Dictionary'],
    ['images/progress.png', 'Progress'],
    ['images/settings.png', 'Settings']
  ];

  void _signOut() async {
    try {
      await auth.signOutUser();
      onSignedOut();
    } catch (e) {
      print('Error $e');
    }
  }

  void _switchPages(pagePicked, context) async {
    switch (pagePicked) {
      case "Drills":
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Drills()),
          );
          break;
        }
      case "Stories":
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Stories()),
          );
          break;
        }
      case "Dictionary":
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Dictionary()),
          );
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          title: new Text('App Name'),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                'Logout',
                style: new TextStyle(fontSize: 17.0, color: Colors.black),
              ),
              onPressed: _signOut,
            )
          ],
        ),
        body: new Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: new Column(
            children: [
              SizedBox(height: 40),
              new Container(
                alignment: Alignment(-0.6, 1.0),
                child: Text(
                  'Welcome back, User!',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              new Container(
                height: MediaQuery.of(context).size.height - 180,
                child: GridView.count(
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 2,
                  childAspectRatio: (MediaQuery.of(context).size.width /
                      2 /
                      (((MediaQuery.of(context).size.height) - 200) / 3)),
                  children: [
                    ...buttonsInfo.map(
                      (i) => GestureDetector(
                        onTap: () {
                          _switchPages(i.last, context);
                        },
                        child: Container(
                          width: 10,
                          margin: const EdgeInsets.all(20.0),
                          padding: EdgeInsets.fromLTRB(10, 4, 2, 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Colors.black87,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                spreadRadius: 6,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: new Text(
                                  i.last,
                                  style: GoogleFonts.playfairDisplay(
                                    textStyle: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w200,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              new Text(
                                'info',
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Image.asset(
                                i.first,
                                height: (((MediaQuery.of(context).size.height) -
                                            160) /
                                        3) -
                                    140,
                                width: (MediaQuery.of(context).size.width / 2) -
                                    140,
                                alignment: Alignment(.9, -0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
