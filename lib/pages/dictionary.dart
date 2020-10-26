import 'package:flutter/material.dart';
import './common_widgets/dict_button.dart';
import './sub_pages/dict_content.dart';
import './common_widgets/page_title.dart';

class Dictionary extends StatelessWidget {
  void _openDict(context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DictContent()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageTitle(
      pageTitle: 'Dictionary',
      pageGreeting: "Review?",
      pageChild: pageContent(context),
    );
  }

  Widget pageContent(context) {
    return Container(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20),
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            child: DictButton(
              buttonName: "Basic Expressions",
              buttonImage: 'images/basic.png',
              onPressed: () {
                _openDict(context);
              },
            ),
          ),
          Container(
            child: DictButton(
              buttonName: "Family",
              buttonImage: 'images/family.png',
              onPressed: () {
                _openDict(context);
              },
            ),
          ),
          Container(
            child: DictButton(
              buttonName: "School",
              buttonImage: 'images/school.png',
              onPressed: () {
                _openDict(context);
              },
            ),
          ),
          Container(
            child: DictButton(
              buttonName: "Shopping",
              buttonImage: 'images/shopping.png',
              onPressed: () {
                _openDict(context);
              },
            ),
          ),
          Container(
            child: DictButton(
              buttonName: "Travel",
              buttonImage: 'images/travel.png',
              onPressed: () {
                _openDict(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
