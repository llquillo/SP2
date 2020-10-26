import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DictContent extends StatefulWidget {
  @override
  _DictContentState createState() => _DictContentState();
}

class _DictContentState extends State<DictContent> {
  final sampleDict = [
    [
      "Word",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('App Name'),
      ),
      body: new Container(
        color: Colors.white,
        child: new Column(
          children: [
            SizedBox(height: 30),
            Container(
              alignment: Alignment(-0.8, 1.0),
              child: Text(
                '{Category}',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height - 200,
              child: GridView.count(
                crossAxisCount: 1,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                childAspectRatio: 4.5,
                children: [
                  ...sampleDict.map(
                    (i) => Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                      padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
                      decoration: new BoxDecoration(
                        border: Border.all(width: 1),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  i[0],
                                  style: GoogleFonts.playfairDisplay(
                                    textStyle: new TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  margin: EdgeInsets.zero,
                                  padding: EdgeInsets.zero,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      20,
                                  height:
                                      MediaQuery.of(context).size.height / 6,
                                  child: Text(
                                    i[1],
                                    style: GoogleFonts.montserrat(
                                      textStyle: new TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(width: 5),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  i[2],
                                  style: GoogleFonts.playfairDisplay(
                                    fontWeight: FontWeight.w700,
                                    textStyle: new TextStyle(
                                      fontSize: 16,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  margin: EdgeInsets.zero,
                                  padding: EdgeInsets.zero,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      20,
                                  height:
                                      MediaQuery.of(context).size.height / 6,
                                  child: Text(
                                    i[1],
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.montserrat(
                                      textStyle: new TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
