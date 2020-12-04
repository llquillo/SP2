import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './common_widgets/dict_button.dart';
import './sub_pages/dict_content.dart';
import './common_widgets/page_title.dart';

class Dictionary extends StatelessWidget {
  void _openDict(context, category) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DictContent(
                category: category,
              )),
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
      height: MediaQuery.of(context).size.height - 200,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20),
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            height: (MediaQuery.of(context).size.height - 270) / 5,
            child: DictButton(
              buttonName: "Basic Expressions",
              buttonImage: 'images/basic.png',
              onPressed: () {
                _openDict(context, "Basic Expressions");
              },
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height - 270) / 5,
            child: DictButton(
              buttonName: "Family",
              buttonImage: 'images/family.png',
              onPressed: () {
                _openDict(context, "Family");
              },
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height - 270) / 5,
            child: DictButton(
              buttonName: "School",
              buttonImage: 'images/school.png',
              onPressed: () {
                _openDict(context, "School");
              },
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height - 270) / 5,
            child: DictButton(
              buttonName: "Shopping",
              buttonImage: 'images/shopping.png',
              onPressed: () {
                _openDict(context, "Shopping");
              },
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height - 270) / 5,
            child: DictButton(
              buttonName: "Travel",
              buttonImage: 'images/travel.png',
              onPressed: () {
                _openDict(context, "Travel");
              },
            ),
          )
        ],
      ),
    );
  }
}
