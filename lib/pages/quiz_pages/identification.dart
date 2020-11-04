import 'package:flutter/material.dart';
import '../common_widgets/page_title.dart';
import 'package:google_fonts/google_fonts.dart';
import '../sub_pages/level_content.dart';

class Identification extends StatefulWidget {
  final int i;
  final BuildContext currentContext;
  final int score;
  Identification(
      {@required this.i,
      @required this.currentContext,
      this.levelContent,
      this.score});
  final LevelContent levelContent;

  @override
  _IdentificationState createState() => _IdentificationState();
}

class _IdentificationState extends State<Identification> {
  TextEditingController answerController = new TextEditingController();
  LevelContent levelContent;
  String correctAnswer = "hello";
  String userAnswer;

  @override
  void initState() {
    super.initState();
    levelContent = new LevelContent();
  }

  @override
  Widget build(BuildContext context) {
    return PageTitle(
      pageTitle: "Drills",
      pageGreeting: "Question ${(widget.i)}",
      pageChild: _pageContent(context),
      bgColor: Color(0xffb0c4b1),
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

  Future<void> _quizValidation() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
              alignment: Alignment(0, -1),
              child: Opacity(
                  opacity: 0.85,
                  child: answerController.text == correctAnswer
                      ? correctAnswerValidation(context, correctAnswer)
                      : incorrectAnswerValidation(context, correctAnswer)));
        });
  }

  Widget _pageContent(context) {
    return Container(
      width: MediaQuery.of(context).size.width - 60,
      height: MediaQuery.of(context).size.height - 180,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Column(
            children: [
              SizedBox(height: 10),
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
                height: MediaQuery.of(context).size.height / 4 + 20,
              ),
              Container(
                margin: EdgeInsets.all(40),
                width: MediaQuery.of(context).size.width / 2,
                child: TextField(
                  controller: answerController,
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                // margin: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width / 3 - 20,
                child: MaterialButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.all(10),
                  height: 2.0,
                  minWidth: 2.0,
                  color: Colors.grey[300],
                  onPressed: () {
                    _quizValidation();
                  },
                  child: Text(
                    "Submit",
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
