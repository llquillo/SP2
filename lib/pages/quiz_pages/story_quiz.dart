import 'package:flutter/material.dart';
import 'package:sample_firebase/pages/common_widgets/story_template.dart';
import '../common_widgets/page_title.dart';
import 'package:google_fonts/google_fonts.dart';
import './story_answers.dart';

class StoryQuiz extends StatefulWidget {
  final story;
  StoryQuiz({@required this.story});
  @override
  _StoryQuizState createState() => _StoryQuizState();
}

class _StoryQuizState extends State<StoryQuiz> {
  TextEditingController answer1Controller = new TextEditingController();
  TextEditingController answer2Controller = new TextEditingController();
  TextEditingController answer3Controller = new TextEditingController();
  TextEditingController answer4Controller = new TextEditingController();

  List<TextEditingController> controllerList =
      new List<TextEditingController>();

  List<String> answers = new List<String>();

  @override
  void initState() {
    controllerList.add(answer1Controller);
    controllerList.add(answer2Controller);
    controllerList.add(answer3Controller);
    controllerList.add(answer4Controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageTitle(
      pageTitle: "Reading Comprehension",
      pageGreeting: "Quiz:",
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
          Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: Colors.yellow,
              ),
              Text("Instruction:",
                  style: GoogleFonts.fredokaOne(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  )),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.45,
            child: Text(
              "Answer the following questions in Bicol language. Provide the correct answer in the Blanks provided.",
              style: GoogleFonts.fredokaOne(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Text("\n"),
          ...questions.map(
            (i) => Container(
                child: i["Type"] == "I"
                    ? identification(context, i, questions.indexOf(i) + 1)
                    : multchoice(context, i, questions.indexOf(i) + 1)),
          ),
          Text("\n"),
          RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              onPressed: () {
                _dialog(context);
              },
              child: Text("Submit",
                  style: GoogleFonts.fredokaOne(
                    fontSize: 12,
                    // fontWeight: FontWeight.w700,
                  ))),
        ],
      ),
    );
  }

  Widget identification(context, i, count) {
    answers.add(i["Answer"]);
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
                cursorColor: Colors.black,
                controller: controllerList[count - 1],
                textAlign: TextAlign.center,
                style: GoogleFonts.fredokaOne(color: Colors.black),
              ),
            ),
          ],
        ));
  }

  List<String> getUserAnswers() {
    List<String> answers = ["", "", "", ""];
    for (var i = 0; i < controllerList.length; i++) {
      answers[i] = controllerList[i].text.toLowerCase();
    }
    return answers;
  }

  Widget confirmSubmit(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        "Submit answers?",
        style: GoogleFonts.libreBaskerville(
          textStyle: TextStyle(
            color: Colors.black,
            letterSpacing: 0,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      actions: [
        RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => StoryAnswers(
                        story: widget.story,
                        userAnswers: getUserAnswers(),
                        correctAnswers: answers)),
                (Route<dynamic> route) => false,
              );

              // _dialog(context, "pass");
            },
            child: Text(
              'Yes',
              style: GoogleFonts.libreBaskerville(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 11.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )),
        RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.libreBaskerville(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 11.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ))
      ],
    );
  }

  Future<void> _dialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
              alignment: Alignment(0, -1),
              child: Opacity(
                opacity: 0.95,
                child: confirmSubmit(context),
              ));
        });
  }

  void deleteWord(int i) {
    setState(() {
      controllerList[i] = TextEditingController(text: "");
    });
  }

  void addWord(int i, String word) {
    setState(() {
      controllerList[i] = TextEditingController(text: word);
    });
  }

  Widget multchoice(context, i, count) {
    answers.add(i["Answer"]);

    List<String> choices = new List<String>();
    choices.add(i["Choice1"]);
    choices.add(i["Choice2"]);
    choices.add(i["Choice3"]);
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(0),
                  width: MediaQuery.of(context).size.width / 1.6,
                  height: MediaQuery.of(context).size.height / 10,
                  child: TextFormField(
                    enabled: false,
                    controller: controllerList[count - 1],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fredokaOne(color: Colors.black),
                  ),
                ),
                SizedBox(width: 10),
                MaterialButton(
                  padding: EdgeInsets.all(2),
                  height: 5.0,
                  minWidth: 2.0,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: Icon(
                    Icons.delete,
                    size: 30.0,
                  ),
                  onPressed: () {
                    deleteWord(count - 1);
                  },
                )
              ],
            ),
            Text(""),
            Wrap(
              children: <Widget>[
                ...choices.map(
                  (i) => Container(
                    margin: EdgeInsets.all(4),
                    width: MediaQuery.of(context).size.width / 4,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      height: 12.0,
                      minWidth: 5.0,
                      padding: EdgeInsets.fromLTRB(15, 6, 15, 6),
                      color: Color(0xffBDE0FE),
                      onPressed: () {
                        addWord(count - 1, i);
                      },
                      child: Center(
                        child: Text(
                          i,
                          style: GoogleFonts.libreBaskerville(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
