import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dictionary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('App Name'),
      ),
      body: new Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: new Column(
            children: [
              SizedBox(height: 25),
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
              // ListView(children: ),
            ],
          )),
    );
  }
}
