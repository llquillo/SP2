import 'dart:io';

import 'package:flutter/material.dart';
import '../common_widgets/page_title.dart';
import 'package:google_fonts/google_fonts.dart';
import '../sub_pages/level_content.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';

class Sent extends StatefulWidget {
  final int i;
  final BuildContext currentContext;
  final int score;
  final databaseTemp;
  final List<Map> wordList;
  final String level;
  final String category;
  Sent(
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
  _SentState createState() => _SentState();
}

class _SentState extends State<Sent> with SingleTickerProviderStateMixin {
  TextEditingController answerController = new TextEditingController();
  LevelContent levelContent;
  String correctAnswer;
  String userAnswer;
  List<String> buttons = [];
  List<String> selectedWords = List<String>();
  List<Map> sentenceList = List<Map>();

  List<Map> verbList = List<Map>();
  List<Map> nounList = List<Map>();
  List<Map> pronList = List<Map>();
  List<Map> nameList = List<Map>();
  List<Map> foodList = List<Map>();
  List<Map> drinkList = List<Map>();

  String finalSentence = "";
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    levelContent = new LevelContent(
      databaseTemp: widget.databaseTemp,
      wordList: widget.wordList,
      category: widget.category,
    );
    _initDatabase();
  }

  _initDatabase() {
    var db = widget.databaseTemp;

    // print(db['basics1']['Names']);

    verbList = fetchWords(db, 'basics1', 'Verbs');
    pronList = fetchWords(db, 'basics1', 'Pronouns');
    nameList = fetchWords(db, 'basics1', 'Names');
    foodList = fetchWords(db, 'basics1', 'Food');
    drinkList = fetchWords(db, 'basics1', 'Drink');

    // nounList = fetchWords(db, 'basics1', '')
    verbList.shuffle();
    pronList.shuffle();
    nameList.shuffle();
    foodList.shuffle();
    drinkList.shuffle();
    formSentence();
  }

  List<Map> fetchWords(snapshot, String catName, String posName) {
    var temp = snapshot[posName];
    List<Map> tempList = new List<Map>();
    List<Map> finalList = new List<Map>();
    var word = new List<Map>();
    word = List<Map>.from(temp);
    for (var i = 0; i < word.length; i++) {
      if (word[i] != null) {
        print(word[i]);
        tempList.add(word[i]);
      }
      finalList = List<Map>.from(tempList);
    }
    return finalList;
  }

  Map getVerb() {
    var rand = new Random();
    int r = 1 + rand.nextInt(verbList.length - 1);
    return verbList[r];
  }

  Map getPron() {
    var rand = new Random();
    int r = 1 + rand.nextInt(pronList.length - 1);
    return pronList[r];
  }

  Map getPropName() {
    var rand = new Random();
    int r = 1 + rand.nextInt(nameList.length - 1);
    return nameList[r];
  }

  Map getFood() {
    var rand = new Random();
    int r = 1 + rand.nextInt(foodList.length - 1);
    return foodList[r];
  }

  Map getDrink() {
    var rand = new Random();
    int r = 1 + rand.nextInt(drinkList.length - 1);
    return drinkList[r];
  }

  String formSentence() {
    var rand = new Random();
    int r = 1 + rand.nextInt(3 - 1);
    r = 1;
    List<Map> translatedWords = new List<Map>();
    String sentence;
    String tense;
    String verbType;
    switch (r) {
      case 1:
        var r = new Random();
        int choice = 1 + r.nextInt(4 - 1);
        var holder = getVerb();
        sentence = holder['Word'];
        tense = holder['Tense'];
        verbType = holder['Category'];
        translatedWords.add(holder);
        switch (choice) {
          case 1:
            var holder = getPron();
            sentence += " " + holder['Word'].toLowerCase();
            translatedWords.add(holder);
            print(sentence);
            break;
          case 2:
            var holder = getPron();
            sentence += " " + holder['Word'].toLowerCase() + " " + "kan" + " ";
            translatedWords.add(holder);
            switch (verbType) {
              case 'Food':
                var holder = getFood();
                sentence += holder['Word'];
                translatedWords.add(holder);
                break;
              case 'Drink':
                var holder = getDrink();
                sentence += holder['Word'];
                translatedWords.add(holder);
                break;
            }
            print(sentence);
            break;
          case 3:
            var holder = getPropName();
            sentence += " " + "si" + " " + holder['Name'];
            translatedWords.add(holder);
            print(sentence);
            break;
          case 4:
            var holder = getPropName();
            sentence += " " + "si" + " " + holder['Name'] + " " + "kan" + " ";
            translatedWords.add(holder);
            switch (verbType) {
              case 'Food':
                var holder = getFood();
                sentence += holder['Word'];
                translatedWords.add(holder);
                break;
              case 'Drink':
                var holder = getDrink();
                sentence += holder['Word'];
                translatedWords.add(holder);
                break;
            }
            print(sentence);
            break;
        }
        break;
      case 2:
        var r = new Random();
        int choice = 1 + r.nextInt(4 - 1);
        var holder = getPropName();
        translatedWords.add(holder);

        var sentence = "Siya si " + holder['Name'];
        print(sentence);
        break;
      case 3:
        // print(getVerb());
        break;
      default:
        break;
    }
    finalSentence = sentence;
    // print(translatedWords);
    translateSentence(translatedWords, sentence, tense);
  }

  void translateSentence(List<Map> words, String sentence, String tense) {
    String translatedSentence = "";

    List<Map> reversedSent = new List<Map>();

    reversedSent = new List.from(words.reversed);
    var temp, flag = false;
    buttons = [];
    for (var i = 0; i < reversedSent.length; i++) {
      if (reversedSent[i]['POS'] == 'Noun') {
        temp = reversedSent[i];
        print(temp);
        reversedSent.remove(reversedSent[i]);
        flag = true;
      }
    }
    if (flag) {
      print(temp);
      reversedSent.add(temp);
    }

    if (tense != null) {
      switch (tense) {
        case 'Present':
          for (var i = 0; i < reversedSent.length - 1; i++) {
            if (reversedSent[i + 1]['POS'] == 'Verb') {
              if (reversedSent[i]['Translation'] != null) {
                buttons.add(reversedSent[i]['Translation']);
                if (reversedSent[i]['Translation'] == "You") {
                  translatedSentence +=
                      reversedSent[i]['Translation'] + " are ";
                  buttons.add("are");
                } else {
                  if (reversedSent[i]['Translation'] == "I") {
                    translatedSentence +=
                        reversedSent[i]['Translation'] + " am ";
                    buttons.add("am");
                  } else {
                    translatedSentence +=
                        reversedSent[i]['Translation'] + " is ";
                    buttons.add("is");
                  }
                }
              } else {
                translatedSentence += reversedSent[i]['Name'] + " is ";
                buttons.add(reversedSent[i]['Name']);
                buttons.add("is");
              }
            } else {
              if (reversedSent[i]['Translation'] != null) {
                translatedSentence += reversedSent[i]['Translation'] + " ";
                buttons.add(reversedSent[i]['Translation']);
              } else {
                translatedSentence += reversedSent[i]['Name'] + " ";
                buttons.add(reversedSent[i]['Name']);
              }
            }
          }
          translatedSentence +=
              reversedSent[reversedSent.length - 1]['Translation'];
          buttons.add(reversedSent[reversedSent.length - 1]['Translation']);
          break;
        case 'Past':
          for (var i = 0; i < reversedSent.length; i++) {
            if (reversedSent[i]['Translation'] != null) {
              translatedSentence += reversedSent[i]['Translation'];
              buttons.add(reversedSent[i]['Translation']);
            } else {
              translatedSentence += reversedSent[i]['Name'];
              buttons.add(reversedSent[i]['Name']);
            }
            translatedSentence += " ";
          }
          break;
        case 'Future':
          for (var i = 0; i < reversedSent.length; i++) {
            if (reversedSent[i]['Translation'] != null) {
              translatedSentence += reversedSent[i]['Translation'];
              buttons.add(reversedSent[i]['Translation']);
            } else {
              translatedSentence += reversedSent[i]['Name'];
              buttons.add(reversedSent[i]['Name']);
            }
            translatedSentence += " ";
          }
          break;
        case 'Continuous':
          for (var i = 0; i < reversedSent.length - 1; i++) {
            if (reversedSent[i + 1]['POS'] == 'Verb') {
              if (reversedSent[i]['Translation'] != null) {
                translatedSentence += reversedSent[i]['Translation'] + " ";
                buttons.add(reversedSent[i]['Translation']);
                if (reversedSent[i]['Number'] == 'Singular') {
                  reversedSent[i + 1]['Translation'] += 's';
                }
              } else {
                translatedSentence += reversedSent[i]['Name'] + " ";
                buttons.add(reversedSent[i]['Name']);
                reversedSent[i + 1]['Translation'] += 's';
              }
            } else {
              if (reversedSent[i]['Translation'] != null) {
                translatedSentence += reversedSent[i]['Translation'] + " ";
                buttons.add(reversedSent[i]['Translation']);
              } else {
                translatedSentence += reversedSent[i]['Name'] + " ";
                buttons.add(reversedSent[i]['Name']);
              }
            }
          }
          translatedSentence +=
              reversedSent[reversedSent.length - 1]['Translation'];
          buttons.add(reversedSent[reversedSent.length - 1]['Translation']);

          break;
        default:
          break;
      }
    }
    for (var i = 0; i < buttons.length; i++) {
      buttons[i] = buttons[i].toLowerCase();
    }
    correctAnswer = translatedSentence;
    correctAnswer.toLowerCase();
    buttons.shuffle();
    print(buttons);
    print(translatedSentence);
    print(correctAnswer);
  }

  Widget buildAnswerBox() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      children: <Widget>[
        ...buttons.map(
          (i) => Container(
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
              child: Center(
                child: Text(
                  i,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget correctAnswerValidation(BuildContext context, String correctAnswer) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference userDB = databaseReference.child('users').child(user.uid);
    print("category ${widget.category}");
    print("level ${widget.level}");
    print(widget.i.toString());
    print(userDB
        .reference()
        .child(widget.category)
        .child(widget.level)
        .child("Words")
        .child(widget.i.toString())
        .child("Deck")
        .set(2));
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
            print("category ${widget.category}");
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

  Future<void> _quizValidation() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
              alignment: Alignment(0, -1),
              child: Opacity(
                  opacity: 0.85,
                  child:
                      answerController.text.toLowerCase().replaceAll(" ", "") ==
                              correctAnswer.toLowerCase().replaceAll(" ", "")
                          ? correctAnswerValidation(context, correctAnswer)
                          : incorrectAnswerValidation(context, correctAnswer)));
        });
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
    if (selectedWords.length > 0) {
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
                finalSentence,
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
                color: Colors.blue,
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
            height: MediaQuery.of(context).size.height / 3 - 110,
            child: Center(
              child: buildAnswerBox(),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 3 - 20,
            child: MaterialButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
              height: 2.0,
              minWidth: 2.0,
              color: Colors.grey[300],
              onPressed: () {
                _quizValidation();
                // formSentence();
              },
              child: Text(
                "Submit",
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(color: Colors.black, fontSize: 13),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
