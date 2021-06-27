import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flip_card/flip_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import '../home_page.dart';

class Practice extends StatefulWidget {
  final corpus;
  final categorySequence;
  final levelSequence;
  final categoryInfo;
  final state;
  final count;

  Practice({
    @required this.corpus,
    this.categorySequence,
    this.levelSequence,
    this.categoryInfo,
    this.state,
    this.count,
  });
  @override
  _PracticeState createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Practice",
            style: GoogleFonts.robotoMono(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            )),
      ),
      body: _pageContent(context),
    );
  }

  Map answerSet;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  var combinedCorpus;
  int count = 0;
  int endTime;
  bool flag;
  bool start;
  bool defaultTime;
  bool minTime;
  HomePage homepage;

  @override
  void initState() {
    super.initState();
    start = false;

    if (widget.state) {
      endTime = DateTime.now().millisecondsSinceEpoch + 1001 * 300;
      flag = false;
      initWords();
      defaultTime = true;
      minTime = false;
    } else {
      flag = true;
      endTime = 0;
      initWords();
    }
  }

  void initWords() {
    combinedCorpus =
        List<Map>.from(widget.corpus["basics1"]["Level1"]["Words"]);
    for (var j = 0; j < widget.categorySequence.length; j++) {
      if (widget.categoryInfo[j][1] == "u") {
        for (var i = 0; i < widget.levelSequence.length; i++) {
          if (widget.corpus[widget.categorySequence[j]]
                  [widget.levelSequence[i]] !=
              null) {
            if (widget.corpus[widget.categorySequence[j]]
                    [widget.levelSequence[i]]["LevelStatus"] ==
                1) {
              if (i == 0) {
                if (j != 0) {
                  combinedCorpus += List<Map>.from(
                      widget.corpus[widget.categorySequence[j]]
                          [widget.levelSequence[i]]["Words"]);
                }
              } else {
                combinedCorpus += List<Map>.from(
                    widget.corpus[widget.categorySequence[j]]
                        [widget.levelSequence[i]]["Words"]);
              }
            }
          }
        }
      }
    }
    for (var i = 0; i < combinedCorpus.length; i++) {
      if (combinedCorpus[i] == null) {
        combinedCorpus.remove(combinedCorpus[i]);
      }
    }
    combinedCorpus.shuffle();
  }

  Map getWord(int count) {
    return combinedCorpus[count];
  }

  Widget startTimer() {
    return CountdownTimer(
      endTime: endTime,
      onEnd: onEnd,
      widgetBuilder: (_, CurrentRemainingTime time) {
        if (time == null) {
          if (widget.state) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => Practice(
                    corpus: widget.corpus,
                    categoryInfo: widget.categoryInfo,
                    categorySequence: widget.categorySequence,
                    levelSequence: widget.levelSequence,
                    state: false,
                    count: count,
                  ),
                  transitionDuration: Duration(seconds: 0),
                ),
              );
            });
          }
          return Text('0:00',
              style: GoogleFonts.robotoMono(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ));
        } else {
          var sec = (time.sec).toString().padLeft(2, '0');
          return Text(
              '${time.min == null ? 0 : time.min}:${time.sec == 0 ? sec : time.sec < 10 ? sec : time.sec}',
              style: GoogleFonts.robotoMono(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ));
        }
      },
    );
  }

  Widget _flipCard(answerSet) {
    return FlipCard(
      key: cardKey,
      flipOnTouch: true,
      speed: 0,
      direction: FlipDirection.HORIZONTAL, // default
      front: Container(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(context).size.height / 5.5),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          color: Color(0xffF1F8FF),
        ),
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Icon(Icons.emoji_flags, color: Color(0xffFFAFCC)),
                  SizedBox(width: 10),
                  Text("Bicol", style: GoogleFonts.fredokaOne(fontSize: 20))
                ]),
                Column(
                  children: [
                    Text("${answerSet["Word"]}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fredokaOne(fontSize: 28)),
                    Text("${answerSet["POS"]}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fredokaOne(fontSize: 16))
                  ],
                )
              ]),
        ),
      ),
      back: Container(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(context).size.height / 5.5),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          color: Color(0xffF1F8FF),
        ),
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Icon(Icons.emoji_flags, color: Color(0xffFFAFCC)),
                  SizedBox(width: 10),
                  Text("English", style: GoogleFonts.fredokaOne(fontSize: 20))
                ]),
                Text(answerSet["Translation"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fredokaOne(fontSize: 28))
              ]),
        ),
      ),
    );
  }

  void nextItem(context) {
    _pageContent(context);
  }

  Future<void> timerDone(BuildContext context) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Container(
              child: AlertDialog(
            backgroundColor: Colors.white,
            actions: [
              DecoratedBox(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("images/rain_background.gif"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.8), BlendMode.dstATop),
                  )),
                  child: Container(
                    padding:
                        EdgeInsets.all(MediaQuery.of(context).size.width / 20),
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: MediaQuery.of(context).size.height / 2.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.fromLTRB(
                              0, 0, 0, MediaQuery.of(context).size.width / 18),
                          color: Color(0xffF1F8FF),
                          child: Text("Time's up!",
                              style: GoogleFonts.robotoMono(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              )),
                        ),
                        Text(
                            "You succesfully practiced ${widget.count} ${widget.count > 1 ? "words" : "word"}!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.robotoMono(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            )),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15)),
                          ),
                          color: Color(0xffFFF0F7),
                          child: Text("Back to Home",
                              style: GoogleFonts.robotoMono(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              )),
                          onPressed: () {
                            if (widget.corpus["DG"]["Practice"] != 2) {
                              final FirebaseAuth auth = FirebaseAuth.instance;
                              User user = auth.currentUser;
                              final databaseReference =
                                  FirebaseDatabase.instance.reference();
                              DatabaseReference userDB = databaseReference
                                  .child('users')
                                  .child(user.uid);
                              DateTime now = new DateTime.now();
                              DateTime date =
                                  new DateTime(now.year, now.month, now.day);
                              String dateString =
                                  DateFormat('d MMM').format(date);
                              if (widget.corpus["DG"]["Date"] == dateString) {
                                if (widget.corpus["DG"]["Practice"] == 0) {
                                  userDB
                                      .reference()
                                      .child("DG")
                                      .child("Practice")
                                      .set(1);
                                }
                              }
                            }
                            Navigator.pop(context);
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (_) => HomePage()));
                          },
                        ),
                      ],
                    ),
                  )),
            ],
          ));
        });
  }

  Future<void> timerOptions(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
              child: AlertDialog(
            backgroundColor: Colors.white,
            actions: [
              Container(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width / 20),
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.height / 2.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffF1F8FF),
                      child: Text("Options:",
                          style: GoogleFonts.robotoMono(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          )),
                    ),
                    Divider(
                      height: 1,
                      thickness: 3,
                      color: Colors.black,
                    ),
                    Container(

                        // color: Colors.red,
                        height: MediaQuery.of(context).size.height / 5,
                        width: MediaQuery.of(context).size.width / 1.8,
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width / 20, 0, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: MaterialButton(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                minWidth: 2,
                                height: 2,
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    defaultTime == true
                                        ? Icon(Icons.check_circle_outlined)
                                        : minTime == true
                                            ? Icon(Icons.check_circle)
                                            : Icon(Icons.check_circle_outline),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                30),
                                    Text("3 min",
                                        style: GoogleFonts.robotoMono(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                        ))
                                  ],
                                ),
                                onPressed: () {
                                  setState(() {
                                    endTime =
                                        DateTime.now().millisecondsSinceEpoch +
                                            1001 * 180;
                                    defaultTime = false;
                                    minTime = true;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            Container(
                              child: MaterialButton(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                minWidth: 2,
                                height: 2,
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    defaultTime == true
                                        ? Icon(Icons.check_circle)
                                        : Icon(Icons.check_circle_outline),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                30),
                                    Text("5 min",
                                        style: GoogleFonts.robotoMono(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                        ))
                                  ],
                                ),
                                onPressed: () {
                                  setState(() {
                                    endTime =
                                        DateTime.now().millisecondsSinceEpoch +
                                            1001 * 300;
                                    defaultTime = true;
                                    minTime = false;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            MaterialButton(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              minWidth: 2,
                              height: 2,
                              padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  defaultTime == true
                                      ? Icon(Icons.check_circle_outlined)
                                      : minTime == true
                                          ? Icon(Icons.check_circle_outline)
                                          : Icon(Icons.check_circle),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          30),
                                  Text("10 min",
                                      style: GoogleFonts.robotoMono(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ))
                                ],
                              ),
                              onPressed: () {
                                setState(() {
                                  endTime =
                                      DateTime.now().millisecondsSinceEpoch +
                                          1001 * 600;
                                  defaultTime = false;
                                  minTime = false;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ],
          ));
        });
  }

  void onEnd() {
    print("Done");
  }

  Widget _pageContent(context) {
    if (flag == true && widget.state == false) {
      Future.delayed(Duration(seconds: 1), () {
        timerDone(context);
      });
    }
    return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width / 18,
                  MediaQuery.of(context).size.width / 20,
                  MediaQuery.of(context).size.width / 18,
                  MediaQuery.of(context).size.width / 20),
              decoration: BoxDecoration(
                // color: Colors.black,
                border: Border.all(
                  width: 2,
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              // color: Colors.black,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 10,
              margin: EdgeInsets.fromLTRB(
                  0, 0, 0, MediaQuery.of(context).size.height / 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("count: $count",
                      style: GoogleFonts.robotoMono(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      )),
                  Container(
                      child: widget.state == false
                          ? Text('0:00',
                              style: GoogleFonts.robotoMono(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ))
                          : start != false
                              ? startTimer()
                              : defaultTime == true
                                  ? Text('5:00',
                                      style: GoogleFonts.robotoMono(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                      ))
                                  : minTime == true
                                      ? Text('3:00',
                                          style: GoogleFonts.robotoMono(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                          ))
                                      : Text('10:00',
                                          style: GoogleFonts.robotoMono(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                          ))),
                  FlatButton(
                    padding: EdgeInsets.zero,
                    minWidth: 2,
                    child: Icon(Icons.settings),
                    onPressed: () {
                      timerOptions(context);
                    },
                  ),
                ],
              ),
            ),
            Container(
              child: _flipCard(getWord(count)),
              height: MediaQuery.of(context).size.height / 2.3,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
                padding: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height / 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                      ),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12)),
                        ),
                        onPressed: start == true
                            ? null
                            : () {
                                setState(() {
                                  start = true;
                                });
                              },
                        child: Text("Start",
                            style: GoogleFonts.robotoMono(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                            )),
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                        ),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12)),
                          ),
                          onPressed: start == false
                              ? null
                              : () {
                                  count++;
                                  cardKey.currentState.toggleCard();
                                  setState(() {
                                    answerSet = getWord(count);
                                    _flipCard(answerSet);
                                  });
                                },
                          child: Text("Next",
                              style: GoogleFonts.robotoMono(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              )),
                        ))
                  ],
                )),
          ],
        ));
  }
}
