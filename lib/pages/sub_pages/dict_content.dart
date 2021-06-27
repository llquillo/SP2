import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:firebase_database/firebase_database.dart';

class DictContent extends StatefulWidget {
  final String category;
  final String categoryName;
  final corpus;
  final image;

  DictContent({
    @required this.category,
    @required this.categoryName,
    @required this.corpus,
    this.image,
  });
  @override
  _DictContentState createState() => _DictContentState();
}

class _DictContentState extends State<DictContent> {
  List<Map> finalDict;
  List<Map> sampleDict;
  SearchBar searchBar;

  @override
  void initState() {
    super.initState();

    print(widget.corpus);
    _initDatabase(widget.corpus);
  }

  Future<void> _initDatabase(corpus) {
    // print(snapshot.value);
    finalDict = List<Map>.from(corpus[widget.categoryName]["Level1"]["Words"]) +
        List<Map>.from(corpus[widget.categoryName]["Level2"]["Words"]) +
        List<Map>.from(corpus[widget.categoryName]["Level3"]["Words"]);
    if (corpus[widget.categoryName]["Level4"] != null) {
      finalDict +=
          List<Map>.from(corpus[widget.categoryName]["Level4"]["Words"]);
    }
    if (corpus[widget.categoryName]["Level5"] != null) {
      finalDict +=
          List<Map>.from(corpus[widget.categoryName]["Level5"]["Words"]);
    }
    for (var i = 0; i < finalDict.length; i++) {
      if (finalDict[i] == null) {
        finalDict.remove(finalDict[i]);
      }
    }
    sampleDict = List<Map>.from(finalDict);
    print(sampleDict);
  }

  _DictContentState() {
    searchBar = new SearchBar(
      showClearButton: true,
      clearOnSubmit: false,
      closeOnSubmit: false,
      inBar: true,
      setState: setState,
      onSubmitted: _testFunc,
      buildDefaultAppBar: buildAppBar,
      onCleared: clear,
    );
  }

  void clear() {
    setState(() {
      sampleDict = List<Map>.from(finalDict);
    });
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: new Text('Dictionary',
          style: GoogleFonts.robotoMono(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          )),
      actions: [
        searchBar.getSearchAction(context),
      ],
    );
  }

  void _testFunc(String input) {
    List<Map> tempWord;
    List<Map> tempTranslation;
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
        .where((f) => f['Word'].toLowerCase().contains(input.toLowerCase()))
        .toList();
  }

  findTranslation(String input) {
    return finalDict
        .where(
            (f) => f['Translation'].toLowerCase().contains(input.toLowerCase()))
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
            Container(
                margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 60,
                    0,
                    MediaQuery.of(context).size.width / 60,
                    MediaQuery.of(context).size.width / 30),
                padding: EdgeInsets.fromLTRB(
                    0,
                    MediaQuery.of(context).size.width / 8,
                    0,
                    MediaQuery.of(context).size.width / 20),
                decoration: new BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.black,
                  ),
                  color: Color(0xffF1F8FF),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40)),
                ),
                alignment: Alignment(-0.8, 1.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset("images/stars_header.png"),
                    Container(
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width / 10, 0, 0, 0),
                        child: Text(
                          widget.category,
                          style: GoogleFonts.fredokaOne(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              // fontWeight: FontWeight.w300,
                            ),
                          ),
                        )),
                  ],
                )),
            // SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height / 1.6,
              child: GridView.count(
                crossAxisCount: 1,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                childAspectRatio: (MediaQuery.of(context).size.width /
                        MediaQuery.of(context).size.height) /
                    .16,
                children: [
                  ...sampleDict.map(
                    (i) => Container(
                      // height: MediaQuery.of(context).size.height / 4,
                      margin: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.height / 20,
                        MediaQuery.of(context).size.height / 60,
                        MediaQuery.of(context).size.height / 20,
                        MediaQuery.of(context).size.height / 60,
                      ),
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width / 30,
                          0,
                          MediaQuery.of(context).size.height / 40,
                          0),
                      decoration: new BoxDecoration(
                        // border: Border.all(
                        //   width: 2,
                        //   color: Colors.black,
                        // ),
                        border: Border(
                          bottom: BorderSide(width: 2),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                  child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              5,
                                      child: Container(
                                        // color: Color(0xffFFAFCC),
                                        child: Text(
                                          i['Word'],
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.fredokaOne(
                                            textStyle: new TextStyle(
                                              backgroundColor:
                                                  Color(0xffFFAFCC),
                                              fontWeight: FontWeight.w300,
                                              fontSize: 16,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                        ),
                                      ))),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.all(0),
                                  child: Text(
                                    i['Translation'],
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.fredokaOne(
                                      textStyle: new TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                i['POS'],
                                textAlign: TextAlign.right,
                                style: GoogleFonts.fredokaOne(
                                  textStyle: new TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
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
