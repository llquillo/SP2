import 'package:flutter/material.dart';
import 'page_title.dart';
import 'package:google_fonts/google_fonts.dart';
import '../quiz_pages/story_quiz.dart';

class StoryTemplate extends StatefulWidget {
  final story;
  StoryTemplate({@required this.story});
  @override
  _StoryTemplateState createState() => _StoryTemplateState();
}

class _StoryTemplateState extends State<StoryTemplate> {
  int storyCount = 0;
  final story1pics = [
    'images/story1_1.png',
    'images/story1_2.png',
    'images/story1_3.png',
    'images/story1_4.png',
    'images/story1_5.png'
  ];

  @override
  Widget build(BuildContext context) {
    return PageTitle(
      pageTitle: "Introduction",
      pageGreeting: "Si Juan at Pedro",
      pageChild: _pageContent(context),
    );
  }

  Widget _pageContent(contex) {
    String storyString = widget.story["Story"];
    List<String> splitStory = storyString.split("/");
    for (var i = 0; i < splitStory.length; i++) {
      if (splitStory[i] == null) {
        splitStory.remove(splitStory[i]);
      }
      print(splitStory[i]);
    }
    print(splitStory.length);
    print(story1pics.length);
    return Container(
      // color: Colors.yellow,
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
                  splitStory.indexOf(i) ~/ 2 < story1pics.length
                      ? splitStory.indexOf(i) % 2 == 0
                          ? Image.asset(
                              story1pics[splitStory.indexOf(i) == 0
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StoryQuiz(story: widget.story)),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text("Answer quiz",
                  style: GoogleFonts.libreBaskerville(
                    fontSize: 12,
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
