import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import './common_widgets/dict_button.dart';
import './sub_pages/dict_content.dart';
import './common_widgets/page_title.dart';

class Dictionary extends StatelessWidget {
  final corpus;
  Dictionary({this.corpus});
  void _openDict(context, category, categoryName, image) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DictContent(
          category: category,
          categoryName: categoryName,
          corpus: corpus,
          image: image,
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
              buttonImage: 'images/basics_icon.png',
              imgH: MediaQuery.of(context).size.height / 7,
              imgW: MediaQuery.of(context).size.width / 4,
              onPressed: () {
                _openDict(context, "Basic Expressions", "basics1",
                    "images/basics_icon.png");
              },
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height - 270) / 5 + 10,
            width: MediaQuery.of(context).size.width - 30,
            child: DictButton(
              buttonName: "Shopping",
              buttonImage: 'images/shopping_icon.png',
              imgH: MediaQuery.of(context).size.height / 7,
              imgW: MediaQuery.of(context).size.width / 4,
              onPressed: () {
                _openDict(context, "Shopping", "shopping",
                    "images/shopping_icon.png");
              },
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height - 270) / 5 + 10,
            width: MediaQuery.of(context).size.width - 30,
            child: DictButton(
              buttonName: "Travel",
              buttonImage: 'images/travel_icon.png',
              imgH: MediaQuery.of(context).size.height / 7,
              imgW: MediaQuery.of(context).size.width / 4,
              onPressed: () {
                _openDict(
                    context, "Travel", "travel", "images/travel_icon.png");
              },
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height - 270) / 5 + 10,
            width: MediaQuery.of(context).size.width - 30,
            child: DictButton(
              buttonName: "School",
              buttonImage: 'images/school_icon.png',
              imgH: MediaQuery.of(context).size.height / 7,
              imgW: MediaQuery.of(context).size.width / 4,
              onPressed: () {
                _openDict(
                    context, "School", "school", "images/travel_icon.png");
              },
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height - 270) / 5 + 10,
            width: MediaQuery.of(context).size.width - 30,
            child: DictButton(
              buttonName: "Family",
              buttonImage: 'images/family_icon.png',
              imgH: MediaQuery.of(context).size.height / 7,
              imgW: MediaQuery.of(context).size.width / 4,
              onPressed: () {
                _openDict(
                    context, "Family", "family", "images/travel_icon.png");
              },
            ),
          ),
        ],
      ),
    );
  }
}
