import 'package:flutter/material.dart';
import '../common_widgets/page_title.dart';

class Identification extends StatefulWidget {
  @override
  _IdentificationState createState() => _IdentificationState();
}

class _IdentificationState extends State<Identification> {
  @override
  Widget build(BuildContext context) {
    return PageTitle(
      pageTitle: "Drills",
      pageGreeting: "Question N",
      pageChild: _pageContent(context),
      bgColor: Color(0xffb0c4b1),
    );
  }

  Widget _pageContent(context) {
    return Container(
      width: MediaQuery.of(context).size.width - 60,
      height: MediaQuery.of(context).size.height - 200,
      child: ListView(
        children: [
          Container(
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
            width: MediaQuery.of(context).size.width / 2 + 120,
            height: MediaQuery.of(context).size.height / 4 + 20,
          ),
          Container(
            margin: EdgeInsets.all(50),
            width: MediaQuery.of(context).size.width / 2 + 60,
            child: TextField(),
          )
        ],
      ),
    );
  }
}
