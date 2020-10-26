import 'package:flutter/material.dart';
import './common_widgets/page_title.dart';
import 'package:google_fonts/google_fonts.dart';
import './sub_pages/level_content.dart';

class Drills extends StatefulWidget {
  @override
  _DrillsState createState() => _DrillsState();
}

class _DrillsState extends State<Drills> {
  final buttonsInfo = [
    "Level 1",
    "Level 2",
    "Level 3",
    "Level 4",
    "Level 5",
    "Level 6",
  ];

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
                  _openLevel(context);
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
                        child: new Text(
                          i,
                          style: GoogleFonts.playfairDisplay(
                            textStyle: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w200,
                              color: Colors.white,
                            ),
                          ),
                        ),
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
