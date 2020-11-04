import 'package:flutter/material.dart';
import 'package:sample_firebase/pages/common_widgets/page_title.dart';
import '../common_widgets/page_title.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../quiz_pages/multchoice.dart';
import '../quiz_pages/identification.dart';
import '../quiz_pages/score_page.dart';

class LevelContent extends StatelessWidget {
  final levels = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];

  final int iteration = 0;
  final int total = 10;

  void initiateQuiz(context, iteration, addScore, score) async {
    if (iteration < 10) {
      if (iteration % 2 == 0) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Identification(
                  i: iteration, currentContext: context, score: score)),
          (Route<dynamic> route) => false,
        );
        iteration += 1;
        score += addScore;
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MultipleChoice(
                  i: iteration, currentContext: context, score: score)),
          (Route<dynamic> route) => false,
        );
        iteration += 1;
        score += addScore;
      }
    } else {
      // ScorePage(score: score);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ScorePage(score: score)),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageTitle(
      pageTitle: "Levels",
      pageGreeting: "Level N",
      pageChild: pageContent(context),
      bgColor: Color(0xffb0c4b1),
      titleColor: Colors.white,
    );
  }

  Widget pageContent(context) {
    return Container(
      height: MediaQuery.of(context).size.height - 200,
      child: GridView.count(
        crossAxisCount: 1,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: 5,
        children: [
          ...levels.map(
            (i) => GestureDetector(
              onTap: () {
                initiateQuiz(context, iteration, 0, 0);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black87.withOpacity(0.4),
                      spreadRadius: 4,
                      blurRadius: 5,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      i,
                      style: GoogleFonts.montserrat(
                        textStyle: new TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Text(
                            "Progress",
                            style: GoogleFonts.playfairDisplay(
                              textStyle: new TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          new LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width / 3 - 10,
                            lineHeight: 4.0,
                            percent: 0,
                            backgroundColor: Colors.grey,
                            progressColor: Colors.green,
                          ),
                        ]),
                    Image.asset(
                      'images/locked.png',
                      height: 30,
                      width: 30,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
