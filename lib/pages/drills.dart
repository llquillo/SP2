import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Drills extends StatefulWidget {
  @override
  _DrillsState createState() => _DrillsState();
}

class _DrillsState extends State<Drills> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('App Name'),
      ),
      body: new Container(
          child: new Column(
        children: [
          Text(
            'Drills',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
