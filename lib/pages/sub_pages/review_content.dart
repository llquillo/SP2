import 'package:flutter/material.dart';
import '../quiz_pages/review_multchoice.dart';
import '../quiz_pages/review_identification.dart';
import '../../home_page.dart';
import 'dart:math';

class ReviewContent {
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

  ReviewContent(
      {@required this.databaseTemp, this.wordList, @required this.category});

  final int iteration = 0;
  final int total = 6;

  void getWords(context, iteration, addScore, score, level, category,
      databaseTemp) async {
    if (wordList == null) {
      List<Map> tempList = new List<Map>();
      var words = new List<Map>();
      switch (category) {
        case 'basics1':
          words = List<Map>.from(databaseTemp["Level1"]["Words"] +
              databaseTemp["Level2"]["Words"] +
              databaseTemp["Level3"]["Words"] +
              databaseTemp["Level4"]["Words"] +
              databaseTemp["Level5"]["Words"]);
          break;
        case 'shopping':
          words = List<Map>.from(databaseTemp["Level1"]["Words"] +
              databaseTemp["Level2"]["Words"] +
              databaseTemp["Level3"]["Words"]);
          break;
        case 'travel':
          words = List<Map>.from(databaseTemp["Level1"]["Words"] +
              databaseTemp["Level2"]["Words"] +
              databaseTemp["Level3"]["Words"] +
              databaseTemp["Level4"]["Words"]);
          break;
        case 'school':
          words = List<Map>.from(databaseTemp["Level1"]["Words"] +
              databaseTemp["Level2"]["Words"] +
              databaseTemp["Level3"]["Words"] +
              databaseTemp["Level4"]["Words"]);
          break;
        case 'family':
          words = List<Map>.from(databaseTemp["Level1"]["Words"] +
              databaseTemp["Level2"]["Words"] +
              databaseTemp["Level3"]["Words"] +
              databaseTemp["Level4"]["Words"]);
          break;
      }
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
      int rand = 1 + r.nextInt(3 - 1);
      if (wordList[iteration + 1]["POS"] == "Common Phrase") {
        if (rand == 3) {
          rand = 2;
        }
      }
      switch (rand) {
        // case 1:
        //   Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => Sent(
        //               i: iteration,
        //               currentContext: context,
        //               score: score,
        //               wordList: wordList,
        //               databaseTemp: databaseTemp,
        //               level: level,
        //               category: category,
        //             )),
        //     (Route<dynamic> route) => false,
        //   );
        //   break;
        case 1:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ReviewMultipleChoice(
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
        case 2:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ReviewIdentification(
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
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
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
