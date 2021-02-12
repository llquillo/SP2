import 'package:flutter/material.dart';
import './common_widgets/page_title.dart';
import './sub_pages/level_content.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Drills extends StatefulWidget {
  @override
  _DrillsState createState() => _DrillsState();
}

class _DrillsState extends State<Drills> {
  List buttonsInfo = [
    ["images/basic.png", "u", "basics1"],
    ["images/basic.png", "l", "basics2"],
    ["images/family.png", "l", "family"],
    ["images/school.png", "l", "school"],
    ["images/shopping.png", "l", "shopping"],
    ["images/travel.png", "l", "travel"],
  ];

  String locked = "images/lock.png";
  List<Map> words;
  List<Map> levels;
  List<Map> wordList;
  var databaseInstanceTemp;
  var databaseTemp;

  @override
  void initState() {
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    print(FirebaseAuth.instance.currentUser);
    final databaseReference = FirebaseDatabase.instance.reference();
    print(databaseReference);
    DatabaseReference userDB = databaseReference.child('users').child(user.uid);
    userDB.once().then((DataSnapshot snapshot) {
      setState(() {
        _initDatabase(snapshot);
      });
    });
  }

  String currentUser() {
    User user = FirebaseAuth.instance.currentUser;
    return user.uid;
  }

  Future<void> _initDatabase(snapshot) async {
    // Query _wordQuery = databaseReference.reference().child("word");
    // // print(_wordQuery);
    // print(databaseReference
    //     .reference()
    //     .child("basics1")
    //     .child("Level1")
    //     .child("Words")
    //     .child("1")
    //     .child("Deck")
    //     .set(2));
    // var temp = snapshot.value;
    // // print(temp["basics1"]["Level1"]["Words"]);
    // var tempList = new List<Map>();
    // words = List<Map>.from(temp["basics1"]["Level1"]["Words"]);
    // levels = List<Map>.from(temp["basics1"]);
    // print(levels);
    // // print(words);
    // // var j = 0;
    // // while (j < 1) {
    // //   if (words[j] != null) {
    // //     print(words[j]);
    // //     tempList.add(words[j]);
    // //     print(j);
    // //     j++;
    // //   }
    // // }
    // for (var i = 0; i < 11; i++) {
    //   if (words[i] != null) {
    //     print(words[i]);
    //     tempList.add(words[i]);
    //   }
    // }
    // wordList = List<Map>.from(tempList);
    var curUser = currentUser();
    print(curUser);
    databaseTemp = snapshot.value;
    print(databaseTemp);
  }

  void _setloading(context, wordList, category) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            insetPadding: EdgeInsets.all(50),
            backgroundColor: Colors.transparent,
            child: Container(
              height: MediaQuery.of(context).size.height / 5 - 20,
              width: MediaQuery.of(context).size.width / 2 - 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpinKitChasingDots(
                    size: 40,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Loading',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ));
      },
    );
    new Future.delayed(new Duration(seconds: 2), () {
      Navigator.pop(context);
      _openLevel(context, wordList, category);
    });
  }

  void _openLevel(context, wordList, category) async {
    var currentDB = databaseTemp[category];
    print(databaseTemp);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LevelContent(databaseTemp: currentDB, category: category),
      ),
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
                  if (i[1] == "u") {
                    _setloading(context, wordList, i.last);
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
                        child: i[1] == 'u'
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
