import 'package:flutter/material.dart';
import 'package:sample_firebase/pages/quiz_pages/story_answers.dart';
import 'page_title.dart';
import 'package:google_fonts/google_fonts.dart';
import '../quiz_pages/story_quiz.dart';

class StoryTemplate extends StatefulWidget {
  final category;
  final story;
  final storyNum;
  final storyStatus;
  final unlockedStatus;
  StoryTemplate({
    @required this.story,
    @required this.storyNum,
    @required this.category,
    @required this.storyStatus,
    @required this.unlockedStatus,
  });
  @override
  _StoryTemplateState createState() => _StoryTemplateState();
}

class _StoryTemplateState extends State<StoryTemplate> {
  int storyCount = 0;
  final storyTitles = [
    "Si Juan at Pedro",
    "Si Maria at Clara sa Mall",
    "Bagong eskuela",
    "Fieldtrip",
    "Sleepover"
  ];
  final introductionPics = [
    'images/story1_1.png',
    'images/story1_2.png',
    'images/story1_3.png',
    'images/story1_4.png',
    'images/story1_5.png'
  ];
  final schoolPics = [
    'images/school1.png',
    'images/school2.png',
    'images/school3.png',
    'images/school4.png',
    'images/school5.png',
    'images/school6.png',
    'images/school7.png',
    'images/school8.png',
  ];
  final shoppingPics = [
    'images/shopping1.png',
    'images/shopping2.png',
    'images/shopping3.png',
    'images/shopping4.png',
    'images/shopping5.png',
    'images/shopping6.png',
    'images/shopping7.png',
  ];
  final travelPics = [
    "images/travel1.png",
    "images/travel2.png",
    "images/travel3.png",
    "images/travel4.png",
    "images/shopping5.png",
    "images/travel6.png",
    "images/travel7.png",
    "images/travel8.png",
  ];
  final familyPics = [
    "images/family1.png",
    "images/family2.png",
    "images/family3.png",
    "images/family4.png",
    "images/family5.png",
    "images/family6.png",
    "images/family7.png",
    "images/family8.png",
    "images/family9.png",
  ];
  List<String> storyPics;

  @override
  Widget build(BuildContext context) {
    return PageTitle(
      pageTitle: widget.category,
      pageGreeting: storyTitles[widget.storyNum],
      pageChild: _pageContent(context),
    );
  }

  Widget _pageContent(contex) {
    switch (widget.storyNum) {
      case 0:
        storyPics = List<String>.from(introductionPics);
        break;
      case 1:
        storyPics = List<String>.from(shoppingPics);
        break;
      case 2:
        storyPics = List<String>.from(travelPics);
        break;
      case 3:
        storyPics = List<String>.from(schoolPics);
        break;
      case 4:
        storyPics = List<String>.from(familyPics);
        break;
    }
    String storyString = widget.story["Story"];
    List<String> splitStory = storyString.split("/");
    for (var i = 0; i < splitStory.length; i++) {
      if (splitStory[i] == null) {
        splitStory.remove(splitStory[i]);
      }
      print(splitStory[i]);
    }
    print(splitStory.length);
    print(storyPics.length);
    return Container(
      margin: EdgeInsets.fromLTRB(28, 5, 28, 5),
      child: Column(
        children: [
          ...splitStory.map((i) => Column(
                children: [
                  Text(i,
                      style: GoogleFonts.libreBaskerville(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      )),
                  splitStory.indexOf(i) ~/ 2 < storyPics.length
                      ? splitStory.indexOf(i) % 2 == 0
                          ? Image.asset(
                              storyPics[splitStory.indexOf(i) == 0
                                  ? splitStory.indexOf(i)
                                  : (splitStory.indexOf(i) ~/ 2)],
                              height: MediaQuery.of(context).size.height / 3,
                              width: MediaQuery.of(context).size.width / 1.5,
                            )
                          : Text("")
                      : Text("\n"),
                  Text(""),
                ],
              )),
          Text("***\n",
              style: GoogleFonts.libreBaskerville(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              )),
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
                if (widget.storyStatus == 0) {
                  if (widget.unlockedStatus == 'u') {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StoryQuiz(
                                story: widget.story,
                                index: widget.storyNum,
                                storyStatus: widget.storyStatus,
                              )),
                      (Route<dynamic> route) => false,
                    );
                  }
                } else {
                  List<String> userAnswers = [];
                  List<String> correctAnswers = [];

                  for (var i = 0; i < 4; i++) {
                    print(widget.story[widget.storyNum]);

                    userAnswers.add(widget.story["Answers"][i]);
                    correctAnswers.add(widget.story["Quiz"][i]["Answer"]);
                  }
                  print(userAnswers);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StoryAnswers(
                                story: widget.story,
                                userAnswers: userAnswers,
                                correctAnswers: correctAnswers,
                                index: widget.storyNum,
                                storyStatus: widget.storyStatus,
                              )));
                }
              },
              child: Text("Answer quiz",
                  style: GoogleFonts.robotoMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ))),
          Text("\n"),
          Text("\n"),
          Text("\n"),
        ],
      ),
    );
  }
}
