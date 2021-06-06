import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class FriendPage extends StatefulWidget {
  final uid;
  final name;
  final points;
  final currentStatus;
  FriendPage({this.uid, this.name, this.points, this.currentStatus});
  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  List<_xpData> data = new List();
  List<_xpData> tempData = new List();
  List<String> week = new List<String>();
  int totalXP;
  List<List<String>> currentAchievements = [];

  final wordsTrophy = [
    ["images/10words.png", "10 words"],
    ["images/50words.png", "50 words"],
    ["images/100words.png", "100 words"],
    ["images/200words.png", "200 words"],
    ["images/300words.png", "300 words"],
    ["images/400words.png", "400 words"],
    ["images/500words.png", "500 words"],
    ["images/600words.png", "600 words"],
    ["images/700words.png", "700 words"]
  ];
  final streakCertf = [
    ["images/3days.png", "3 days"],
    ["images/5days.png", "5 days"],
    ["images/7days.png", "7 days"],
    ["images/15days.png", "15 days"],
    ["images/30days.png", "30 days"],
  ];
  final ribbonStory = [
    ["images/medal.png", "1 story"],
    ["images/medal.png", "2 stories"],
    ["images/medal.png", "3 stories"],
  ];

  final plaqueXP = [
    ["images/10xp.png", "10 xp"],
    ["images/100xp.png", "100 xp"],
    ["images/500xp.png", "500 xp"],
    ["images/1000xp.png", "1000 xp"],
    ["images/3000xp.png", "3000 xp"],
    ["images/5000xp.png", "5000 xp"],
    ["images/10000xp.png", "10000 xp"]
  ];
  String locked = "images/lock.png";

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

  bool checkDates(var tempData) {
    var count = 1;
    while (count < tempData.length) {
      for (var i = 0; i < tempData.length - count; i++) {
        print(tempData[i].date);
        if (tempData[i].date == tempData[i + count].date) {
          return true;
        }
      }
      count++;
    }
    return false;
  }

  void getAchievements() {
    currentAchievements = [];

    print(widget.currentStatus);
    if (widget.currentStatus["Words"] >= 10 &&
        widget.currentStatus["Words"] < 50) {
      currentAchievements.add(wordsTrophy[0]);
    } else if (widget.currentStatus["Words"] >= 50 &&
        widget.currentStatus["Words"] < 100) {
      currentAchievements.add(wordsTrophy[1]);
    } else if (widget.currentStatus["Words"] >= 100 &&
        widget.currentStatus["Words"] < 200) {
      currentAchievements.add(wordsTrophy[2]);
    } else if (widget.currentStatus["Words"] >= 200 &&
        widget.currentStatus["Words"] < 300) {
      currentAchievements.add(wordsTrophy[3]);
    } else if (widget.currentStatus["Words"] >= 300 &&
        widget.currentStatus["Words"] < 400) {
      currentAchievements.add(wordsTrophy[4]);
    } else if (widget.currentStatus["Words"] >= 400 &&
        widget.currentStatus["Words"] < 500) {
      currentAchievements.add(wordsTrophy[5]);
    } else if (widget.currentStatus["Words"] >= 500 &&
        widget.currentStatus["Words"] < 600) {
      currentAchievements.add(wordsTrophy[6]);
    } else if (widget.currentStatus["Words"] >= 600 &&
        widget.currentStatus["Words"] < 700) {
      currentAchievements.add(wordsTrophy[7]);
    } else if (widget.currentStatus["Words"] == 700) {
      currentAchievements.add(wordsTrophy[8]);
    } else {
      currentAchievements.add(wordsTrophy[0]);
    }
    if (widget.currentStatus["Streak"] >= 3 &&
        widget.currentStatus["Streak"] < 5) {
      currentAchievements.add(streakCertf[0]);
    } else if (widget.currentStatus["Streak"] >= 5 &&
        widget.currentStatus["Streak"] < 7) {
      currentAchievements.add(streakCertf[1]);
    } else if (widget.currentStatus["Streak"] >= 7 &&
        widget.currentStatus["Streak"] < 15) {
      currentAchievements.add(streakCertf[2]);
    } else if (widget.currentStatus["Streak"] >= 15 &&
        widget.currentStatus["Streak"] < 30) {
      currentAchievements.add(streakCertf[3]);
    } else if (widget.currentStatus["Streak"] == 30) {
      currentAchievements.add(streakCertf[4]);
    } else {
      currentAchievements.add(streakCertf[0]);
    }
    if (widget.currentStatus["XP"] >= 10 && widget.currentStatus["XP"] < 100) {
      currentAchievements.add(plaqueXP[0]);
    } else if (widget.currentStatus["XP"] >= 100 &&
        widget.currentStatus["XP"] < 500) {
      currentAchievements.add(plaqueXP[1]);
    } else if (widget.currentStatus["XP"] >= 500 &&
        widget.currentStatus["XP"] < 1000) {
      currentAchievements.add(plaqueXP[2]);
    } else if (widget.currentStatus["XP"] >= 1000 &&
        widget.currentStatus["XP"] < 3000) {
      currentAchievements.add(plaqueXP[3]);
    } else if (widget.currentStatus["XP"] >= 3000 &&
        widget.currentStatus["XP"] < 5000) {
      currentAchievements.add(plaqueXP[4]);
    } else if (widget.currentStatus["XP"] >= 5000 &&
        widget.currentStatus["XP"] < 10000) {
      currentAchievements.add(plaqueXP[5]);
    } else if (widget.currentStatus["XP"] == 10000) {
      currentAchievements.add(plaqueXP[6]);
    } else {
      currentAchievements.add(plaqueXP[0]);
    }

    currentAchievements.add(ribbonStory[0]);
  }

  void getPoints() {
    tempData = [];
    data = [];
    Map<dynamic, dynamic> databaseTemp =
        Map<dynamic, dynamic>.from(widget.points);
    databaseTemp.forEach(
        (key, value) => {tempData.add(_xpData(value["Date"], value["XP"]))});

    var flag = true;
    while (flag) {
      var count = 1;
      while (count < tempData.length) {
        for (var i = 0; i < tempData.length - count; i++) {
          print(tempData[i].date);
          if (tempData[i].date == tempData[i + count].date) {
            tempData[i].xp += tempData[i + count].xp;
            tempData.remove(tempData[i + count]);
          }
        }
        count++;
      }

      flag = checkDates(tempData);
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
  }

  Widget _unlockedLevel(i) {
    return Image.asset(
      i,
      height: MediaQuery.of(context).size.height / 5,
      width: MediaQuery.of(context).size.width / 3,
    );
  }

  @override
  Widget build(BuildContext context) {
    getPoints();
    getAchievements();
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.name}'s Progress"),
      ),
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 20),
              Text("${widget.name}'s Achievements",
                  style: GoogleFonts.robotoMono(
                      textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                  ))),
              // SizedBox(height: MediaQuery.of(context).size.height / 30),
              Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 20),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3.8,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: GridView.count(
                    crossAxisCount: 4,
                    childAspectRatio: (MediaQuery.of(context).size.width /
                            MediaQuery.of(context).size.height) /
                        .97,
                    children: [
                      ...currentAchievements.map((i) => Container(
                          margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _unlockedLevel(i.first),
                              Text(
                                i.last,
                                style: GoogleFonts.robotoMono(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.0,
                                    letterSpacing: .5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          )))
                    ],
                  )),
              Text("${widget.name}'s Progress Tracker",
                  style: GoogleFonts.robotoMono(
                      textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                  ))),
              Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      legend: Legend(isVisible: false),
                      series: <ChartSeries<_xpData, String>>[
                        LineSeries<_xpData, String>(
                            dataSource: data,
                            xValueMapper: (_xpData point, _) => point.date,
                            yValueMapper: (_xpData point, _) => point.xp,
                            name: "xp",
                            dataLabelSettings:
                                DataLabelSettings(isVisible: false))
                      ])),
            ],
          ),
        ),
      ),
    );
  }
}

class _xpData {
  _xpData(this.date, this.xp);
  String date;
  int xp;
}
