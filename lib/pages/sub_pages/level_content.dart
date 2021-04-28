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

class LevelContent {
  final levels = [
    ['1', 'u', 'Level1'],
    ['2', 'u', 'Level2'],
    ['3', 'u', 'Level3'],
    ['4', 'u', 'Level4'],
    ['5', 'u', 'Level5'],
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

  void getWords(context, iteration, addScore, score, level, category,
      databaseTemp) async {
    print("Database: ${databaseTemp[category]}");
    print("Category: $category");

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
            if (words[k]["Deck"] == 2) {
              print(words[k]);
              tempList.add(words[k]);
              i++;
            }
          }
        }
        for (var l = 0; l < words.length; l++) {
          if (words[l] != null) {
            if (words[l]["Deck"] == 3) {
              print(words[l]);
              tempList.add(words[l]);
              i++;
            }
          }
        }
      }
      wordList = List<Map>.from(tempList);
      print(wordList);
      initiateQuiz(
          context, iteration, addScore, score, level, category, databaseTemp);
    } else {
      initiateQuiz(
          context, iteration, addScore, score, level, category, databaseTemp);
    }
  }

  void initiateQuiz(context, iteration, addScore, score, level, category,
      databaseTemp) async {
    if (iteration < 10) {
      var r = new Random();
      // int rand = 1 + r.nextInt(4 - 1);
      // if (wordList[iteration + 1]["POS"] == "Common Phrase") {
      //   if (rand == 3) {
      //     rand = 2;
      //   }
      // }
      int rand = 1;
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
        MaterialPageRoute(builder: (context) => ScorePage(score: score + 1)),
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
        if (listTemp[j]["Deck"] == 3) {
          i++;
        }
      }
    }
    print(i);
    print(i / listTemp.length);
    return i / listTemp.length;
  }
}
