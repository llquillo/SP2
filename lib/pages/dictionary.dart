import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './common_widgets/dict_button.dart';
import './sub_pages/dict_content.dart';

class Dictionary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('App Name'),
      ),
      body: new Container(
        // alignment: Alignment(-0.5, 0.5),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: new Column(
          children: [
            SizedBox(height: 30),
            new Container(
              alignment: Alignment(-0.8, -0.7),
              child: Text(
                'Dictionary',
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
            new Container(
              // alignment: Alignment(1.0, 1.0),
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20),
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  Container(
                    child: DictButton(
                      buttonName: "Basic Expressions",
                      buttonImage: 'images/basic.png',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DictContent()),
                        );
                      },
                    ),
                  ),
                  Container(
                    child: DictButton(
                      buttonName: "Family",
                      buttonImage: 'images/family.png',
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    child: DictButton(
                      buttonName: "School",
                      buttonImage: 'images/school.png',
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    child: DictButton(
                      buttonName: "Shopping",
                      buttonImage: 'images/shopping.png',
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    child: DictButton(
                      buttonName: "Travel",
                      buttonImage: 'images/travel.png',
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 0, 20, 2),
              alignment: Alignment.bottomLeft,
              child: Image.asset('images/study.png'),
            )
          ],
        ),
      ),
    );
  }
}
