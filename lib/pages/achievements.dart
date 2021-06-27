import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Achievements extends StatefulWidget {
  @override
  final currentStatus;
  Achievements({@required this.currentStatus});
  _AchievementsState createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {
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
  final colors = [
    Color(0xffcce6ff),
    Color(0xffffcce6),
    Color(0xffe6ffcc),
    Color(0xffd4ccff),
    Color(0xffffd4cc),
    Color(0xfffff6cc),
  ];

  // final colors = [
  //   Color(0xffF1F8FF),
  //   Color(0xfffbf2ff),
  //   Color(0xfff2fff6),
  //   Color(0xfff2f5ff),
  //   Color(0xfffff7f0),
  //   Color(0xfffffcf0),
  // ];
  //  final colors = [
  //   Color(0xffbde0fe),
  //   Color(0xffffc8dd),
  //   Color(0xffe0febe),
  //   Color(0xffccccf6),
  //   Color(0xfffec6be),
  //   Color(0xfffef1be),
  // ];

  Widget _lockedLevel(i) {
    return Center(
        child: Stack(
      children: [
        Positioned(
          child: Opacity(
            opacity: 0.7,
            child: Image.asset(
              i,
              height: MediaQuery.of(context).size.height / 7.5,
              width: MediaQuery.of(context).size.width / 4,
            ),
          ),
        ),
        Positioned(
          child: Container(
            padding: EdgeInsets.fromLTRB(
                0, MediaQuery.of(context).size.height / 26, 0, 0),
            child: Opacity(
              opacity: .9,
              child: Image.asset(
                locked,
                color: Colors.black,
                height: MediaQuery.of(context).size.height / 12,
                width: MediaQuery.of(context).size.width / 4,
              ),
            ),
          ),
        ),
      ],
    ));
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
    final trophyList = [
      widget.currentStatus["Words"],
      widget.currentStatus["Streak"],
      widget.currentStatus["XP"],
      widget.currentStatus["Story"],
    ];

    List<List<String>> currentAchievements = [];

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
    if (widget.currentStatus["Story"] >= 1 &&
        widget.currentStatus["Story"] < 3) {
      currentAchievements.add(ribbonStory[0]);
    } else if (widget.currentStatus["Story"] >= 3 &&
        widget.currentStatus["Story"] < 5) {
      currentAchievements.add(ribbonStory[1]);
    } else if (widget.currentStatus["Story"] >= 5) {
      currentAchievements.add(ribbonStory[2]);
    } else {
      currentAchievements.add(ribbonStory[0]);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Achievements",
              style: GoogleFonts.robotoMono(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              )),
        ),
        body: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height / 30),
                DecoratedBox(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("images/trophy_background2.jpg"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.9), BlendMode.dstATop),
                    )),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.2,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.fromLTRB(
                                  MediaQuery.of(context).size.width / 18,
                                  MediaQuery.of(context).size.width / 10,
                                  MediaQuery.of(context).size.width / 18,
                                  MediaQuery.of(context).size.width / 10),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 1.2,
                              child: GridView.count(
                                crossAxisCount: 2,
                                childAspectRatio: (MediaQuery.of(context)
                                            .size
                                            .width /
                                        MediaQuery.of(context).size.height) /
                                    .79,
                                children: [
                                  ...currentAchievements.map((i) => Container(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width /
                                              12),
                                      margin: EdgeInsets.all(
                                          MediaQuery.of(context).size.width /
                                              60),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          trophyList[currentAchievements
                                                      .indexOf(i)] ==
                                                  0
                                              ? _lockedLevel(i.first)
                                              : _unlockedLevel(i.first),
                                          Text(
                                            i.last,
                                            style: GoogleFonts.robotoMono(
                                              textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.0,
                                                letterSpacing: .5,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )))
                                ],
                              )),
                        ],
                      ),
                    ))
              ],
            )));
  }
}
