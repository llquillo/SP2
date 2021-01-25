import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:firebase_database/firebase_database.dart';

class DictContent extends StatefulWidget {
  final String category;

  DictContent({@required this.category});
  @override
  _DictContentState createState() => _DictContentState();
}

class _DictContentState extends State<DictContent> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List<Map> finalDict;
  List<Map> sampleDict;
  SearchBar searchBar;

  @override
  void initState() {
    super.initState();
    databaseReference.once().then((DataSnapshot snapshot) {
      setState(() {
        _initDatabase(snapshot);
      });
    });
  }

  Future<void> _initDatabase(snapshot) async {
    finalDict = List<Map>.from(snapshot.value);
    sampleDict = List<Map>.from(finalDict);
  }

  // Future<void> _initDatabase() async {
  //   await databaseReference.once().then((DataSnapshot snapshot) {
  //     finalDict = List<Map>.from(snapshot.value);
  //     print(snapshot.value);
  //     print('data!!!!!!!!!!!!!!');
  //   });
  //   print(finalDict);
  //   sampleDict = List<Map>.from(finalDict);
  // }

  _DictContentState() {
    // _initDatabase();
    // sampleDict = List<Map>.from(finalDict);
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
                      padding: EdgeInsets.fromLTRB(10, 0, 8, 0),
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
                                  i['Word'],
                                  style: GoogleFonts.playfairDisplay(
                                    textStyle: new TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
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
                                    i['Word'],
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
                          SizedBox(width: 5, height: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  width: MediaQuery.of(context).size.width / 2 -
                                      30,
                                  height:
                                      MediaQuery.of(context).size.height / 6,
                                  child: Text(
                                    i['Translation'],
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.playfairDisplay(
                                      textStyle: new TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Flexible(
                              //   child: Container(
                              //     margin: EdgeInsets.zero,
                              //     padding: EdgeInsets.zero,
                              //     width: MediaQuery.of(context).size.width / 2 -
                              //         20,
                              //     height:
                              //         MediaQuery.of(context).size.height / 6,
                              //     child: Text(
                              //       i['Word'],
                              //       textAlign: TextAlign.right,
                              //       style: GoogleFonts.montserrat(
                              //         textStyle: new TextStyle(
                              //           fontSize: 11,
                              //           fontWeight: FontWeight.w500,
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
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
