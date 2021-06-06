import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PageTitle extends StatelessWidget {
  PageTitle({
    @required this.pageTitle,
    @required this.pageGreeting,
    @required this.pageChild,
    this.bgColor: Colors.white,
    this.titleColor: Colors.black,
  });

  final String pageTitle;
  final String pageGreeting;
  final Widget pageChild;
  final Color bgColor;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(pageTitle),
        ),
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Container(
            color: bgColor,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                SizedBox(height: 30),
                Container(
                  alignment: Alignment(-0.8, -0.7),
                  child: Text(
                    pageGreeting,
                    style: GoogleFonts.fredokaOne(
                      textStyle: TextStyle(
                        color: titleColor,
                        fontSize: 28.0,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                pageChild,
              ],
            ),
          ),
        ));
  }
}
