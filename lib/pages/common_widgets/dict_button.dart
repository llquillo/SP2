import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DictButton extends StatelessWidget {
  DictButton({
    @required this.buttonName,
    @required this.buttonImage,
    this.onPressed,
  });

  final String buttonName;
  final String buttonImage;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            spreadRadius: 7,
            blurRadius: 6,
            offset: Offset(0, 4),
          )
        ],
      ),
      margin: EdgeInsets.fromLTRB(11, 5, 11, 5),
      width: 10,
      height: (MediaQuery.of(context).size.height / 5) - 80,
      child: RaisedButton(
        color: Colors.black87,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              buttonName,
              style: GoogleFonts.playfairDisplay(
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w200,
                  color: Colors.white,
                ),
              ),
            ),
            Image.asset(buttonImage),
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}
