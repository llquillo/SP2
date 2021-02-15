import 'package:flutter/material.dart';
import 'package:sample_firebase/auth.dart';
import './auth.dart';
import 'package:google_fonts/google_fonts.dart';
import './pages/drills.dart';
import './pages/stories.dart';
import './pages/dictionary.dart';
import './pages/progress.dart';
import './pages/practice.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  HomePage({this.auth, this.onSignedOut});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  final buttonsInfo = [
    ['images/drills.png', 'Practice'],
    ['images/stories.png', 'Stories'],
    ['images/dictionary.png', 'Dictionary'],
    ['images/settings.png', 'Settings']
  ];
  List drillsButtons = [
    ["images/basic.png", "u", "basics1"],
    ["images/basic.png", "l", "basics2"],
    ["images/family.png", "l", "family"],
    ["images/school.png", "l", "school"],
    ["images/shopping.png", "l", "shopping"],
    ["images/travel.png", "l", "travel"],
  ];

  String locked = "images/lock.png";

  List<String> week = new List<String>();
  List<_xpData> data = new List();
  List<_xpData> tempData = new List();
  int totalXP = 0;

  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference userDB = databaseReference.child('users').child(user.uid);
    userDB.once().then((DataSnapshot snapshot) {
      setState(() {
        _initDatabase(snapshot);
      });
    });
  }

  Widget _lockedLevel(i) {
    return Center(
        child: Stack(
      children: [
        Positioned(
          child: Opacity(
            opacity: 0.7,
            child: Image.asset(i),
          ),
        ),
        Positioned(
          // right: 0.2,
          child: Opacity(
            opacity: .9,
            child: Image.asset(
              locked,
              height: 50,
              width: 50,
            ),
          ),
        ),
      ],
    ));
  }

  Widget _unlockedLevel(i) {
    return Image.asset(i);
  }

  DateTime findFirstDate(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  List<String> findWeek(DateTime dateTime) {
    return List.generate(7, (index) => index)
        .map((value) => DateFormat(
              'd MMM',
            ).format(findFirstDate(dateTime).add(Duration(days: value))))
        .toList();
  }

  Future<void> _initDatabase(snapshot) async {
    Map<dynamic, dynamic> databaseTemp =
        Map<dynamic, dynamic>.from(snapshot.value["Points"]);
    databaseTemp.forEach(
        (key, value) => {tempData.add(_xpData(value["Date"], value["XP"]))});

    var i = 0;
    while (i < tempData.length - 1) {
      print(tempData[i].date);
      if (tempData[i].date == tempData[i + 1].date) {
        tempData[i].xp += tempData[i + 1].xp;
        tempData.remove(tempData[i + 1]);
        i = 0;
      } else {
        i++;
      }
    }
    for (var i = 0; i < tempData.length; i++) {
      print("${tempData[i].date} : ${tempData[i].xp}");
    }
    for (var j = 0; j < tempData.length; j++) {
      totalXP += tempData[j].xp;
    }
    DateTime today = DateTime.now();
    week = findWeek(today);
    for (var j = 0; j < week.length; j++) {
      bool flag = false;
      for (var k = 0; k < tempData.length; k++) {
        if (tempData[k].date == week[j]) {
          data.add(_xpData(week[j], tempData[k].xp));
          flag = true;
        }
      }
      if (!flag) {
        data.add(_xpData(week[j], 0));
      }
    }

    for (var i = 0; i < data.length; i++) {
      print("${data[i].date} : ${data[i].xp}");
    }
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  getWidgetOptions(context) {
    String greeting;
    var time = int.parse(DateFormat('HH').format(DateTime.now()));
    if (time > 12 && time < 18) {
      greeting = "Good afternoon, \n Wiqi";
    } else if (time > 18) {
      greeting = "Good evening, \n Wiqi";
    } else {
      greeting = "Good morning, \n Wiqi";
    }
    List<Widget> _widgetOptions = new List<Widget>();
    return _widgetOptions = <Widget>[
      Container(
        decoration: BoxDecoration(
          gradient: new LinearGradient(
            colors: [
              Color(0xffF3F3F3),
              Color(0xffF3F3F3),
              Color(0xffFFE085),
              Color(0xffFFE085)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, 0.27, 0.28, 1],
          ),
        ),
        padding: EdgeInsets.all(2),
        // color: Color(0xffF3F3F3),
        width: MediaQuery.of(context).size.width,
        child: new Column(
          children: [
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 180.0,
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                ),
                items: [
                  Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(4),
                    // color: Colors.white,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            color: Colors.yellow[200],
                            padding: EdgeInsets.all(3),
                            child: Text(
                              "Word of the day:",
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  letterSpacing: -.5,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: MediaQuery.of(context).size.height / 8 + 10,
                            width: MediaQuery.of(context).size.width / 2 + 55,
                            padding: EdgeInsets.fromLTRB(18, 4, 6, 6),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Kumusta",
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        letterSpacing: -.5,
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Exclamation",
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        letterSpacing: -.5,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "Translation: Hello",
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        letterSpacing: -.5,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Text("Word of the day"),
                  ),
                  Container(
                    child: Text("Word of the day"),
                  ),
                  Container(
                    child: Text("Word of the day"),
                  ),
                  Container(
                    child: Text("Word of the day"),
                  )
                ].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          // color: Color(0xffFFE085),
                          color: Colors.white,
                          // gradient: new LinearGradient(
                          //   colors: [
                          //     Colors.white,
                          //     Colors.white,
                          //     Color(0xffFFE085),
                          //     Color(0xffFFE085),
                          //   ],
                          //   begin: Alignment.center,
                          //   end: Alignment.bottomCenter,
                          //   stops: [0, 0.65, 0.65, 1],
                          // ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45.withOpacity(0.6),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(8, 8),
                            )
                          ],
                        ),
                        child: i,
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height - 500,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    greeting,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: Colors.black,
                        letterSpacing: -.5,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                )),
            Container(
              padding: EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height - 530,
              width: MediaQuery.of(context).size.width,
              child: GridView.count(
                scrollDirection: Axis.vertical,
                crossAxisCount: 4,
                childAspectRatio: 1.8,
                children: [
                  ...buttonsInfo.map(
                    (i) => GestureDetector(
                      onTap: () {
                        _setloading(context, i.last);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              i.first,
                              height: (((MediaQuery.of(context).size.height) -
                                      380) /
                                  3),
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 140,
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
      ),
      Container(
        padding: const EdgeInsets.all(13),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 200,
        child: new Container(
          height: MediaQuery.of(context).size.height - 180,
          child: GridView.count(
            scrollDirection: Axis.vertical,
            crossAxisCount: 1,
            childAspectRatio: 3.5,
            children: [
              ...drillsButtons.map(
                (i) => GestureDetector(
                  onTap: () {
                    if (i[1] == "u") {
                      // _setloading(context, wordList, i.last);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    // color: Color(0xffFFE085),
                    decoration: BoxDecoration(
                      color: Color(0xffFFE085),
                      // border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 10,
                          margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: i[1] == 'u'
                                    ? _unlockedLevel(i.first)
                                    : _lockedLevel(i.first),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(8, 10, 8, 10),
                          height: MediaQuery.of(context).size.height / 6,
                          width: MediaQuery.of(context).size.width / 2 + 10,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 10,
              height: MediaQuery.of(context).size.height / 3 - 40,
              // color: Colors.yellow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      // color: Color(0xffFFE085),
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25)),
                    ),
                    width: MediaQuery.of(context).size.width - 160,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.local_fire_department,
                            color: Color(0xffFFE085)),
                        SizedBox(width: 10),
                        Text(
                          "Streak: ",
                          style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                        Text(
                          "$totalXP",
                          style: GoogleFonts.montserrat(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      // color: Color(0xffFFE085),
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25)),
                    ),
                    width: MediaQuery.of(context).size.width - 160,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.mood, color: Color(0xffFFE085)),
                        SizedBox(width: 10),
                        Text(
                          "Total XP: ",
                          style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                        Text(
                          "$totalXP",
                          style: GoogleFonts.montserrat(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      // color: Color(0xffFFE085),
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25)),
                    ),
                    width: MediaQuery.of(context).size.width - 160,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.spellcheck, color: Color(0xffFFE085)),
                        SizedBox(width: 10),
                        Text(
                          "Words: ",
                          style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                        Text(
                          "1000",
                          style: GoogleFonts.montserrat(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(text: "Progress Tracker"),
              legend: Legend(isVisible: false),
              series: <ChartSeries<_xpData, String>>[
                LineSeries<_xpData, String>(
                    dataSource: data,
                    xValueMapper: (_xpData point, _) => point.date,
                    yValueMapper: (_xpData point, _) => point.xp,
                    name: "xp",
                    dataLabelSettings: DataLabelSettings(isVisible: false))
              ]),
        ],
      )
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _setloading(context, pagePicked) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            insetPadding: EdgeInsets.all(50),
            backgroundColor: Colors.transparent,
            child: Container(
              height: MediaQuery.of(context).size.height / 5 - 20,
              width: MediaQuery.of(context).size.width / 2 - 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpinKitChasingDots(
                    size: 40,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Loading',
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ));
      },
    );
    new Future.delayed(new Duration(seconds: 2), () {
      Navigator.pop(context);
      _switchPages(pagePicked, context);
    });
  }

  void _signOut() async {
    try {
      await widget.auth.signOutUser();
      widget.onSignedOut();
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
      case "Practice":
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Practice()),
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
      case "Progress":
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Progress()),
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
      body: Center(
        child: getWidgetOptions(context).elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Drills',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Progress',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xffb8e3ea),
        onTap: _onItemTapped,
      ),
    );
  }
}

class _xpData {
  _xpData(this.date, this.xp);
  String date;
  int xp;
}
