import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(pageTitle),
        ),
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Container(
            color: bgColor,
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            child: new Column(
              children: <Widget>[
                SizedBox(height: 30),
                new Container(
                  alignment: Alignment(-0.8, -0.7),
                  child: Text(
                    pageGreeting,
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: titleColor,
                        fontSize: 28.0,
                        fontWeight: FontWeight.w300,
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
