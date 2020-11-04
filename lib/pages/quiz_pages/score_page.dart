import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_firebase/home_page.dart';
import '../common_widgets/page_title.dart';
import '../../home_page.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ScorePage extends StatelessWidget {
  final int score;
  ScorePage({@required this.score});
  @override
  Widget build(BuildContext context) {
    return PageTitle(
        pageTitle: 'App Name',
        pageGreeting: 'Result:',
        pageChild: _pageContent(context));
  }

  Widget _pageContent(context) {
    return Container(
        width: MediaQuery.of(context).size.width - 50,
        height: MediaQuery.of(context).size.height - 250,
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
              color: Colors.grey,
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            )
          ],
        ));
  }
}
