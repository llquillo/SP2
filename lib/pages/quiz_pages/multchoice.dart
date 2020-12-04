import 'package:flutter/material.dart';
import '../common_widgets/page_title.dart';
import '../sub_pages/level_content.dart';
import 'package:google_fonts/google_fonts.dart';

class MultipleChoice extends StatefulWidget {
  final int i;
  final BuildContext currentContext;
  final int score;
  MultipleChoice(
      {@required this.i,
      @required this.currentContext,
      this.levelContent,
      this.score});
  final LevelContent levelContent;

  @override
  _MultipleChoiceState createState() => _MultipleChoiceState();
}

class _MultipleChoiceState extends State<MultipleChoice> {
  String correctAnswer = "Choice 4";
  LevelContent levelContent;
  @override
  void initState() {
    super.initState();
    levelContent = new LevelContent();
  }

  List<String> choices = ["Choice 1", "Choice 2", "Choice 3", "Choice 4"];
  @override
  Widget build(BuildContext context) {
    return PageTitle(
      pageTitle: "Drills",
      pageGreeting: "Question ${(widget.i)}",
      pageChild: _pageContent(context),
      bgColor: Color(0xff727764),
      titleColor: Colors.white,
    );
  }

  Widget correctAnswerValidation(BuildContext context, String correctAnswer) {
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
                widget.currentContext, widget.i, 1, widget.score);
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
                widget.currentContext, widget.i, 0, widget.score);
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

  Widget _pageContent(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 200,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 6,
                  blurRadius: 6,
                  offset: Offset(0, 4),
                )
              ],
            ),
            width: MediaQuery.of(context).size.width / 2 + 120,
            height: MediaQuery.of(context).size.height / 4 + 40,
          ),
          Container(
            margin: EdgeInsets.all(35),
            width: MediaQuery.of(context).size.width / 2 + 120,
            height: MediaQuery.of(context).size.height / 4 + 30,
            child: GridView.count(
              mainAxisSpacing: 5,
              crossAxisSpacing: 10,
              childAspectRatio: 2.1,
              crossAxisCount: 2,
              children: [
                ...choices.map((i) => Container(
                      margin: EdgeInsets.all(10),
                      // color: Colors.orange,
                      child: MaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.all(0.0),
                        height: 2.0,
                        minWidth: 2.0,
                        color: Colors.grey[300],
                        onPressed: () {
                          _quizValidation(i);
                        },
                        child: Text(i),
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
