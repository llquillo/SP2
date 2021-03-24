import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

class QuizTemplate extends StatelessWidget {
  QuizTemplate({
    @required this.pageTitle,
    @required this.pageGreeting,
    @required this.pageChildUpper,
    @required this.pageChildLower,
    @required this.quizStatus,
    this.bgColor: Colors.white,
    this.titleColor: Colors.black,
  });

  final String pageTitle;
  final String pageGreeting;
  final Widget pageChildUpper;
  final Widget pageChildLower;
  final Color bgColor;
  final Color titleColor;
  final double quizStatus;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(110),
                    bottomRight: Radius.circular(110)),
                color: Color(0xffF1F8FF),
              ),
              child: Column(
                children: [
                  LinearPercentIndicator(
                    padding: EdgeInsets.zero,
                    linearStrokeCap: LinearStrokeCap.butt,
                    width: MediaQuery.of(context).size.width,
                    lineHeight: 14.0,
                    percent: quizStatus,
                    backgroundColor: Color(0xffF1F8FF),
                    progressColor: Color(0xffCDB4DB),
                  ),
                  pageChildUpper,
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 16),
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                // color: Color(0xffF1F8FF),
              ),
              child: pageChildLower,
            ),
          ],
        ),
      ),
    );
  }
}
