import 'package:flutter/material.dart';
import '../common_widgets/page_title.dart';
import '../common_widgets/quiz_template.dart';
import '../sub_pages/level_content.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MultipleChoice extends StatefulWidget {
  final int i;
  final BuildContext currentContext;
  final int score;
  final List<Map> wordList;
  final databaseTemp;

  final String level;
  final String category;
  var rng = new Random();

  MultipleChoice(
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
  _MultipleChoiceState createState() => _MultipleChoiceState();
}

class _MultipleChoiceState extends State<MultipleChoice> {
  String correctAnswer;
  LevelContent levelContent;
  List<String> choices;
  String choice1, choice2, choice3;

  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    levelContent = new LevelContent(
      databaseTemp: widget.databaseTemp,
      wordList: widget.wordList,
      category: widget.category,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<int> usedNum = List<int>();
    print(widget.wordList);
    int current = widget.i - 1;
    print(current);
    usedNum.add(current);
    var answerSet = widget.wordList[widget.i - 1];
    correctAnswer = answerSet['Translation'];
    choice1 = getChoice(usedNum);
    choice2 = getChoice(usedNum);
    choice3 = getChoice(usedNum);
    choices = [correctAnswer, choice1, choice2, choice3];
    choices.shuffle();

    return QuizTemplate(
      pageTitle: "Drills",
      pageGreeting: "Question ${(widget.i)}",
      pageChildUpper: _pageUpper(context, answerSet),
      pageChildLower: _pageLower(context, correctAnswer, answerSet),
      quizStatus: widget.i / 10,
      bgColor: Colors.white,
      titleColor: Colors.blue,
    );
  }

  String getChoice(List<int> usedNum) {
    print("getChoice");
    var rng = new Random();
    int tempNum;
    while (true) {
      bool flag = true;
      tempNum = rng.nextInt(9);
      for (var i = 0; i < usedNum.length; i++) {
        if (tempNum == usedNum[i]) {
          flag = false;
        }
      }
      if (flag) {
        usedNum.add(tempNum);
        break;
      }
    }
    return widget.wordList[tempNum]['Translation'];
  }

  Widget correctAnswerValidation(BuildContext context, String correctAnswer) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference userDB = databaseReference.child('users').child(user.uid);
    var currentDeck = widget.wordList[widget.i - 1]["Deck"];
    print(currentDeck);
    print(widget.wordList[widget.i - 1]["Translation"]);
    // userDB.orderByChild('title')
    //     .equalTo('one2three')
    //      .once('value')
    //      .then(function(snapshot){
    //         var value = snapshot.val()
    //         if(value){
    //         var key = Object.keys(value)[0];
    switch (currentDeck) {
      case 1:
        userDB
            .reference()
            .child(widget.category)
            .child(widget.level)
            .child("Words")
            .child(widget.i.toString())
            .child("Deck")
            .set(2);
        break;
      case 2:
        userDB
            .reference()
            .child(widget.category)
            .child(widget.level)
            .child("Words")
            .child(widget.i.toString())
            .child("Deck")
            .set(3);
        break;
      case 3:
        userDB
            .reference()
            .child(widget.category)
            .child(widget.level)
            .child("Words")
            .child(widget.i.toString())
            .child("Deck")
            .set(3);
        break;
    }
    // userDB
    //     .reference()
    //     .child(widget.category)
    //     .child(widget.level)
    //     .child("Words")
    //     .child(widget.i.toString())
    //     .child("Deck")
    //     .set(2);
    return AlertDialog(
      backgroundColor: Color(0xffdef2c8),
      title: Text(
        'You are correct!',
        style: GoogleFonts.montserrat(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        'The correct answer is $correctAnswer',
        style: GoogleFonts.montserrat(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400,
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
          child: Text("Next"),
        )
      ],
    );
  }

  Widget incorrectAnswerValidation(BuildContext context, String correctAnswer) {
    return AlertDialog(
      backgroundColor: Color(0xffedafb8),
      title: Text(
        'You are incorrect!',
        style: GoogleFonts.montserrat(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        'The correct answer is $correctAnswer',
        style: GoogleFonts.montserrat(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400,
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
          child: Text("Next"),
        )
      ],
    );
  }

  Future<void> _quizValidation(String userAnswer) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
            alignment: Alignment(0, -1),
            child: Opacity(
                opacity: 0.85,
                child: userAnswer == correctAnswer
                    ? correctAnswerValidation(context, correctAnswer)
                    : incorrectAnswerValidation(context, correctAnswer)));
      },
    );
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
      margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
      width: MediaQuery.of(context).size.width / 2 + 200,
      height: MediaQuery.of(context).size.height / 4 + 60,
      child: GridView.count(
        mainAxisSpacing: 5,
        crossAxisSpacing: 10,
        childAspectRatio: 2.1,
        crossAxisCount: 2,
        children: [
          ...choices.map((i) => Container(
                margin: EdgeInsets.all(10),
                child: RaisedButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.all(10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                    ),
                    color: Color(0xffFFC8DD),
                    onPressed: () {
                      _quizValidation(i);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            i,
                            style: GoogleFonts.fredokaOne(
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    )),
              ))
        ],
      ),
    );
  }

  Widget _pageContent(context, correctAnswer, answerSet) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: MediaQuery.of(context).size.height - 150,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              color: Color(0xffF1F8FF),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4 + 20,
          ),
          SizedBox(height: 7),
          Container(
            // color: Colors.red,
            margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
            width: MediaQuery.of(context).size.width / 2 + 200,
            height: MediaQuery.of(context).size.height / 4 + 60,
            child: GridView.count(
              mainAxisSpacing: 5,
              crossAxisSpacing: 10,
              childAspectRatio: 2.1,
              crossAxisCount: 2,
              children: [
                ...choices.map((i) => Container(
                      margin: EdgeInsets.all(10),
                      child: RaisedButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.all(10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                          ),
                          color: Color(0xffBDE0FE),
                          onPressed: () {
                            _quizValidation(i);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  i,
                                  style: GoogleFonts.fredokaOne(
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            ],
                          )),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
