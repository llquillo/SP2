import 'package:flutter/material.dart';
import 'package:sample_firebase/pages/common_widgets/page_title.dart';
import '../common_widgets/page_title.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../quiz_pages/multchoice.dart';
import '../quiz_pages/identification.dart';
import '../quiz_pages/score_page.dart';
import '../quiz_pages/sent.dart';
import 'dart:math';

class LevelContent extends StatelessWidget {
  final levels = [
    ['1', 'u', 'Level1'],
    ['2', 'u', 'Level2'],
    ['3', 'u', 'Level3'],
    ['4', 'l', 'Level4'],
    ['5', 'l', 'Level5'],
  ];
  // final List<Map> wordList;
  var databaseTemp;
  List<Map> wordList = new List<Map>();
  List<Map> listTemp = new List<Map>();

  String category;

  LevelContent(
      {@required this.databaseTemp, this.wordList, @required this.category});

  final int iteration = 0;
  final int total = 10;

  void getWords(context, iteration, addScore, score, level, category) async {
    if (wordList == null) {
      List<Map> tempList = new List<Map>();
      var words = new List<Map>();
      words = List<Map>.from(databaseTemp[level]["Words"]);
      listTemp = List<Map>.from(words);
      print(words);
      var i = 0;
      while (i < 11) {
        print(i);
        for (var j = 0; j < words.length; j++) {
          if (words[j] != null) {
            if (words[j]["Deck"] == 1) {
              print(words[j]);
              tempList.add(words[j]);
              i++;
            }
          }
        }
        for (var k = 0; k < words.length; k++) {
          if (words[k] != null) {
            if (words[k]["Deck"] == 1) {
              print(words[k]);
              tempList.add(words[k]);
              i++;
            }
          }
        }
        for (var l = 0; l < words.length; l++) {
          if (words[l] != null) {
            if (words[l]["Deck"] == 1) {
              print(words[l]);
              tempList.add(words[l]);
              i++;
            }
          }
        }
      }
      wordList = List<Map>.from(tempList);
      print(wordList);
    } else {
      initiateQuiz(
          context, iteration, addScore, score, level, category, databaseTemp);
    }
  }

  void initiateQuiz(context, iteration, addScore, score, level, category,
      databaseTemp) async {
    if (iteration < 10) {
      var r = new Random();

      int rand = 1 + r.nextInt(4 - 1);
      switch (rand) {
        case 1:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => Sent(
                      i: iteration,
                      currentContext: context,
                      score: score,
                      wordList: wordList,
                      databaseTemp: databaseTemp,
                      level: level,
                      category: category,
                    )),
            (Route<dynamic> route) => false,
          );
          break;
        case 2:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => MultipleChoice(
                    i: iteration,
                    currentContext: context,
                    score: score,
                    wordList: wordList,
                    databaseTemp: databaseTemp,
                    level: level,
                    category: category)),
            (Route<dynamic> route) => false,
          );
          break;
        case 3:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => Identification(
                      i: iteration,
                      currentContext: context,
                      score: score,
                      wordList: wordList,
                      databaseTemp: databaseTemp,
                      level: level,
                      category: category,
                    )),
            (Route<dynamic> route) => false,
          );
          break;
      }
      iteration += 1;
      score += addScore;
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ScorePage(score: score)),
        (Route<dynamic> route) => false,
      );
    }
  }

  double getPercentage(String level) {
    listTemp = List<Map>.from(databaseTemp[level]["Words"]);
    var i = 0;
    print(listTemp);
    for (var j = 0; j < listTemp.length; j++) {
      if (listTemp[j] != null) {
        if (listTemp[j]["Deck"] == 2) {
          i++;
        }
      }
    }
    print(i);
    print(i / listTemp.length);
    return i / listTemp.length;
  }

  @override
  Widget build(BuildContext context) {
    return PageTitle(
      pageTitle: "Levels",
      pageGreeting: "Practice!",
      pageChild: pageContent(context),
      bgColor: Colors.white,
      titleColor: Colors.red,
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
                if (i[1] == 'u') {
                  getWords(context, iteration, 0, 0, i.last, category);
                }
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
                      i.first,
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
                            percent: getPercentage(i.last),
                            backgroundColor: Colors.grey,
                            progressColor: Colors.green,
                          ),
                        ]),
                    Image.asset(
                      i.last == 'l'
                          ? 'images/locked.png'
                          : 'images/unlocked.png',
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
