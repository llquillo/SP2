import 'package:flutter/material.dart';
import '../common_widgets/page_title.dart';
import '../common_widgets/quiz_template.dart';

import 'package:google_fonts/google_fonts.dart';
import '../sub_pages/level_content.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Identification extends StatefulWidget {
  final int i;
  final BuildContext currentContext;
  final int score;
  final List<Map> wordList;
  final databaseTemp;

  final String level;
  final String category;
  Identification(
      {@required this.i,
      @required this.currentContext,
      this.levelContent,
      this.score,
      this.wordList,
      this.databaseTemp,
      this.level,
      this.category});
  final LevelContent levelContent;

  @override
  _IdentificationState createState() => _IdentificationState();
}

class _IdentificationState extends State<Identification> {
  TextEditingController answerController = new TextEditingController();
  LevelContent levelContent;
  String correctAnswer;
  String userAnswer;

  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    print(widget.wordList);
    levelContent = new LevelContent(
        databaseTemp: widget.databaseTemp,
        wordList: widget.wordList,
        category: widget.category);
  }

  @override
  Widget build(BuildContext context) {
    // levelContent = new LevelContent(wordList: widget.wordList);
    var answerSet = widget.wordList[widget.i - 1];
    correctAnswer = answerSet['Translation'];
    return QuizTemplate(
      pageTitle: "Drills",
      pageGreeting: "Question ${(widget.i)}",
      // pageChild: _pageContent(context, correctAnswer, answerSet),
      quizStatus: widget.i / 10,
      pageChildUpper: _pageUpper(context, answerSet),
      pageChildLower: _pageLower(context, correctAnswer, answerSet),
      bgColor: Colors.white,
      titleColor: Colors.black,
    );
  }

  Widget correctAnswerValidation(BuildContext context, String correctAnswer) {
    var currentDeck;
    var currentDeckIndex;
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference userDB = databaseReference.child('users').child(user.uid);
    for (var i = 0;
        i < widget.databaseTemp[widget.level]["Words"].length;
        i++) {
      if (widget.databaseTemp[widget.level]["Words"][i] != null) {
        if (widget.databaseTemp[widget.level]["Words"][i]['Translation'] ==
            correctAnswer) {
          currentDeckIndex = i;
          currentDeck = widget.databaseTemp[widget.level]["Words"][i]["Deck"];
        }
      }
    }

    switch (currentDeck) {
      case 1:
        userDB
            .reference()
            .child(widget.category)
            .child(widget.level)
            .child("Words")
            .child(currentDeckIndex.toString())
            .child("Deck")
            .set(2);
        break;
      case 2:
        userDB
            .reference()
            .child(widget.category)
            .child(widget.level)
            .child("Words")
            .child(currentDeckIndex.toString())
            .child("Deck")
            .set(3);
        break;
      case 3:
        userDB
            .reference()
            .child(widget.category)
            .child(widget.level)
            .child("Words")
            .child(currentDeckIndex.toString())
            .child("Deck")
            .set(3);
        break;
    }
    return AlertDialog(
      backgroundColor: Color(0xffdef2c8),
      title: Text(
        'You are correct!',
        style: GoogleFonts.fredokaOne(
          color: Colors.black,
          fontSize: 22,
        ),
      ),
      content: Text(
        'The correct answer is: $correctAnswer',
        style: GoogleFonts.fredokaOne(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            levelContent.initiateQuiz(
                widget.currentContext,
                widget.i,
                1,
                widget.score,
                widget.level,
                widget.category,
                widget.databaseTemp);
          },
          child: Text("Next",
              style: GoogleFonts.fredokaOne(
                fontSize: 16,
                decoration: TextDecoration.underline,
              )),
        )
      ],
    );
  }

  Widget incorrectAnswerValidation(BuildContext context, String correctAnswer) {
    var currentDeck;
    var currentDeckIndex;
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference userDB = databaseReference.child('users').child(user.uid);
    for (var i = 0;
        i < widget.databaseTemp[widget.level]["Words"].length;
        i++) {
      if (widget.databaseTemp[widget.level]["Words"][i] != null) {
        if (widget.databaseTemp[widget.level]["Words"][i]['Translation'] ==
            correctAnswer) {
          currentDeckIndex = i;
          currentDeck = widget.databaseTemp[widget.level]["Words"][i]["Deck"];
        }
      }
    }
    if (currentDeck == 3) {
      userDB
          .reference()
          .child(widget.category)
          .child(widget.level)
          .child("Words")
          .child(currentDeckIndex.toString())
          .child("Deck")
          .set(2);
    }
    return AlertDialog(
      backgroundColor: Color(0xffedafb8),
      title: Text(
        'You are incorrect!',
        style: GoogleFonts.fredokaOne(
          color: Colors.black,
          fontSize: 22,
        ),
      ),
      content: Text(
        'The correct answer is: $correctAnswer',
        style: GoogleFonts.fredokaOne(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            levelContent.initiateQuiz(
                widget.currentContext,
                widget.i,
                0,
                widget.score,
                widget.level,
                widget.category,
                widget.databaseTemp);
          },
          child: Text("Next",
              style: GoogleFonts.fredokaOne(
                fontSize: 16,
                decoration: TextDecoration.underline,
              )),
        )
      ],
    );
  }

  Future<void> _quizValidation() async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Container(
              alignment: Alignment(0, -1),
              child: Opacity(
                  opacity: 0.85,
                  child: answerController.text.toLowerCase() ==
                          correctAnswer.toLowerCase()
                      ? correctAnswerValidation(context, correctAnswer)
                      : incorrectAnswerValidation(context, correctAnswer)));
        });
  }

  Widget _pageUpper(context, answerSet) {
    return Column(
      children: [
        Container(
            padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
            height: MediaQuery.of(context).size.height / 16,
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: Colors.yellow,
                ),
                Text(
                  "Translate the word/phrase given",
                  style: GoogleFonts.fredokaOne(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            )),
        Container(
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 5,
          child: Center(
            child: Text(
              answerSet['Word'],
              style: GoogleFonts.fredokaOne(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _pageLower(context, correctAnswer, answerSet) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 15),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20)),
        // color: Color(0xffFFE8F0),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(40),
            width: MediaQuery.of(context).size.width / 1.5,
            child: TextField(
              cursorColor: Colors.black,
              controller: answerController,
              textAlign: TextAlign.center,
              style: GoogleFonts.fredokaOne(color: Colors.black),
            ),
          ),
          Container(
            // margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width / 3 - 20,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.all(10),
              color: Color(0xffFFAFCC),
              onPressed: () {
                _quizValidation();
              },
              child: Text(
                "Submit",
                style: GoogleFonts.fredokaOne(
                  textStyle: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
