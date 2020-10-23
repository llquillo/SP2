import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Stories extends StatefulWidget {
  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
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
            'Stories',
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
