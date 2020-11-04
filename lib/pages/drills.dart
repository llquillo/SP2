import 'package:flutter/material.dart';
import './common_widgets/page_title.dart';
import './sub_pages/level_content.dart';

class Drills extends StatefulWidget {
  @override
  _DrillsState createState() => _DrillsState();
}

class _DrillsState extends State<Drills> {
  List buttonsInfo = [
    ["images/basic.png", "u"],
    ["images/basic.png", "l"],
    ["images/family.png", "l"],
    ["images/school.png", "l"],
    ["images/shopping.png", "l"],
    ["images/travel.png", "l"],
  ];

  String locked = "images/lock.png";

  void _openLevel(context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LevelContent()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageTitle(
      pageTitle: 'Drills',
      pageGreeting: 'Let\'s Practice!',
      pageChild: _pageContent(context),
    );
  }

  Widget _lockedLevel(i) {
    return Center(
        child: Stack(
      children: [
        Positioned(
          child: Opacity(
            opacity: 0.7,
            child: Image.asset(i),
          ),
        ),
        Positioned(
          // right: 0.2,
          child: Opacity(
            opacity: .9,
            child: Image.asset(
              locked,
              height: 50,
              width: 50,
            ),
          ),
        ),
      ],
    ));
  }

  Widget _unlockedLevel(i) {
    return Image.asset(i);
  }

  Widget _pageContent(context) {
    return Container(
      padding: const EdgeInsets.all(13),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 200,
      // color: Colors.green,
      child: new Container(
        height: MediaQuery.of(context).size.height - 180,
        child: GridView.count(
          scrollDirection: Axis.vertical,
          crossAxisCount: 2,
          childAspectRatio: (MediaQuery.of(context).size.width /
              2 /
              (((MediaQuery.of(context).size.height) - 200) / 3)),
          children: [
            ...buttonsInfo.map(
              (i) => GestureDetector(
                onTap: () {
                  if (i.last == "u") {
                    _openLevel(context);
                  }
                },
                child: Container(
                  width: 10,
                  margin: const EdgeInsets.fromLTRB(0, 7, 0, 6),
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black87,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        spreadRadius: 6,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: i.last == 'u'
                            ? _unlockedLevel(i.first)
                            : _lockedLevel(i.first),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
