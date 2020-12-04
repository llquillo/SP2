import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class DictContent extends StatefulWidget {
  final String category;

  DictContent({@required this.category});
  @override
  _DictContentState createState() => _DictContentState();
}

class _DictContentState extends State<DictContent> {
  final List<List<String>> finalDict = [
    [
      "Word1",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation1",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word2",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation2",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word3",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation3",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word4",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation4",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word5",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation5",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word6",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation6",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word7",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation7",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word8",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation8",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word9",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation9",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word10",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation10",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word11",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation11",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word12",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation12",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word13",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation13",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
    [
      "Word14",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla.",
      "Translation14",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vitae nunc nulla."
    ],
  ];
  List<List<String>> sampleDict;

  SearchBar searchBar;
  _DictContentState() {
    sampleDict = List<List<String>>.from(finalDict);
    searchBar = new SearchBar(
      inBar: true,
      setState: setState,
      onSubmitted: _testFunc,
      buildDefaultAppBar: buildAppBar,
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: new Text('Dictionary'),
      actions: [
        searchBar.getSearchAction(context),
      ],
    );
  }

  void _testFunc(String input) {
    List<List<String>> tempWord;
    List<List<String>> tempTranslation;
    tempWord = findWord(input);
    tempTranslation = findTranslation(input);

    print('word: $tempWord');
    print('translation: $tempTranslation');

    setState(() {
      sampleDict = tempWord + tempTranslation;
    });
  }

  findWord(String input) {
    return finalDict
        .where((f) => f[0].toLowerCase().contains(input.toLowerCase()))
        .toList();
  }

  findTranslation(String input) {
    return finalDict
        .where((f) => f[2].toLowerCase().contains(input.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: new Container(
        color: Colors.white,
        child: new Column(
          children: [
            SizedBox(height: 30),
            Container(
              alignment: Alignment(-0.8, 1.0),
              child: Text(
                widget.category,
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
