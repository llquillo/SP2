import 'package:flutter/material.dart';
import 'package:sample_firebase/auth.dart';
import 'package:sample_firebase/pages/achievements.dart';
import './auth.dart';
import 'package:google_fonts/google_fonts.dart';
import './pages/stories.dart';
import './pages/dictionary.dart';
import './pages/practice.dart';
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
import 'package:overlay_support/overlay_support.dart';
import 'pages/sub_pages/profile.dart';
import 'pages/sub_pages/review_content.dart';
import 'pages/sub_pages/friends.dart';

class HomePage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  HomePage({this.auth, this.onSignedOut});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  // final buttonsInfo = [
  //   ['images/drills.png', 'Practice'],
  //   ['images/stories.png', 'Stories'],
  //   ['images/dictionary.png', 'Dictionary'],
  //   ['images/settings.png', 'Trophies']
  // ];
  final buttonsInfo = [
    ['images/practice_icon.png', 'Practice'],
    ['images/stories_icon.png', 'Stories'],
    ['images/dictionary_icon.png', 'Dictionary'],
    ['images/trophies_icon.png', 'Trophies']
  ];
  // List drillsButtons = [
  //   ["images/basic.png", "u", "basics1", "Basics 1"],
  //   ["images/shopping.png", "u", "shopping", "Shopping"],
  //   ["images/travel.png", "u", "travel", "Travel"],
  //   ["images/school.png", "u", "school", "School"],
  //   ["images/family.png", "u", "family", "Family"],
  //   ["images/basic.png", "u", "basics2", "Basics 2"],
  // ];
  List drillsButtons = [
    ["images/basics_icon.png", "u", "basics1", "Basics 1"],
    ["images/shopping_icon.png", "u", "shopping", "Shopping"],
    ["images/travel_icon.png", "l", "travel", "Travel"],
    ["images/school_icon.png", "l", "school", "School"],
    ["images/family_icon.png", "l", "family", "Family"],
    ["images/basics_icon.png", "l", "basics2", "Basics 2"],
  ];

  List levelStatus = ["1", "2", "3", "4", "5"];

  List levelSequence = ["Level1", "Level2", "Level3", "Level4", "Level5"];
  List categorySequence = [
    "basics1",
    "shopping",
    "travel",
    "school",
    "family",
    "basics2"
  ];
  String locked = "images/lock.png";

  List<String> week = new List<String>();
  List<_xpData> data = new List();
  List<_xpData> tempData = new List();
  int totalXP = 0;
  PopupMenu menu = new PopupMenu();
  PopupMenu menu2 = new PopupMenu();
  PopupMenu menu3 = new PopupMenu();
  PopupMenu menu4 = new PopupMenu();
  PopupMenu menu5 = new PopupMenu();
  PopupMenu menu6 = new PopupMenu();

  GlobalKey basics1 = new GlobalKey();
  GlobalKey basics2 = new GlobalKey();
  GlobalKey family = new GlobalKey();
  GlobalKey school = new GlobalKey();
  GlobalKey shopping = new GlobalKey();
  GlobalKey travel = new GlobalKey();

  List<GlobalKey> buttonKeys = new List<GlobalKey>();

  final databaseReference = FirebaseDatabase.instance.reference();

  LevelContent levelContent;
  ReviewContent reviewContent;

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
        resetGoalStatus();

        getWordOfTheDay();
        getcurrentXP();
        setGoalStatus("Earn");
        setGoalStatus("Quiz");
        setGoalStatus("Practice");

        checkLocks();
        checkStories();
      });
    });
    buttonKeys.add(basics1);
    buttonKeys.add(basics2);
    buttonKeys.add(family);
    buttonKeys.add(school);
    buttonKeys.add(shopping);
    buttonKeys.add(travel);
  }

  Future<void> logoutConfirm(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
              // alignment: Alignment(0, -1),
              child: Opacity(
            opacity: 0.95,
            child: AlertDialog(
              backgroundColor: Colors.white,
              actions: [
                DecoratedBox(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("images/rain_background.gif"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.9), BlendMode.dstATop),
                  )),
                  child: Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: MediaQuery.of(context).size.height / 1.6,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width / 10,
                            MediaQuery.of(context).size.width / 2.8,
                            MediaQuery.of(context).size.width / 10,
                            MediaQuery.of(context).size.width / 2.8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          border: Border.all(width: 2),
                          color: Color(0xffF1F8FF).withOpacity(.85),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width / 40),
                              child: Text("Are you sure you want to logout?",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.robotoMono(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                  )),
                            ),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                              ),
                              color: Color(0xffFFF0F7),
                              child: Text("Yes",
                                  style: GoogleFonts.robotoMono(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                  )),
                              onPressed: () {
                                _signOut();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      )),
                )
              ],
            ),
          ));
        });
  }

  void checkLocks() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference userDB = databaseReference.child('users').child(user.uid);
    for (var i = 0; i < categorySequence.length; i++) {
      bool flag = true;
      if (drillsButtons[i][1] == "u") {
        for (var j = 0; j < levelSequence.length; j++) {
          if (corpus[categorySequence[i]][levelSequence[j]] != null) {
            if (corpus[categorySequence[i]][levelSequence[j]]["LevelStatus"] ==
                1) {
              if (getPercentage(levelSequence[j], categorySequence[i]) == 1) {
                userDB
                    .reference()
                    .child(categorySequence[i])
                    .child(levelSequence[j + 1])
                    .child("LevelStatus")
                    .set(1);
              }
            } else {
              flag = false;
            }
          }
        }
      } else {
        flag = false;
      }
      if (flag && i < 4) {
        setState(() {
          drillsButtons[i + 2][1] = "u";
        });
      }
    }
  }

  Widget lockedLevel(String level, String category) {
    return Center(
        child: Stack(
      children: [
        Positioned(
          child: Opacity(
            opacity: 0.7,
            child: CircularPercentIndicator(
              radius: 25.0,
              lineWidth: 3.0,
              percent: getPercentage(level, category),
              progressColor: Color(0xffffafcc),
            ),
          ),
        ),
        Positioned(
          top: 1,
          left: .001,
          child: Opacity(
            opacity: .9,
            child: Image.asset(
              locked,
              height: MediaQuery.of(context).size.height / 30,
              width: MediaQuery.of(context).size.width / 15,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ));
  }

  Widget unlockedLevel(String level, String category) {
    return CircularPercentIndicator(
      radius: 25.0,
      lineWidth: 3.0,
      percent: getPercentage(level, category),
      progressColor: Color(0xffffafcc),
    );
  }

  void popUpMenu(int i, String category) {
    switch (i) {
      case 0:
        menu = PopupMenu(
            highlightColor: Color(0xffffafcc),
            lineColor: Color(0xffb8e3ea),
            backgroundColor: Colors.black,
            // maxColumn: 2,
            items: [
              MenuItem(
                  title: 'Level 1',
                  image: corpus["basics1"]["Level1"]["LevelStatus"] == 0
                      ? lockedLevel('Level1', 'basics1')
                      : unlockedLevel('Level1', 'basics1')),
              MenuItem(
                  title: 'Level 2',
                  image: corpus["basics1"]["Level2"]["LevelStatus"] == 0
                      ? lockedLevel('Level2', 'basics1')
                      : unlockedLevel('Level2', 'basics1')),
              MenuItem(
                  title: 'Level 3',
                  image: corpus["basics1"]["Level3"]["LevelStatus"] == 0
                      ? lockedLevel('Level3', 'basics1')
                      : unlockedLevel('Level3', 'basics1')),
              MenuItem(
                  title: 'Level 4',
                  image: corpus["basics1"]["Level4"]["LevelStatus"] == 0
                      ? lockedLevel('Level4', 'basics1')
                      : unlockedLevel('Level4', 'basics1')),
              MenuItem(
                  title: 'Level 5',
                  image: corpus["basics1"]["Level5"]["LevelStatus"] == 0
                      ? lockedLevel('Level5', 'basics1')
                      : unlockedLevel('Level5', 'basics1')),
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
            highlightColor: Color(0xffffafcc),
            lineColor: Color(0xffb8e3ea),
            backgroundColor: Colors.black,
            items: [
              MenuItem(
                  title: 'Level 1',
                  image: corpus["shopping"]["Level1"]["LevelStatus"] == 0
                      ? lockedLevel('Level1', 'shopping')
                      : unlockedLevel('Level1', 'shopping')),
              MenuItem(
                  title: 'Level 2',
                  image: corpus["shopping"]["Level2"]["LevelStatus"] == 0
                      ? lockedLevel('Level2', 'shopping')
                      : unlockedLevel('Level2', 'shopping')),
              MenuItem(
                  title: 'Level 3',
                  image: corpus["shopping"]["Level3"]["LevelStatus"] == 0
                      ? lockedLevel('Level3', 'shopping')
                      : unlockedLevel('Level3', 'shopping')),
              // MenuItem(
              //     title: 'Level 4',
              //     image: CircularPercentIndicator(
              //       radius: 25.0,
              //       lineWidth: 3.0,
              //       percent: getPercentage('Level4', 'shopping'),
              //       progressColor: Colors.green,
              //     )),
              // MenuItem(
              //     title: 'Level 5',
              //     image: CircularPercentIndicator(
              //       radius: 25.0,
              //       lineWidth: 3.0,
              //       percent: 0,
              //       progressColor: Colors.green,
              //     )),
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
      case 2:
        menu3 = PopupMenu(
            highlightColor: Color(0xffffafcc),
            lineColor: Color(0xffb8e3ea),
            backgroundColor: Colors.black,
            items: [
              MenuItem(
                  title: 'Level 1',
                  image: corpus["travel"]["Level1"]["LevelStatus"] == 0
                      ? lockedLevel('Level1', 'travel')
                      : unlockedLevel('Level1', 'travel')),
              MenuItem(
                  title: 'Level 2',
                  image: corpus["travel"]["Level2"]["LevelStatus"] == 0
                      ? lockedLevel('Level2', 'travel')
                      : unlockedLevel('Level2', 'travel')),
              MenuItem(
                  title: 'Level 3',
                  image: corpus["travel"]["Level3"]["LevelStatus"] == 0
                      ? lockedLevel('Level3', 'travel')
                      : unlockedLevel('Level3', 'travel')),
              MenuItem(
                  title: 'Level 4',
                  image: corpus["travel"]["Level4"]["LevelStatus"] == 0
                      ? lockedLevel('Level4', 'travel')
                      : unlockedLevel('Level4', 'travel')),
              // MenuItem(
              //     title: 'Level 5',
              //     image: CircularPercentIndicator(
              //       radius: 25.0,
              //       lineWidth: 3.0,
              //       percent: 0,
              //       progressColor: Colors.green,
              //     )),
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
        menu3.show(widgetKey: buttonKeys[2]);
        break;
      case 3:
        menu4 = PopupMenu(
            highlightColor: Color(0xffffafcc),
            lineColor: Color(0xffb8e3ea),
            backgroundColor: Colors.black,
            items: [
              MenuItem(
                  title: 'Level 1',
                  image: corpus["school"]["Level1"]["LevelStatus"] == 0
                      ? lockedLevel('Level1', 'school')
                      : unlockedLevel('Level1', 'school')),
              MenuItem(
                  title: 'Level 2',
                  image: corpus["school"]["Level2"]["LevelStatus"] == 0
                      ? lockedLevel('Level2', 'school')
                      : unlockedLevel('Level2', 'school')),
              MenuItem(
                  title: 'Level 3',
                  image: corpus["school"]["Level3"]["LevelStatus"] == 0
                      ? lockedLevel('Level3', 'school')
                      : unlockedLevel('Level3', 'school')),
              MenuItem(
                  title: 'Level 4',
                  image: corpus["school"]["Level4"]["LevelStatus"] == 0
                      ? lockedLevel('Level4', 'school')
                      : unlockedLevel('Level4', 'school')),
              // MenuItem(
              //     title: 'Level 5',
              //     image: CircularPercentIndicator(
              //       radius: 25.0,
              //       lineWidth: 3.0,
              //       percent: 0,
              //       progressColor: Colors.green,
              //     )),
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
        menu4.show(widgetKey: buttonKeys[3]);
        break;
      case 4:
        menu5 = PopupMenu(
            highlightColor: Color(0xffffafcc),
            lineColor: Color(0xffb8e3ea),
            backgroundColor: Colors.black,
            items: [
              MenuItem(
                  title: 'Level 1',
                  image: corpus["family"]["Level1"]["LevelStatus"] == 0
                      ? lockedLevel('Level1', 'family')
                      : unlockedLevel('Level1', 'family')),
              MenuItem(
                  title: 'Level 2',
                  image: corpus["family"]["Level2"]["LevelStatus"] == 0
                      ? lockedLevel('Level2', 'family')
                      : unlockedLevel('Level2', 'family')),
              MenuItem(
                  title: 'Level 3',
                  image: corpus["family"]["Level3"]["LevelStatus"] == 0
                      ? lockedLevel('Level3', 'family')
                      : unlockedLevel('Level3', 'family')),
              MenuItem(
                  title: 'Level 4',
                  image: corpus["family"]["Level4"]["LevelStatus"] == 0
                      ? lockedLevel('Level4', 'family')
                      : unlockedLevel('Level4', 'family')),
              // MenuItem(
              //     title: 'Level 5',
              //     image: CircularPercentIndicator(
              //       radius: 25.0,
              //       lineWidth: 3.0,
              //       percent: 0,
              //       progressColor: Colors.green,
              //     )),
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
        menu5.show(widgetKey: buttonKeys[4]);
        break;
      case 5:
        menu6 = PopupMenu(
            highlightColor: Color(0xffffafcc),
            lineColor: Color(0xffb8e3ea),
            backgroundColor: Colors.black,
            items: [
              MenuItem(
                  title: 'Level 1',
                  image: corpus["basics2"]["Level1"]["LevelStatus"] == 0
                      ? lockedLevel('Level1', 'basics2')
                      : unlockedLevel('Level1', 'basics2')),
              MenuItem(
                  title: 'Level 2',
                  image: corpus["basics2"]["Level2"]["LevelStatus"] == 0
                      ? lockedLevel('Level2', 'basics2')
                      : unlockedLevel('Level2', 'basics2')),
              MenuItem(
                  title: 'Level 3',
                  image: corpus["basics2"]["Level3"]["LevelStatus"] == 0
                      ? lockedLevel('Level3', 'basics2')
                      : unlockedLevel('Level3', 'basics2')),
              MenuItem(
                  title: 'Level 4',
                  image: corpus["basics2"]["Level4"]["LevelStatus"] == 0
                      ? lockedLevel('Level4', 'basics2')
                      : unlockedLevel('Level4', 'basics2')),
              MenuItem(
                  title: 'Level 5',
                  image: corpus["basics2"]["Level5"]["LevelStatus"] == 0
                      ? lockedLevel('Level5', 'basics2')
                      : unlockedLevel('Level5', 'basics2')),
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
        menu6.show(widgetKey: buttonKeys[5]);
        break;
    }
  }

  void stateChanged(bool isShow) {}

  void onClickMenu(MenuItemProvider item) {
    setGoalStatus("Earn");
    setGoalStatus("Quiz");
    if (item.menuTitle.toLowerCase() == "review") {
      reviewContent =
          new ReviewContent(databaseTemp: corpus[category], category: category);
      reviewContent.getWords(
          context, iteration, 0, 0, null, category, corpus[category]);
    } else {
      if (corpus[category][item.menuTitle.replaceAll(" ", "")]["LevelStatus"] !=
          0) {
        levelContent = new LevelContent(
            databaseTemp: corpus[category], category: category);
        levelContent.getWords(context, iteration, 0, 0,
            item.menuTitle.replaceAll(" ", ""), category, corpus[category]);
      }
    }
  }

  void onDismiss() {}

  // Function for getting the word of the day
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
    if (combinedCorpus[r]["POS"] == "Common Phrase") {
      getWord();
    } else {
      return combinedCorpus[r];
    }
  }

  void setWord() {
    wordDay = getWord();
  }

  int getWordsMastered() {
    int wordsCount = 0;
    var combinedCorpus = List<Map>.from(corpus["basics1"]["Level1"]["Words"]) +
        List<Map>.from(corpus["basics1"]["Level2"]["Words"]) +
        List<Map>.from(corpus["basics1"]["Level3"]["Words"]) +
        List<Map>.from(corpus["basics1"]["Level4"]["Words"]) +
        List<Map>.from(corpus["basics1"]["Level5"]["Words"]) +
        List<Map>.from(corpus["shopping"]["Level1"]["Words"]) +
        List<Map>.from(corpus["shopping"]["Level2"]["Words"]) +
        List<Map>.from(corpus["shopping"]["Level3"]["Words"]) +
        List<Map>.from(corpus["travel"]["Level1"]["Words"]) +
        List<Map>.from(corpus["travel"]["Level2"]["Words"]) +
        List<Map>.from(corpus["travel"]["Level3"]["Words"]) +
        List<Map>.from(corpus["travel"]["Level4"]["Words"]) +
        List<Map>.from(corpus["school"]["Level1"]["Words"]) +
        List<Map>.from(corpus["school"]["Level2"]["Words"]) +
        List<Map>.from(corpus["school"]["Level3"]["Words"]) +
        List<Map>.from(corpus["school"]["Level4"]["Words"]) +
        List<Map>.from(corpus["school"]["Level5"]["Words"]) +
        List<Map>.from(corpus["family"]["Level1"]["Words"]) +
        List<Map>.from(corpus["family"]["Level2"]["Words"]) +
        List<Map>.from(corpus["family"]["Level3"]["Words"]) +
        List<Map>.from(corpus["family"]["Level4"]["Words"]) +
        List<Map>.from(corpus["basics2"]["Level1"]["Words"]) +
        List<Map>.from(corpus["basics2"]["Level2"]["Words"]) +
        List<Map>.from(corpus["basics2"]["Level3"]["Words"]) +
        List<Map>.from(corpus["basics2"]["Level4"]["Words"]) +
        List<Map>.from(corpus["basics2"]["Level5"]["Words"]);

    for (var i = 0; i < combinedCorpus.length; i++) {
      if (combinedCorpus[i] != null) {
        if (combinedCorpus[i]["Deck"] == 3) {
          wordsCount++;
        }
      }
    }
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference userDB = databaseReference.child('users').child(user.uid);
    userDB.reference().child("Trophies").child("Words").set(wordsCount);
    return wordsCount;
  }

  // Function for checking the status of each story
  void checkStories() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference userDB = databaseReference.child('users').child(user.uid);
    var max = 0;
    for (var i = 0; i < 5; i++) {
      if (corpus["Stories"][i]["QuizStatus"] == 1) {
        max = i;
      }
    }
    userDB.reference().child("Trophies").child("Story").set(max + 1);
  }

  // Function for getting the percentage of each level
  double getPercentage(String level, String category) {
    var listTemp = List<Map>.from(corpus[category][level]["Words"]);
    var i = 0;
    for (var j = 0; j < listTemp.length; j++) {
      if (listTemp[j] != null) {
        if (listTemp[j]["Deck"] == 3) {
          i++;
        }
      }
    }
    return i / listTemp.length;
  }

  // Function for displaying the icon of locked levels
  Widget _lockedLevel(i) {
    return Center(
        child: Stack(
      children: [
        Positioned(
          child: Opacity(
            opacity: 0.7,
            child: Image.asset(
              i,
              height: MediaQuery.of(context).size.height / 12,
              width: MediaQuery.of(context).size.width / 4,
            ),
          ),
        ),
        Positioned(
          child: Opacity(
            opacity: .9,
            child: Image.asset(
              locked,
              height: MediaQuery.of(context).size.height / 12,
              width: MediaQuery.of(context).size.width / 4,
            ),
          ),
        ),
      ],
    ));
  }

  // Function for displaying the icon of unlocked levels
  Widget _unlockedLevel(i) {
    return Image.asset(
      i,
      height: MediaQuery.of(context).size.height / 11,
      width: MediaQuery.of(context).size.width / 6,
    );
  }

  DateTime findFirstDate(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  // Function for generating the week for the Progress Tracker
  List<String> findWeek(DateTime dateTime) {
    return List.generate(7, (index) => index)
        .map((value) => DateFormat(
              'd MMM',
            ).format(findFirstDate(dateTime).add(Duration(days: value))))
        .toList();
  }

  // Function for fetching the current user
  String currentUser() {
    User user = FirebaseAuth.instance.currentUser;
    return user.uid;
  }

  // Function for fetching the current user's email
  String getCurUserEmail() {
    User user = FirebaseAuth.instance.currentUser;
    return user.email;
  }

  // Function for initializing the corpus
  Future<void> _initCorpusDatabase(snapshot) async {
    var curUser = currentUser();
    corpus = snapshot.value;
  }

  // Function for checking the dates of the pushed points of the user to combine points with the same date
  bool checkDates(var tempData) {
    var count = 1;
    while (count < tempData.length) {
      for (var i = 0; i < tempData.length - count; i++) {
        if (tempData[i].date == tempData[i + count].date) {
          return true;
        }
      }
      count++;
    }
    return false;
  }

  //Function for fetching the user's stats in the progress page
  Future<void> _initDatabase(snapshot) async {
    Map<dynamic, dynamic> databaseTemp =
        Map<dynamic, dynamic>.from(snapshot.value["Points"]);
    databaseTemp.forEach(
        (key, value) => {tempData.add(_xpData(value["Date"], value["XP"]))});

    var flag = true;
    while (flag) {
      var count = 1;
      while (count < tempData.length) {
        for (var i = 0; i < tempData.length - count; i++) {
          if (tempData[i].date == tempData[i + count].date) {
            tempData[i].xp += tempData[i + count].xp;
            tempData.remove(tempData[i + count]);
          }
        }
        count++;
      }

      flag = checkDates(tempData);
    }
    // for (var i = 0; i < tempData.length; i++) {
    //   print("${tempData[i].date} : ${tempData[i].xp}");
    // }
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

    // for (var i = 0; i < data.length; i++) {
    //   print("${data[i].date} : ${data[i].xp}");
    // }
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference userDB = databaseReference.child('users').child(user.uid);
    userDB.reference().child("Trophies").child("XP").set(totalXP);
  }

  // Function for fetching the current XP points of the user for the day
  int getcurrentXP() {
    currentXP = 0;
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    String dateString = DateFormat('d MMM').format(date);
    // print(dateString);

    for (var j = 0; j < tempData.length; j++) {
      // print('${tempData[j].date} ${tempData[j].xp}');

      if (tempData[j].date == dateString) {
        currentXP += tempData[j].xp;
      }
    }
    // print('after: $currentXP');
  }

  void _openLevel(context, wordList, category) async {
    var currentDB = corpus[category];
  }

  // Function for getting the Word Of The Day
  void getWordOfTheDay() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference userDB = databaseReference.child('users').child(user.uid);
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    String dateString = DateFormat('d MMM').format(date);
    if (corpus["WOTD"]["Date"] != dateString) {
      userDB.reference().child("WOTD").child("Date").set(dateString);
      userDB.reference().child("WOTD").child("1").set(getWord());
      wordDay = corpus["WOTD"]["1"];
    } else {
      wordDay = corpus["WOTD"]["1"];
    }
  }

  // Function for checking the status of the user's daily goals
  void setGoalStatus(String goal) {
    Timer _timer;
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference userDB = databaseReference.child('users').child(user.uid);
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    String dateString = DateFormat('d MMM').format(date);
    if (corpus["DG"]["Date"] == dateString) {
      if (corpus["DG"][goal] == 0) {
        switch (goal) {
          case "Earn":
            if (currentXP >= 10) {
              if (corpus["DG"][goal] != 1) {
                notification("\nGoal complete: \n✓ Earned 10 XP!\n");
              }
              userDB.reference().child("DG").child(goal).set(1);
            }
            break;

          case "Quiz":
            if (currentXP >= 5) {
              if (corpus["DG"][goal] != 1) {
                notification("\nGoal complete: \n✓ Finished a quiz! \n");
              }
              userDB.reference().child("DG").child(goal).set(1);
            }
            break;
        }
      } else if (goal == "Practice" && corpus["DG"]["Practice"] == 1) {
        notification("\nGoal complete: \n✓ Practiced once! \n");
        userDB.reference().child("DG").child("Practice").set(2);
      }
    }
    userDB.once().then((DataSnapshot snapshot) {
      setState(() {
        _initCorpusDatabase(snapshot);
      });
    });
  }

  void resetGoalStatus() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference userDB = databaseReference.child('users').child(user.uid);
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    String dateString = DateFormat('d MMM').format(date);
    if (corpus["DG"]["Date"] != dateString) {
      userDB.reference().child("DG").child("Date").set(dateString);
      userDB.reference().child("DG").child("Earn").set(0);
      userDB.reference().child("DG").child("Practice").set(0);
      userDB.reference().child("DG").child("Quiz").set(0);
    }
  }

  // Template layout for the carousel slider
  Widget carouselTemplate(context, title, body) {
    return Container(
      padding: EdgeInsets.all(4),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 10, 2, 2),
              child: Text(
                title,
                style: GoogleFonts.robotoMono(
                  textStyle: TextStyle(
                    color: Colors.black,
                    letterSpacing: .3,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w900,
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

  void notification(String notif) {
    showSimpleNotification(
      Text(notif,
          textAlign: TextAlign.left,
          style: GoogleFonts.robotoMono(
              textStyle: TextStyle(
            color: Colors.black,
            fontSize: 14.0,
            fontWeight: FontWeight.w800,
          ))),
      background: Color(0xffFFAFCC),
      autoDismiss: false,
      trailing: Builder(builder: (context) {
        return FlatButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            textColor: Colors.black,
            onPressed: () {
              OverlaySupportEntry.of(context).dismiss();
            },
            child: Text('Dismiss',
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoMono(
                    textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w800,
                ))));
      }),
    );
  }

  // Function that returns the Widget to be displayed
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  getWidgetOptions(context) {
    var height = MediaQuery.of(context).size.height;

    getcurrentXP();
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;

    PopupMenu.context = context;
    String greeting;
    var time = int.parse(DateFormat('HH').format(DateTime.now()));
    if (time > 12 && time < 18) {
      greeting = "Good afternoon, \n ${corpus["Name"]}";
    } else if (time > 18) {
      greeting = "Good evening, \n ${corpus["Name"]}";
    } else {
      greeting = "Good morning, \n ${corpus["Name"]}";
    }

    // getWordOfTheDay();
    // setGoalStatus("Earn");
    // setGoalStatus("Practice");
    // setGoalStatus("Quiz");
    // resetGoalStatus();

    List<Widget> _widgetOptions = new List<Widget>();
    return _widgetOptions = <Widget>[
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

        // decoration: BoxDecoration(
        //   color: Colors.white,
        // ),
        padding: EdgeInsets.all(2),
        // width: MediaQuery.of(context).size.width,
        child: new Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 18),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height / 3.5,
                  autoPlay: true,
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
                                  style: GoogleFonts.robotoMono(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      letterSpacing: .5,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  wordDay["POS"],
                                  style: GoogleFonts.robotoMono(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      letterSpacing: .5,
                                      fontSize: 14.0,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "\"${wordDay["Translation"]}\"",
                                  style: GoogleFonts.robotoMono(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      letterSpacing: .5,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
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
                                    (corpus["DG"]["Quiz"] == 0
                                        ? Icon(Icons.check_box_outline_blank,
                                            color: Colors.black)
                                        : Icon(Icons.check_box,
                                            color: Colors.black)),
                                    SizedBox(width: 6),
                                    Text("Finish one quiz",
                                        style: GoogleFonts.robotoMono(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: Colors.black,
                                        ))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    (corpus["DG"]["Practice"] == 0
                                        ? Icon(Icons.check_box_outline_blank,
                                            color: Colors.black)
                                        : Icon(Icons.check_box,
                                            color: Colors.black)),
                                    SizedBox(width: 6),
                                    Text("Practice one time",
                                        style: GoogleFonts.robotoMono(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: Colors.black,
                                        ))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    (corpus["DG"]["Earn"] == 0
                                        ? Icon(Icons.check_box_outline_blank,
                                            color: Colors.black)
                                        : Icon(Icons.check_box,
                                            color: Colors.black)),
                                    SizedBox(width: 6),
                                    Text("Earn 10xp",
                                        style: GoogleFonts.robotoMono(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: Colors.black,
                                        ))
                                  ],
                                ),
                              ])))),
                  carouselTemplate(
                      context,
                      "Tips:",
                      Container(
                          child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(2, 10, 2, 2),
                                // color: Colors.white,
                                height: MediaQuery.of(context).size.height / 8,
                                width:
                                    MediaQuery.of(context).size.width / 2 + 55,
                                padding: EdgeInsets.fromLTRB(6, 12, 6, 6),
                                child: Text(
                                  corpus['TOTD'][0],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.robotoMono(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      letterSpacing: .5,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              )))),
                ].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          color: Color(0xffbde0fe),
                        ),
                        child: i,
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height / 5.2,
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.height / 24,
                    MediaQuery.of(context).size.height / 30,
                    0,
                    0),
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
              height: MediaQuery.of(context).size.height / 6,
              width: MediaQuery.of(context).size.width,
              child: GridView.count(
                scrollDirection: Axis.vertical,
                crossAxisCount: 4,
                childAspectRatio: (MediaQuery.of(context).size.width /
                        MediaQuery.of(context).size.height) /
                    .64,
                children: [
                  ...buttonsInfo.map(
                    (i) => GestureDetector(
                      onTap: () {
                        _setloading(context, i.last);
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(2, 5, 2, 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          // color: Color(0xfffff6cc),
                          border: Border.all(width: 2),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Color(0xfffff6cc).withOpacity(0.9),
                          //     spreadRadius: 1,
                          //     blurRadius: 3,
                          //   )
                          // ],
                        ),
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 90),
                        // padding: EdgeInsets.all(2),
                        alignment: Alignment.topCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              i.first,
                              height: MediaQuery.of(context).size.height / 10,
                              width: MediaQuery.of(context).size.width / 6.5,
                            ),
                            Text(i[1],
                                style: GoogleFonts.fredokaOne(
                                  fontSize: 10,
                                  // fontWeight: FontWeight.w900,
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
        child: Column(children: [
          Column(
            children: [
              Center(
                  child: Container(
                margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 10,
                    MediaQuery.of(context).size.width / 8,
                    MediaQuery.of(context).size.width / 10,
                    5),
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 6,
                decoration: BoxDecoration(
                  // color: Color(0xffbde0fe),
                  color: Color(0xffBFB8EA),
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
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
                // color: Colors.yellow,
                height: MediaQuery.of(context).size.height * .51,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(
                    (MediaQuery.of(context).size.width / 14.5),
                    0,
                    (MediaQuery.of(context).size.width / 14.5),
                    0),
                child: GridView.count(
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 2,
                  childAspectRatio: (MediaQuery.of(context).size.width /
                          MediaQuery.of(context).size.height) /
                      .40,
                  children: [
                    ...drillsButtons.map(
                      (i) => GestureDetector(
                        key: buttonKeys[drillsButtons.indexOf(i)],
                        onTap: () {
                          if (i[1] == "u") {
                            category = i[2];
                            popUpMenu(drillsButtons.indexOf(i), i.last);
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width / 35,
                            MediaQuery.of(context).size.width / 85,
                            MediaQuery.of(context).size.width / 35,
                            MediaQuery.of(context).size.width / 85,
                          ),
                          // margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
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
                                  fontSize: 11,
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
          SizedBox(height: MediaQuery.of(context).size.height / 20),
          Container(
            padding: EdgeInsets.all((MediaQuery.of(context).size.width / 20)),
            width: MediaQuery.of(context).size.width - 10,
            height: MediaQuery.of(context).size.height / 3.7,
            // color: Colors.yellow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width / 48),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        color: Color(0xffffc8dd),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      width: MediaQuery.of(context).size.width / 2.35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.local_fire_department,
                              color: Color(0xfffff6cc)),
                          SizedBox(width: 5),
                          Text(
                            "Streak: ",
                            style: GoogleFonts.fredokaOne(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                          ),
                          Text(
                            "${corpus["Streak"]["Value"]}",
                            style: GoogleFonts.fredokaOne(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width / 48),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        color: Color(0xffffc8dd),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(13),
                            topRight: Radius.circular(13),
                            bottomLeft: Radius.circular(13),
                            bottomRight: Radius.circular(13)),
                      ),
                      width: MediaQuery.of(context).size.width / 2.35,
                      height: MediaQuery.of(context).size.height / 7.40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.spellcheck, color: Color(0xfffff6cc)),
                          SizedBox(width: 5),
                          Text(
                            "Words: ",
                            style: GoogleFonts.fredokaOne(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                          ),
                          Text(
                            getWordsMastered().toString(),
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
                  padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 48,
                    MediaQuery.of(context).size.width / 48,
                    MediaQuery.of(context).size.width / 48,
                    MediaQuery.of(context).size.width / 7.5,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    color: Color(0xffffc8dd),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                        bottomLeft: Radius.circular(14),
                        bottomRight: Radius.circular(14)),
                  ),
                  width: MediaQuery.of(context).size.width / 2.35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(children: [
                        Icon(Icons.mood, color: Color(0xfffff6cc)),
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
          Container(
              height: MediaQuery.of(context).size.height / 2.5,
              child: SfCartesianChart(
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
                  ])),
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
            child: DecoratedBox(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("images/loading.gif"),
                  fit: BoxFit.cover,
                  // colorFilter: ColorFilter.mode(
                  //     Colors.black.withOpacity(0.9), BlendMode.dstATop),
                )),
                child: Container(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Loading...',
                        style: GoogleFonts.fredokaOne(
                          color: Colors.black,
                          fontSize: 20,
                          // fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )));
      },
    );
    new Future.delayed(new Duration(seconds: 3), () {
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
            MaterialPageRoute(
                builder: (context) => Practice(
                      corpus: corpus,
                      categorySequence: categorySequence,
                      levelSequence: levelSequence,
                      categoryInfo: drillsButtons,
                      state: true,
                    )),
          );
          break;
        }
      case "Stories":
        {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Stories(
                      stories: corpus["Stories"],
                      locks: drillsButtons,
                    )),
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
      case "Trophies":
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Achievements(currentStatus: corpus['Trophies'])));
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initCorpusDatabase(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            resizeToAvoidBottomInset: false,
            drawer: Container(
                width: MediaQuery.of(context).size.width / 1.55,
                child: Drawer(
                    child: Container(
                  color: Color(0xffF1F8FF),
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
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Profile(
                                            corpus: corpus,
                                            userEmail: getCurUserEmail(),
                                            userID: currentUser(),
                                          )),
                                ).then((value) => {
                                      setState(() {
                                        final FirebaseAuth auth =
                                            FirebaseAuth.instance;
                                        User user = auth.currentUser;
                                        final databaseReference =
                                            FirebaseDatabase.instance
                                                .reference();
                                        DatabaseReference userDB =
                                            databaseReference
                                                .child('users')
                                                .child(user.uid);
                                        userDB
                                            .once()
                                            .then((DataSnapshot snapshot) {
                                          setState(() {
                                            _initCorpusDatabase(snapshot);
                                          });
                                        });
                                      })
                                    });
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.person),
                                  SizedBox(width: 10),
                                  Text(
                                    'Profile',
                                    style: GoogleFonts.fredokaOne(
                                        letterSpacing: .5,
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
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Friends(
                                              friendList: corpus["Friends"],
                                              pendingRequest:
                                                  corpus["Requests"],
                                              userID: currentUser(),
                                            )))
                                  ..then((value) => {
                                        setState(() {
                                          final FirebaseAuth auth =
                                              FirebaseAuth.instance;
                                          User user = auth.currentUser;
                                          final databaseReference =
                                              FirebaseDatabase.instance
                                                  .reference();
                                          DatabaseReference userDB =
                                              databaseReference
                                                  .child('users')
                                                  .child(user.uid);
                                          userDB
                                              .once()
                                              .then((DataSnapshot snapshot) {
                                            setState(() {
                                              _initCorpusDatabase(snapshot);
                                            });
                                          });
                                        })
                                      });
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.people),
                                  SizedBox(width: 10),
                                  Text(
                                    'Friends',
                                    style: GoogleFonts.fredokaOne(
                                        letterSpacing: .5,
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
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onPressed: () {
                                logoutConfirm(context);
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.logout),
                                  SizedBox(width: 10),
                                  Text(
                                    'Logout',
                                    style: GoogleFonts.fredokaOne(
                                        letterSpacing: .5,
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
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              minWidth: MediaQuery.of(context).size.width,
                              highlightColor: Colors.grey[200],
                              onPressed: () {},
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
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              minWidth: MediaQuery.of(context).size.width,
                              highlightColor: Colors.grey[200],
                              onPressed: () {},
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
                            Container(
                                height:
                                    MediaQuery.of(context).size.height / 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))),
            appBar: new AppBar(
              title: new Text('Learn Bicol',
                  style: GoogleFonts.robotoMono(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  )),
              elevation: 5,
            ),
            body: DecoratedBox(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("images/home_background.jpg"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.9), BlendMode.dstATop),
                )),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: getWidgetOptions(context).elementAt(_selectedIndex),
                  ),
                )),
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
        } else {
          return Dialog(
              backgroundColor: Colors.white,
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("images/loading.gif"),
                    fit: BoxFit.cover,
                    // colorFilter: ColorFilter.mode(
                    //     Colors.black.withOpacity(0.9), BlendMode.dstATop),
                  )),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Loading...',
                          style: GoogleFonts.fredokaOne(
                            color: Colors.black,
                            fontSize: 20,
                            // fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )));
        }
      },
    );
  }
}

// Class for storing User's xp points for each finished quiz
class _xpData {
  _xpData(this.date, this.xp);
  String date;
  int xp;
}
