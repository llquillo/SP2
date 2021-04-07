import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'common_widgets/page_title.dart';
import './common_widgets/dict_button.dart';
import './common_widgets/story_template.dart';

class Stories extends StatefulWidget {
  final stories;
  Stories({@required this.stories});
  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  final List<List<String>> storyList = [
    ['Introduction', 'u', "1"],
    ['Story2', 'l', "2"],
    ['Story3', 'l', "3"],
    ['Story4', 'l', "4"],
    ['Story5', 'l', "5"]
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
                      buttonImage:
                          i[1] == 'u' ? 'images/unlock.png' : 'images/lock.png',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StoryTemplate(
                                  story: widget.stories[int.parse(i.last)])),
                        );
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
