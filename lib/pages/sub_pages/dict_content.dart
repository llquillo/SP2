import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:firebase_database/firebase_database.dart';

class DictContent extends StatefulWidget {
  final String category;
  final String categoryName;
  final corpus;

  DictContent(
      {@required this.category,
      @required this.categoryName,
      @required this.corpus});
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
    // databaseReference.once().then((DataSnapshot snapshot) {
    //   setState(() {
    //     _initDatabase(snapshot);
    //   });
    // });
    print(widget.corpus);
    _initDatabase(widget.corpus);
  }

  Future<void> _initDatabase(corpus) {
    // print(snapshot.value);
    finalDict = List<Map>.from(corpus[widget.categoryName]["Level1"]["Words"]) +
        List<Map>.from(corpus[widget.categoryName]["Level2"]["Words"]) +
        List<Map>.from(corpus[widget.categoryName]["Level3"]["Words"]) +
        List<Map>.from(corpus[widget.categoryName]["Level4"]["Words"]) +
        List<Map>.from(corpus[widget.categoryName]["Level5"]["Words"]);
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
            SizedBox(height: 30),
            Container(
              alignment: Alignment(-0.8, 1.0),
              child: Text(
                widget.category,
                style: GoogleFonts.fredokaOne(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    // fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height / 1.5,
              child: GridView.count(
                crossAxisCount: 1,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                childAspectRatio: 4.5,
                children: [
                  ...sampleDict.map(
                    (i) => Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                      padding: EdgeInsets.fromLTRB(10, 0, 8, 0),
                      decoration: new BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
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
                                  child: Container(
                                color: Colors.yellow,
                                child: Text(
                                  i['Word'],
                                  style: GoogleFonts.fredokaOne(
                                    textStyle: new TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              )),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    i['POS'],
                                    style: GoogleFonts.fredokaOne(
                                      textStyle: new TextStyle(
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.all(0),
                                  child: Text(
                                    i['Translation'],
                                    textAlign: TextAlign.right,
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
                          // Column(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: [

                          //     // Flexible(
                          //     //   child: Container(
                          //     //     margin: EdgeInsets.zero,
                          //     //     padding: EdgeInsets.zero,
                          //     //     width: MediaQuery.of(context).size.width / 2 -
                          //     //         20,
                          //     //     height:
                          //     //         MediaQuery.of(context).size.height / 6,
                          //     //     child: Text(
                          //     //       i['Word'],
                          //     //       textAlign: TextAlign.right,
                          //     //       style: GoogleFonts.montserrat(
                          //     //         textStyle: new TextStyle(
                          //     //           fontSize: 11,
                          //     //           fontWeight: FontWeight.w500,
                          //     //         ),
                          //     //       ),
                          //     //     ),
                          //     //   ),
                          //     // ),
                          //   ],
                          // ),
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
