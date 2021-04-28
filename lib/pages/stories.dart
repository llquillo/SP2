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
    ['Basics', 'u', "0"],
    ['Shopping', 'l', "1"],
    ['Travel', 'l', "2"],
    ['School', 'l', "3"],
    ['Family', 'l', "4"]
  ];
  @override
  Widget build(BuildContext context) {
    return new PageTitle(
        pageTitle: 'Stories',
        pageGreeting: 'Let\'s Read!',
        pageChild: _pageContent(context));
  }

  Widget _pageContent(context) {
    print(widget.stories[1]);
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
                                    story: widget.stories[int.parse(i.last)],
                                    storyNum: int.parse(i.last),
                                    category: i.first,
                                  )),
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
