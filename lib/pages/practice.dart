import 'package:flutter/material.dart';
import 'common_widgets/page_title.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

class Practice extends StatefulWidget {
  final corpus;
  Practice({@required this.corpus});
  @override
  _PracticeState createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  @override
  Widget build(BuildContext context) {
    return PageTitle(
      pageTitle: "Practice",
      pageGreeting: "",
      pageChild: _pageContent(context),
    );
  }

  Map answerSet;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  void initState() {
    super.initState();
    getWord();
  }

  Map getWord() {
    var combinedCorpus =
        List<Map>.from(widget.corpus["basics1"]["Level1"]["Words"]) +
            List<Map>.from(widget.corpus["basics1"]["Level2"]["Words"]) +
            List<Map>.from(widget.corpus["basics1"]["Level3"]["Words"]) +
            List<Map>.from(widget.corpus["basics1"]["Level4"]["Words"]) +
            List<Map>.from(widget.corpus["basics1"]["Level5"]["Words"]);
    for (var i = 0; i < combinedCorpus.length; i++) {
      if (combinedCorpus[i] == null) {
        combinedCorpus.remove(combinedCorpus[i]);
      }
    }
    var rand = new Random();
    int r = 0 + rand.nextInt(combinedCorpus.length - 1);
    return combinedCorpus[r];
  }

  Widget _flipCard(answerSet) {
    return FlipCard(
      key: cardKey,
      flipOnTouch: true,
      speed: 800,
      direction: FlipDirection.HORIZONTAL, // default
      front: Container(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(context).size.height / 5.5),
        decoration: BoxDecoration(
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

  Widget _pageContent(context) {
    return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        // width: MediaQuery.of(context).size.width - 100,
        // height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              child: _flipCard(getWord()),
              height: MediaQuery.of(context).size.height / 2.3,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
                padding: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height / 5,
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                      ),
                      color: Color(0xffa2d2ff),
                      onPressed: () {
                        // cardKey.currentState.toggleCard();
                        setState(() {
                          answerSet = getWord();
                          _flipCard(answerSet);
                        });
                      },
                      child: Text("Next",
                          style: GoogleFonts.fredokaOne(fontSize: 16)),
                    )))
          ],
        ));
  }
}
