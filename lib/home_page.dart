import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sample_firebase/auth.dart';
import './auth.dart';
import 'package:google_fonts/google_fonts.dart';
import './pages/stories.dart';
import './pages/dictionary.dart';
import './pages/practice.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'pages/sub_pages/level_content.dart';
import 'dart:math';
import 'dart:async';

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
    ["images/basic.png", "u", "basics1", "Basics 1"],
    ["images/basic.png", "l", "basics2", "Basics 2"],
    ["images/family.png", "l", "family", "Family"],
    ["images/school.png", "l", "school", "School"],
    ["images/shopping.png", "l", "shopping", "Shopping"],
    ["images/travel.png", "l", "travel", "Travel"],
  ];

  List levelStatus = ["1", "2", "3", "4", "5"];

  String locked = "images/lock.png";

  List<String> week = new List<String>();
  List<_xpData> data = new List();
  List<_xpData> tempData = new List();
  int totalXP = 0;
  PopupMenu menu = new PopupMenu();
  PopupMenu menu2 = new PopupMenu();

  GlobalKey basics1 = new GlobalKey();
  GlobalKey basics2 = new GlobalKey();
  GlobalKey family = new GlobalKey();
  GlobalKey school = new GlobalKey();
  GlobalKey shopping = new GlobalKey();
  GlobalKey travel = new GlobalKey();

  List<GlobalKey> buttonKeys = new List<GlobalKey>();

  final databaseReference = FirebaseDatabase.instance.reference();

  LevelContent levelContent;

  var corpus;
  String category;
  int iteration = 0;
  final int total = 10;
  int currentXP;
  Map wordDay;

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
        _initCorpusDatabase(snapshot);
        getcurrentXP();
      });
    });
    buttonKeys.add(basics1);
    buttonKeys.add(basics2);
    buttonKeys.add(family);
    buttonKeys.add(school);
    buttonKeys.add(shopping);
    buttonKeys.add(travel);
  }

  void popUpMenu(int i, String category) {
    switch (i) {
      case 0:
        menu = PopupMenu(
            highlightColor: Color(0xffffafcc),
            lineColor: Color(0xffa2d2ff),
            backgroundColor: Colors.black,
            maxColumn: 2,
            items: [
              MenuItem(
                  title: 'Level 1',
                  image: CircularPercentIndicator(
                    radius: 25.0,
                    lineWidth: 3.0,
                    percent: getPercentage('Level1', 'basics1'),
                    progressColor: Color(0xffffafcc),
                  )),
              MenuItem(
                  title: 'Level 2',
                  image: CircularPercentIndicator(
                    radius: 25.0,
                    lineWidth: 3.0,
                    percent: getPercentage('Level2', 'basics1'),
                    progressColor: Color(0xffffafcc),
                  )),
              MenuItem(
                  title: 'Level 3',
                  image: CircularPercentIndicator(
                    radius: 25.0,
                    lineWidth: 3.0,
                    percent: getPercentage('Level3', 'basics1'),
                    progressColor: Color(0xffffafcc),
                  )),
              MenuItem(
                  title: 'Level 4',
                  image: CircularPercentIndicator(
                    radius: 25.0,
                    lineWidth: 3.0,
                    percent: getPercentage('Level4', 'basics1'),
                    progressColor: Color(0xffffafcc),
                  )),
              MenuItem(
                  title: 'Level 5',
                  image: CircularPercentIndicator(
                    radius: 25.0,
                    lineWidth: 3.0,
                    percent: getPercentage('Level5', 'basics1'),
                    progressColor: Color(0xffffafcc),
                  )),
              MenuItem(
                  title: 'Review',
                  image: Icon(
                    Icons.power,
                    color: Colors.white,
                  )),
            ],
            onClickMenu: onClickMenu,
            stateChanged: stateChanged,
            onDismiss: onDismiss);
        menu.show(widgetKey: buttonKeys[0]);
        break;
      case 1:
        menu2 = PopupMenu(
            items: [
              MenuItem(
                  title: 'Level 1',
                  image: CircularPercentIndicator(
                    radius: 25.0,
                    lineWidth: 3.0,
                    percent: .5,
                    progressColor: Color(0xffffafcc),
                  )),
              MenuItem(
                  title: 'Level 2',
                  image: CircularPercentIndicator(
                    radius: 25.0,
                    lineWidth: 3.0,
                    percent: .5,
                    progressColor: Colors.green,
                  )),
              MenuItem(
                  title: 'Level 3',
                  image: CircularPercentIndicator(
                    radius: 25.0,
                    lineWidth: 3.0,
                    percent: .5,
                    progressColor: Colors.green,
                  )),
              MenuItem(
                  title: 'Level 4',
                  image: CircularPercentIndicator(
                    radius: 25.0,
                    lineWidth: 3.0,
                    percent: .5,
                    progressColor: Colors.green,
                  )),
              MenuItem(
                  title: 'Level 5',
                  image: CircularPercentIndicator(
                    radius: 25.0,
                    lineWidth: 3.0,
                    percent: 0,
                    progressColor: Colors.green,
                  )),
              MenuItem(
                  title: 'Review',
                  image: Icon(
                    Icons.power,
                    color: Colors.white,
                  )),
            ],
            onClickMenu: onClickMenu,
            stateChanged: stateChanged,
            onDismiss: onDismiss);
        menu2.show(widgetKey: buttonKeys[1]);
        break;
    }
  }

  void stateChanged(bool isShow) {
    print('menu is ${isShow ? 'showing' : 'closed'}');
  }

  void onClickMenu(MenuItemProvider item) {
    print("Category: $category");
    levelContent =
        new LevelContent(databaseTemp: corpus[category], category: category);
    levelContent.getWords(context, iteration, 0, 0,
        item.menuTitle.replaceAll(" ", ""), category, corpus[category]);
    print("Corpus: $corpus");
    print('Click menu -> ${item.menuTitle}');
  }

  void onDismiss() {
    print('Menu is dismiss');
  }

  Map getWord() {
    var combinedCorpus = List<Map>.from(corpus["basics1"]["Level1"]["Words"]) +
        List<Map>.from(corpus["basics1"]["Level2"]["Words"]) +
        List<Map>.from(corpus["basics1"]["Level3"]["Words"]) +
        List<Map>.from(corpus["basics1"]["Level4"]["Words"]) +
        List<Map>.from(corpus["basics1"]["Level5"]["Words"]);
    for (var i = 0; i < combinedCorpus.length; i++) {
      if (combinedCorpus[i] == null) {
        combinedCorpus.remove(combinedCorpus[i]);
      }
    }
    var rand = new Random();
    int r = 0 + rand.nextInt(combinedCorpus.length - 1);
    return combinedCorpus[r];
  }

  void setWord() {
    wordDay = getWord();
  }

  double getPercentage(String level, String category) {
    print(level);
    print(corpus);
    var listTemp = List<Map>.from(corpus[category][level]["Words"]);
    var i = 0;
    print(listTemp);
    for (var j = 0; j < listTemp.length; j++) {
      if (listTemp[j] != null) {
        if (listTemp[j]["Deck"] == 3) {
          i++;
        }
      }
    }
    print(i);
    print(i / listTemp.length);
    return i / listTemp.length;
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
          child: Opacity(
            opacity: .9,
            child: Image.asset(
              locked,
              height: 45,
              width: 45,
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

  String currentUser() {
    User user = FirebaseAuth.instance.currentUser;
    return user.uid;
  }

  Future<void> _initCorpusDatabase(snapshot) async {
    var curUser = currentUser();
    corpus = snapshot.value;
    print(corpus);
    // levelContent.getWords(context, iteration, addScore, score, level, category)
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

  int getcurrentXP() {
    currentXP = 0;
    print('before: $currentXP');
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    String dateString = DateFormat('d MMM').format(date);
    print(dateString);

    for (var j = 0; j < tempData.length; j++) {
      print('${tempData[j].date} ${tempData[j].xp}');

      if (tempData[j].date == dateString) {
        currentXP += tempData[j].xp;
      }
    }
    print('after: $currentXP');
  }

  void _openLevel(context, wordList, category) async {
    var currentDB = corpus[category];
  }

  Widget carouselTemplate(context, title, body) {
    return Container(
      // margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(4),
      // color: Colors.white,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              // color: Colors.blue[100],
              padding: EdgeInsets.fromLTRB(15, 10, 2, 2),
              child: Text(
                title,
                style: GoogleFonts.fredokaOne(
                  textStyle: TextStyle(
                    color: Colors.black,
                    letterSpacing: -.5,
                    fontSize: 16.0,
                    // fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          body,
        ],
      ),
    );
  }

  // Function that returns the Widget to be displayed
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  getWidgetOptions(context) {
    getcurrentXP();
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;

    PopupMenu.context = context;
    String greeting;
    var time = int.parse(DateFormat('HH').format(DateTime.now()));
    if (time > 12 && time < 18) {
      greeting = "Good afternoon, \n Wiqi";
    } else if (time > 18) {
      greeting = "Good evening, \n Wiqi";
    } else {
      greeting = "Good morning, \n Wiqi";
    }
    // Timer timer = new Timer(new Duration(seconds: 5), () {
    //   debugPrint("Print after 5 seconds");
    // });
    // Map wordDay = getWord();

    Timer.periodic(new Duration(seconds: 1), (timer) => setWord());

    List<Widget> _widgetOptions = new List<Widget>();
    return _widgetOptions = <Widget>[
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.all(2),
        width: MediaQuery.of(context).size.width,
        child: new Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 28),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 180.0,
                  autoPlay: false,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                ),
                items: [
                  carouselTemplate(
                      context,
                      "Word of the day:",
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          // color: Colors.white,
                          height: MediaQuery.of(context).size.height / 8 + 10,
                          width: MediaQuery.of(context).size.width / 2 + 55,
                          padding: EdgeInsets.fromLTRB(6, 12, 6, 6),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  wordDay["Word"],
                                  style: GoogleFonts.fredokaOne(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: -.5,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  wordDay["POS"],
                                  style: GoogleFonts.fredokaOne(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: -.5,
                                      fontSize: 14.0,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "\"${wordDay["Translation"]}\"",
                                  style: GoogleFonts.fredokaOne(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: -.5,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  carouselTemplate(
                      context,
                      "Daily goals:",
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              padding: EdgeInsets.fromLTRB(
                                  MediaQuery.of(context).size.width / 12,
                                  15,
                                  6,
                                  6),
                              width: MediaQuery.of(context).size.width,
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.check_box_outline_blank,
                                        color: Colors.white),
                                    SizedBox(width: 6),
                                    Text("Finish one quiz",
                                        style: GoogleFonts.fredokaOne(
                                            fontSize: 14, color: Colors.white))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.check_box_outline_blank,
                                        color: Colors.white),
                                    SizedBox(width: 6),
                                    Text("Practice one time",
                                        style: GoogleFonts.fredokaOne(
                                            fontSize: 14, color: Colors.white))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.check_box_outline_blank,
                                        color: Colors.white),
                                    SizedBox(width: 6),
                                    Text("Earn 10 XP",
                                        style: GoogleFonts.fredokaOne(
                                            fontSize: 14, color: Colors.white))
                                  ],
                                ),
                              ])))),
                  Container(
                    child: Text("Tip of the day"),
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
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          color: Color(0xffa2d2ff),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffB7DCFF).withOpacity(0.7),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(8, 8),
                            )
                          ],
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Color(0xffB7DCFF).withOpacity(0.7),
                          //     spreadRadius: 2,
                          //     blurRadius: 4,
                          //     offset: Offset(0, 4),
                          //   )
                          // ],
                        ),
                        child: i,
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height - 528,
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.fromLTRB(35, 5, 0, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    greeting,
                    style: GoogleFonts.fredokaOne(
                      textStyle: TextStyle(
                        color: Colors.black,
                        letterSpacing: -.5,
                        fontSize: 34,
                      ),
                    ),
                  ),
                )),
            Container(
              height: MediaQuery.of(context).size.height - 500,
              width: MediaQuery.of(context).size.width,
              child: GridView.count(
                scrollDirection: Axis.vertical,
                crossAxisCount: 4,
                childAspectRatio:
                    ((MediaQuery.of(context).size.height / 2) + 50) /
                        MediaQuery.of(context).size.width,
                children: [
                  ...buttonsInfo.map(
                    (i) => GestureDetector(
                      onTap: () {
                        _setloading(context, i.last);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          color: Color(0xffffc8dd),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffFFDBE9).withOpacity(0.9),
                              spreadRadius: 1,
                              blurRadius: 3,
                            )
                          ],
                        ),
                        margin: EdgeInsets.all(6),
                        padding: EdgeInsets.all(3),
                        alignment: Alignment.topCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              i.first,
                              height: (((MediaQuery.of(context).size.height) -
                                      470) /
                                  3),
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 140,
                            ),
                            Text(i[1],
                                style: GoogleFonts.fredokaOne(
                                  fontSize: 12,
                                )),
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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // color: Color(0xffE6F5F7),
        // padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Column(children: [
          ListView(
            shrinkWrap: true,
            children: [
              Center(
                  child: Container(
                margin: EdgeInsets.fromLTRB(35, 20, 35, 5),
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2 - 215,
                decoration: BoxDecoration(
                  color: Color(0xffbde0fe),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Color(0xffbde0fe).withOpacity(0.6),
                  //     spreadRadius: 3,
                  //     blurRadius: 4,
                  //     offset: Offset(0, 2),
                  //   )
                  // ],
                  // border: Border(
                  //     bottom: BorderSide(
                  //   color: Colors.black,
                  //   width: 2,
                  // )),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Daily goal:',
                          style: GoogleFonts.fredokaOne(
                            letterSpacing: .5,
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          currentXP >= 30
                              ? "You have reached your \ndaily goal!"
                              : 'Earn ${30 - currentXP} more xp to reach \nyour daily goal! ',
                          style: GoogleFonts.fredokaOne(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    CircularPercentIndicator(
                      center: Text(
                        currentXP.toString(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fredokaOne(
                          color: Colors.black,
                          fontSize: 22,
                        ),
                      ),
                      radius: 75.0,
                      lineWidth: 9.0,
                      percent: (currentXP >= 30 ? 30 : currentXP) / 30,
                      progressColor: Color(0xffffc8dd),
                      backgroundColor: Colors.black,
                    )
                  ],
                ),
              )),
              Container(
                // color: Colors.black,
                height: MediaQuery.of(context).size.height / 2 + 50,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(
                    (MediaQuery.of(context).size.width / 14),
                    0,
                    (MediaQuery.of(context).size.width / 14),
                    0),
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: GridView.count(
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 2,
                  childAspectRatio:
                      ((MediaQuery.of(context).size.height / 2) + 210) /
                          MediaQuery.of(context).size.width,
                  children: [
                    ...drillsButtons.map(
                      (i) => GestureDetector(
                        key: buttonKeys[drillsButtons.indexOf(i)],
                        onTap: () {
                          if (i[1] == "u") {
                            // _setloading(context, wordList, i.last);
                            category = i[2];
                            popUpMenu(drillsButtons.indexOf(i), i.last);
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 8, 10, 2),
                          // margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Color(0xffBFB8EA),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xffD8D2FF).withOpacity(0.7),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height / 8,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
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
                              Text(
                                i[3],
                                style: GoogleFonts.fredokaOne(
                                  letterSpacing: .5,
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
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
        ]),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xffffc8dd),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12)),
                      ),
                      width: MediaQuery.of(context).size.width / 2 - 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.local_fire_department,
                              color: Color(0xffa2d2ff)),
                          SizedBox(width: 5),
                          Text(
                            "Streak: ",
                            style: GoogleFonts.fredokaOne(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                          ),
                          Text(
                            "$totalXP",
                            style: GoogleFonts.fredokaOne(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xffffc8dd),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                      ),
                      width: MediaQuery.of(context).size.width / 2 - 30,
                      height: MediaQuery.of(context).size.height / 8 + 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.spellcheck, color: Color(0xffa2d2ff)),
                          SizedBox(width: 5),
                          Text(
                            "Words: ",
                            style: GoogleFonts.fredokaOne(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                          ),
                          Text(
                            "1000",
                            style: GoogleFonts.fredokaOne(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 50),
                  decoration: BoxDecoration(
                    color: Color(0xffffc8dd),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18)),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Color(0xffFFDBE9).withOpacity(0.9),
                    //     spreadRadius: 2,
                    //     blurRadius: 7,
                    //     offset: Offset(0, 3),
                    //   )
                    // ],
                  ),
                  width: MediaQuery.of(context).size.width / 2 - 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(children: [
                        Icon(Icons.mood, color: Color(0xffa2d2ff)),
                        SizedBox(width: 5),
                        Text(
                          "Total XP: ",
                          style: GoogleFonts.fredokaOne(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        ),
                      ]),
                      Text(
                        "$totalXP",
                        style: GoogleFonts.fredokaOne(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(
                  text: "Progress Tracker",
                  textStyle: GoogleFonts.fredokaOne(fontSize: 14)),
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

  // Function for changing tabs using the bottom nav bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Function for the loading animation
  void _setloading(context, pagePicked) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            // insetPadding: EdgeInsets.all(50),
            backgroundColor: Colors.transparent,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
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

  // Function for signing out the user
  void _signOut() async {
    try {
      await widget.auth.signOutUser();
      widget.onSignedOut();
    } catch (e) {
      print('Error $e');
    }
  }

  // Function for the row of buttons on the homepage
  void _switchPages(pagePicked, context) async {
    switch (pagePicked) {
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
            MaterialPageRoute(builder: (context) => Dictionary(corpus: corpus)),
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
      drawer: Drawer(
          child: Container(
        color: Color(0xffb8e3ea),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3 + 20,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                children: [
                  MaterialButton(
                    highlightColor: Colors.grey[200],
                    padding: EdgeInsets.all(15),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 10),
                        Text(
                          'Profile',
                          style: GoogleFonts.fredokaOne(
                              letterSpacing: 1,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    highlightColor: Colors.grey[200],
                    padding: EdgeInsets.all(15),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(Icons.settings),
                        SizedBox(width: 10),
                        Text(
                          'Settings',
                          style: GoogleFonts.fredokaOne(
                              letterSpacing: 1,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    highlightColor: Colors.grey[200],
                    padding: EdgeInsets.all(15),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onPressed: _signOut,
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 10),
                        Text(
                          'Logout',
                          style: GoogleFonts.fredokaOne(
                              letterSpacing: 1,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 0),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                children: [
                  MaterialButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minWidth: MediaQuery.of(context).size.width,
                    highlightColor: Colors.grey[200],
                    onPressed: () {
                      print("hi");
                    },
                    child: Row(
                      children: [
                        Icon(Icons.share),
                        SizedBox(width: 10),
                        Text(
                          'Tell a Friend',
                          style: GoogleFonts.fredokaOne(
                              letterSpacing: .5,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minWidth: MediaQuery.of(context).size.width,
                    highlightColor: Colors.grey[200],
                    onPressed: () {
                      print("hi");
                    },
                    child: Row(
                      children: [
                        Icon(Icons.feedback),
                        SizedBox(width: 10),
                        Text(
                          'Help and Feedback',
                          style: GoogleFonts.fredokaOne(
                              letterSpacing: .5,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Container(height: MediaQuery.of(context).size.height / 12),
                ],
              ),
            ),
          ],
        ),
      )),
      appBar: new AppBar(
        title: new Text('App Name'),
        elevation: 5,
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

// Class for storing User's xp points for each finished quiz
class _xpData {
  _xpData(this.date, this.xp);
  String date;
  int xp;
}
