import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './common_widgets/dict_button.dart';
import './common_widgets/story_template.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Stories extends StatefulWidget {
  final stories;
  final locks;
  Stories({@required this.stories, this.locks});
  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  final List<List<String>> storyList = [
    ['Basics', 'l', "0"],
    ['Shopping', 'l', "1"],
    ['Travel', 'l', "2"],
    ['School', 'l', "3"],
    ['Family', 'l', "4"]
  ];
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference userDB = databaseReference.child('users').child(user.uid);
    for (var i = 0; i < (widget.locks).length - 2; i++) {
      if (widget.locks[i + 1][1] == "u") {
        storyList[i][1] = "u";
        userDB
            .reference()
            .child("Stories")
            .child(i.toString())
            .child("Status")
            .set(1);
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Stories",
            style: GoogleFonts.robotoMono(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            )),
      ),
      body: DecoratedBox(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("images/stories_background.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7), BlendMode.dstATop),
          )),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: _pageContent(context),
          )),
    );
  }

  Widget _pageContent(context) {
    print(widget.stories[1]);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SizedBox(height: MediaQuery.of(context).size.height / 10),
        Container(
            height: MediaQuery.of(context).size.height - 200,
            child: Column(
              children: [
                ...storyList.map(
                  (i) => Container(
                    width: MediaQuery.of(context).size.width - 30,
                    height: (MediaQuery.of(context).size.height - 270) / 5 + 10,
                    color: Colors.transparent,
                    child: DictButton(
                      buttonName: i.first,
                      buttonImage:
                          i[1] == 'u' ? 'images/unlock.png' : 'images/lock.png',
                      onPressed: () {
                        print(widget.stories);
                        if (i[1] == 'u') {
                          print(int.parse(i.last));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StoryTemplate(
                                      story: widget.stories[int.parse(i.last)],
                                      storyNum: int.parse(i.last),
                                      category: i.first,
                                      storyStatus:
                                          widget.stories[int.parse(i.last)]
                                              ["QuizStatus"],
                                    )),
                          );
                        }
                      },
                      imgH: 40,
                      imgW: 40,
                    ),
                  ),
                )
              ],
            ))
      ],
    );
  }
}
