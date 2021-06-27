import 'package:flutter/material.dart';
import 'package:sample_firebase/pages/common_widgets/story_template.dart';
import '../common_widgets/page_title.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class StoryAnswers extends StatefulWidget {
  final story;
  final List<String> userAnswers;
  final List<String> correctAnswers;
  final index;
  final storyStatus;

  StoryAnswers({
    @required this.story,
    @required this.userAnswers,
    @required this.correctAnswers,
    @required this.index,
    this.storyStatus,
  });
  @override
  _StoryAnswersState createState() => _StoryAnswersState();
}

class _StoryAnswersState extends State<StoryAnswers> {
  TextEditingController answer1Controller = new TextEditingController();
  TextEditingController answer2Controller = new TextEditingController();
  TextEditingController answer3Controller = new TextEditingController();
  TextEditingController answer4Controller = new TextEditingController();

  List<TextEditingController> controllerList =
      new List<TextEditingController>();

  int score = 0;

  @override
  void initState() {
    controllerList.add(answer1Controller);
    controllerList.add(answer2Controller);
    controllerList.add(answer3Controller);
    controllerList.add(answer4Controller);
    for (var i = 0; i < controllerList.length; i++) {
      controllerList[i] = TextEditingController(text: widget.userAnswers[i]);
    }
    for (var j = 0; j < widget.userAnswers.length; j++) {
      if (widget.userAnswers[j] == widget.correctAnswers[j].toLowerCase()) {
        score++;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.correctAnswers);
    print(widget.userAnswers);
    return PageTitle(
      pageTitle: "Reading Comprehension",
      pageGreeting: "Score: $score/${widget.userAnswers.length}",
      pageChild: _pageContent(context),
    );
  }

  Widget _pageContent(context) {
    var questions = List<Map>.from(widget.story["Quiz"]);
    for (var i = 0; i < questions.length; i++) {
      if (questions[i] == null) {
        questions.remove(questions[i]);
      }
    }
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference userDB = databaseReference.child('users').child(user.uid);
    print(widget.storyStatus);
    if (widget.storyStatus == 0) {
      for (var i = 0; i < widget.userAnswers.length; i++) {
        userDB
            .child("Stories")
            .child(widget.index.toString())
            .child("Answers")
            .child(i.toString())
            .set(widget.userAnswers[i]);
      }
      userDB
          .child("Stories")
          .child(widget.index.toString())
          .child("QuizStatus")
          .set(1);
      userDB
          .child("Stories")
          .child(widget.index.toString())
          .child("QuizScore")
          .set(score);
    }
    print(controllerList);
    print(questions);
    return Container(
      margin: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width / 15,
          0,
          MediaQuery.of(context).size.width / 10,
          MediaQuery.of(context).size.height / 12),
      child: Column(
        children: [
          ...questions.map(
            (i) => Container(
                child: i["Type"] == "I"
                    ? identification(context, i, questions.indexOf(i) + 1)
                    : multchoice(context, i, questions.indexOf(i) + 1)),
          ),
          Text("\n"),
          RaisedButton(
              color: Color(0xffF4F7FA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Text("Okay",
                  style: GoogleFonts.robotoMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ))),
        ],
      ),
    );
  }

  Widget identification(context, i, count) {
    var userAnswer = controllerList[count - 1].text;

    return Container(
        margin: EdgeInsets.fromLTRB(
            0,
            MediaQuery.of(context).size.height / 40,
            MediaQuery.of(context).size.width / 40,
            MediaQuery.of(context).size.height / 60),
        child: Column(
          children: [
            Row(children: [
              Text("$count.) ",
                  style: GoogleFonts.libreBaskerville(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  )),
              Text(i["Question"],
                  style: GoogleFonts.libreBaskerville(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  )),
            ]),
            Container(
              // margin: EdgeInsets.all(40),
              width: MediaQuery.of(context).size.width / 1.5,
              child: TextField(
                enabled: false,
                cursorColor: Colors.black,
                controller: controllerList[count - 1],
                textAlign: TextAlign.center,
                style: GoogleFonts.fredokaOne(
                    color: userAnswer ==
                            widget.correctAnswers[count - 1].toLowerCase()
                        ? Colors.green
                        : Colors.red),
              ),
            ),
            Container(
              child: userAnswer ==
                      widget.correctAnswers[count - 1].toLowerCase()
                  ? null
                  : Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(
                          "*The correct answer is ${widget.correctAnswers[count - 1]}",
                          style: GoogleFonts.fredokaOne(
                            fontSize: 14,
                            color: Colors.red[700],
                          ))),
            )
          ],
        ));
  }

  Widget multchoice(context, i, count) {
    var userAnswer = controllerList[count - 1].text;
    return Container(
        margin: EdgeInsets.fromLTRB(
            0,
            MediaQuery.of(context).size.height / 40,
            MediaQuery.of(context).size.width / 15,
            MediaQuery.of(context).size.height / 60),
        child: Column(
          children: [
            Row(
              children: [
                Text("$count.) ",
                    style: GoogleFonts.libreBaskerville(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    )),
                Text(i["Question"],
                    style: GoogleFonts.libreBaskerville(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
            Container(
              // margin: EdgeInsets.all(0),
              width: MediaQuery.of(context).size.width / 1.5,
              child: TextField(
                enabled: false,
                controller: controllerList[count - 1],
                textAlign: TextAlign.center,
                style: GoogleFonts.fredokaOne(
                    color: userAnswer ==
                            widget.correctAnswers[count - 1].toLowerCase()
                        ? Colors.green
                        : Colors.red),
              ),
            ),
            Container(
              child: userAnswer ==
                      widget.correctAnswers[count - 1].toLowerCase()
                  ? null
                  : Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(
                          "*The correct answer is ${widget.correctAnswers[count - 1]}",
                          style: GoogleFonts.fredokaOne(
                            fontSize: 14,
                            color: Colors.red[700],
                          ))),
            ),
          ],
        ));
  }
}
