import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import './common_widgets/dict_button.dart';
import './sub_pages/dict_content.dart';
import './common_widgets/page_title.dart';

class Dictionary extends StatelessWidget {
  final corpus;
  Dictionary({this.corpus});
  void _openDict(context, category, categoryName) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DictContent(
          category: category,
          categoryName: categoryName,
          corpus: corpus,
        ),
      ),
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
      // color: Colors.black,
      height: MediaQuery.of(context).size.height - 200,
      child: Column(
        children: <Widget>[
          Container(
            height: (MediaQuery.of(context).size.height - 270) / 5 + 10,
            width: MediaQuery.of(context).size.width - 30,
            child: DictButton(
              buttonName: "Basic Expressions",
              buttonImage: 'images/basic.png',
              onPressed: () {
                _openDict(context, "Basic Expressions", "basics1");
              },
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height - 270) / 5 + 10,
            width: MediaQuery.of(context).size.width - 30,
            child: DictButton(
              buttonName: "Shopping",
              buttonImage: 'images/shopping.png',
              onPressed: () {
                _openDict(context, "Shopping", "shopping");
              },
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height - 270) / 5 + 10,
            width: MediaQuery.of(context).size.width - 30,
            child: DictButton(
              buttonName: "Travel",
              buttonImage: 'images/travel.png',
              onPressed: () {
                _openDict(context, "Travel", "travel");
              },
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height - 270) / 5 + 10,
            width: MediaQuery.of(context).size.width - 30,
            child: DictButton(
              buttonName: "School",
              buttonImage: 'images/school.png',
              onPressed: () {
                _openDict(context, "School", "school");
              },
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height - 270) / 5 + 10,
            width: MediaQuery.of(context).size.width - 30,
            child: DictButton(
              buttonName: "Family",
              buttonImage: 'images/family.png',
              onPressed: () {
                _openDict(context, "Family", "family");
              },
            ),
          ),
        ],
      ),
    );
  }
}
