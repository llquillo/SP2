import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_firebase/home_page.dart';
import '../common_widgets/page_title.dart';
import '../../home_page.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ScorePage extends StatelessWidget {
  final int score;
  final String category;
  final String level;
  var corpus;
  ScorePage({@required this.score, this.category, this.level});
  final databaseReference = FirebaseDatabase.instance.reference();
  @override
  Widget build(BuildContext context) {
    // return PageTitle(
    //   pageTitle: 'App Name',
    //   pageGreeting: 'Result:',
    //   pageChild: _pageContent(context),
    //   bgColor: Colors.white,
    // );
    return Scaffold(
        appBar: AppBar(
          title: Text("Score",
              style: GoogleFonts.robotoMono(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              )),
        ),
        body: _pageContent(context));
  }

  void updateDecks() {
    databaseReference.reference().child(category).child(level).child("Words");
  }

  Future<DataSnapshot> assignPoint(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference userDB = databaseReference.child('users').child(user.uid);
    int points;
    score > 5 ? points = 10 : points = 5;
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    String dateString = DateFormat('d MMM').format(date);
    print("Points: $points \n Date: $dateString");
    Timestamp timestamp = new Timestamp(dateString, points);
    await userDB.reference().child('Points').push().set(timestamp.toJSON());
    var pushedXP;
    await FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(user.uid)
        .reference()
        .once()
        .then((DataSnapshot snapshot) {
      print(snapshot.value);
      pushedXP = snapshot;
      return snapshot.value;
    });

    return pushedXP;
  }

  void checkStreak() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference userDB = databaseReference.child('users').child(user.uid);
    userDB.once().then((DataSnapshot snapshot) {
      corpus = snapshot.value;
    });
    DateTime now = DateTime.now();
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
    DateTime date = DateTime(now.year, now.month, now.day);
    DateTime dateYesterday =
        DateTime(yesterday.year, yesterday.month, yesterday.day);
    String dateString = DateFormat('d MMM').format(date);
    String yesterdayString = DateFormat('d MMM').format(dateYesterday);
    print("yesterday: ${corpus["Streak"]["Date"]} : $yesterdayString");
    if (corpus["Streak"]["Date"] == yesterdayString) {
      int currentStreak = corpus["Streak"]["Value"];
      currentStreak++;
      print("currentsstreak: $currentStreak");
      userDB.reference().child("Streak").child("Date").set(dateString);
      userDB.reference().child("Streak").child("Value").set(currentStreak);
      print("TROPHIES: ${corpus["Trophies"]["Streak"]}");
      print("STREAK: $currentStreak");
      if (corpus["Trophies"]["Streak"] < currentStreak) {
        userDB.reference().child("Trophies").child("Streak").set(currentStreak);
      }
    } else {
      if (corpus["Streak"]["Date"] != dateString) {
        userDB.reference().child("Streak").child("Date").set(dateString);
        userDB.reference().child("Streak").child("Value").set(1);
      }
    }
  }

  Widget _pageContent(context) {
    return DecoratedBox(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("images/stars_background.gif"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.9), BlendMode.dstATop),
        )),
        child: Container(
            // color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.fromLTRB(5, 5, 5, 20),
            padding: EdgeInsets.all(15),
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 20),
                CircularPercentIndicator(
                  radius: 180.0,
                  lineWidth: 13.0,
                  percent: score / 10,
                  center: score > 4
                      ? Image.asset(
                          'images/like.png',
                          width: 100,
                          height: 100,
                        )
                      : Image.asset(
                          'images/sad.png',
                          width: 100,
                          height: 100,
                        ),
                  backgroundColor: Colors.grey,
                  progressColor:
                      score > 4 ? Color(0xffE0FEBE) : Color(0xffF4DADA),
                ),
                SizedBox(height: 15),
                Text(
                  score > 4 ? 'Good job!' : 'Study harder! :)',
                  style: GoogleFonts.fredokaOne(
                    color: Colors.black,
                    fontSize: 38,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'You got $score/10.',
                  style: GoogleFonts.fredokaOne(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'You earned ${score > 4 ? 10 : 5} xp points!',
                  style: GoogleFonts.fredokaOne(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                MaterialButton(
                  child: Text(
                    'Okay',
                    style: GoogleFonts.robotoMono(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                  ),
                  color: Color(0xffF4F7FA),

                  //  assignPoint();
                  //   checkStreak();
                  //   Navigator.pushReplacement(context,
                  //       MaterialPageRoute(builder: (context) => HomePage()));
                  onPressed: () {
                    checkStreak();

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                    FutureBuilder(
                        future: assignPoint(context),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                            checkStreak();
                            return Container();
                          } else {
                            return Dialog(
                              backgroundColor: Colors.white,
                              child: Container(
                                color: Colors.black,
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
                              ),
                            );
                          }
                        });
                  },
                )
              ],
            )));
  }
}

class Timestamp {
  String date;
  int xp;
  // int key;

  Timestamp(this.date, this.xp);

  Timestamp.fromSnapshot(DataSnapshot snapshot)
      : date = snapshot.value["Date"],
        xp = snapshot.value["XP"];
  toJSON() {
    return {
      "Date": date,
      "XP": xp,
    };
  }
}
