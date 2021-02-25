import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'common_widgets/page_title.dart';
import './common_widgets/dict_button.dart';

class Stories extends StatefulWidget {
  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  final List<List<String>> storyList = [
    ['Story1', 'l'],
    ['Story2', 'l'],
    ['Story3', 'l'],
    ['Story4', 'l'],
    ['Story5', 'l']
  ];
  @override
  Widget build(BuildContext context) {
    return new PageTitle(
        pageTitle: 'Stories',
        pageGreeting: 'Let\'s Read!',
        pageChild: _pageContent(context));
  }

  Widget _pageContent(context) {
    return Column(
      children: [
        Container(
            height: MediaQuery.of(context).size.height - 200,
            child: Column(
              children: [
                ...storyList.map(
                  (i) => Container(
                    width: MediaQuery.of(context).size.width - 30,
                    height: (MediaQuery.of(context).size.height - 270) / 5 + 10,
                    color: Colors.transparent,
                    child: DictButton(
                      buttonName: i.first,
                      buttonImage: i.last == 'u'
                          ? 'images/unlock.png'
                          : 'images/lock.png',
                      onPressed: () {
                        print(MediaQuery.of(context).size.height);
                        print(MediaQuery.of(context).size.width);
                      },
                      imgH: 40,
                      imgW: 40,
                    ),
                  ),
                )
              ],
            ))
      ],
    );
  }
}
