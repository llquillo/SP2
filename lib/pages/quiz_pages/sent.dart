import 'package:flutter/material.dart';
import '../common_widgets/page_title.dart';
import 'package:google_fonts/google_fonts.dart';
import '../sub_pages/level_content.dart';
import 'package:firebase_database/firebase_database.dart';

class Sent extends StatefulWidget {
  final int i;
  final BuildContext currentContext;
  final int score;
  final List<Map> wordList;
  final String level;
  final String category;
  Sent(
      {@required this.i,
      @required this.currentContext,
      this.levelContent,
      this.score,
      this.wordList,
      this.level,
      this.category});
  final LevelContent levelContent;
  @override
  _SentState createState() => _SentState();
}

enum ChangeAlign { selected, notSelected }

class _SentState extends State<Sent> with SingleTickerProviderStateMixin {
  TextEditingController answerController = new TextEditingController();
  LevelContent levelContent;
  String correctAnswer;
  String userAnswer;
  List<String> buttons = [];
  List<String> selectedWords = List<String>();
  List<Map> sentenceList = List<Map>();

  var databaseInstanceTemp;
  var databaseTemp;

  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    databaseReference.once().then((DataSnapshot snapshot) {
      setState(() {
        _initDatabase(snapshot);
      });
    });
  }

  Future<void> _initDatabase(snapshot) async {
    databaseInstanceTemp = databaseReference.reference();
    databaseTemp = snapshot.value["basics1"]["Sentences"];
    print(databaseTemp);
    List<Map> tempList = new List<Map>();
    var senetence = new List<Map>();
    senetence = List<Map>.from(databaseTemp);
    for (var i = 0; i < 11; i++) {
      if (senetence[i] != null) {
        print(senetence[i]);
        tempList.add(senetence[i]);
      }
      sentenceList = List<Map>.from(tempList);
    }
    buttons = sentenceList[1]["Translation"].split(" ");
    buttons.shuffle();
  }

  Widget buildAnswerBox() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      children: <Widget>[
        ...buttons.map((i) => Container(
            margin: EdgeInsets.all(4),
            width: MediaQuery.of(context).size.width / 5,
            child: MaterialButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              height: 10.0,
              minWidth: 15.0,
              padding: EdgeInsets.fromLTRB(15, 6, 15, 6),
              color: Colors.yellow,
              onPressed: () {
                addWord(i);
              },
              child: Text(
                i,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            )))
      ],
    );
  }

  String getText() {
    String text = "";
    for (var i = 0; i < selectedWords.length; i++) {
      text += " " + selectedWords[i];
    }
    return text;
  }

  void addWord(String word) {
    bool flag = false;
    for (var j = 0; j < selectedWords.length; j++) {
      if (selectedWords[j] == word) {
        flag = true;
      }
    }
    if (!flag) {
      selectedWords.add(word);
    }
    String text = getText();
    setState(() {
      answerController = TextEditingController(text: text);
    });
  }

  void deleteWord() {
    if (selectedWords != null) {
      selectedWords.remove(selectedWords[selectedWords.length - 1]);
      String text = getText();

      setState(() {
        answerController = TextEditingController(text: text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageTitle(
      pageTitle: "Drills",
      pageGreeting: "Question ${(widget.i)}",
      pageChild: _pageContent(context),
    );
  }

  Widget _pageContent(context) {
    return Container(
        width: MediaQuery.of(context).size.width - 30,
        height: MediaQuery.of(context).size.height - 180,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 50,
              height: MediaQuery.of(context).size.height / 3,
              child: Center(
                child: Text(
                  sentenceList[1]["Sentence"],
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(fontSize: 24),
                  ),
                ),
              ),
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
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(0),
                  width: MediaQuery.of(context).size.width - 140,
                  height: MediaQuery.of(context).size.height / 3 - 140,
                  child: TextFormField(
                    controller: answerController,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(width: 20),
                MaterialButton(
                  padding: EdgeInsets.all(9),
                  height: 2.0,
                  minWidth: 2.0,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  color: Colors.pink,
                  child: Text('Del'),
                  onPressed: () {
                    deleteWord();
                  },
                )
              ],
            ),
            Container(
              padding: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width - 30,
              height: MediaQuery.of(context).size.height / 3 - 140,
              child: Center(
                child: buildAnswerBox(),
              ),
            )
          ],
        ));
  }
}
