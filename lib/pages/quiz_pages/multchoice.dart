import 'package:flutter/material.dart';
import '../common_widgets/page_title.dart';

class MultipleChoice extends StatefulWidget {
  @override
  _MultipleChoiceState createState() => _MultipleChoiceState();
}

class _MultipleChoiceState extends State<MultipleChoice> {
  List<String> choices = ["Choice 1", "Choice 2", "Choice 3", "Choice 4"];
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
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 200,
      child: Column(
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
            height: MediaQuery.of(context).size.height / 4 + 40,
          ),
          Container(
            margin: EdgeInsets.all(35),
            width: MediaQuery.of(context).size.width / 2 + 120,
            height: MediaQuery.of(context).size.height / 4 + 30,
            child: GridView.count(
              mainAxisSpacing: 5,
              crossAxisSpacing: 10,
              childAspectRatio: 2.1,
              crossAxisCount: 2,
              children: [
                ...choices.map((i) => Container(
                      margin: EdgeInsets.all(10),
                      // color: Colors.orange,
                      child: MaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.all(0.0),
                        height: 2.0,
                        minWidth: 2.0,
                        color: Colors.grey[300],
                        onPressed: () {},
                        child: Text(i),
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
