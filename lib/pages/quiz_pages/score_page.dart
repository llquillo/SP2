import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_firebase/home_page.dart';
import '../common_widgets/page_title.dart';
import '../../home_page.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScorePage extends StatelessWidget {
  final int score;
  final String category;
  final String level;
  ScorePage({@required this.score, this.category, this.level});
  final databaseReference = FirebaseDatabase.instance.reference();
  @override
  Widget build(BuildContext context) {
    return PageTitle(
        pageTitle: 'App Name',
        pageGreeting: 'Result:',
        pageChild: _pageContent(context));
  }

  void updateDecks() {
    databaseReference.reference().child(category).child(level).child("Words");
  }

  void assignPoint() {
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
    userDB.reference().child('Points').push().set(timestamp.toJSON());
  }

  Widget _pageContent(context) {
    return Container(
        width: MediaQuery.of(context).size.width - 50,
        height: MediaQuery.of(context).size.height - 200,
        margin: EdgeInsets.fromLTRB(5, 15, 5, 20),
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
          children: [
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
              progressColor: score > 4 ? Colors.green : Colors.red,
            ),
            SizedBox(height: 30),
            Text(
              score > 4 ? 'Good job!' : 'Study harder! :)',
              style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 38,
                  fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 15),
            Text(
              'You got $score/10.',
              style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 30),
            MaterialButton(
              child: Text('Okay'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.grey,
              onPressed: () {
                assignPoint();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            )
          ],
        ));
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
