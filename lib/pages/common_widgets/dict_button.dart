import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DictButton extends StatelessWidget {
  DictButton({
    @required this.buttonName,
    @required this.buttonImage,
    this.imgH,
    this.imgW,
    this.onPressed,
  });

  final String buttonName;
  final String buttonImage;
  final double imgH;
  final double imgW;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20)),
        // color: Color(0xffa2d2ff),
        boxShadow: [
          BoxShadow(
            color: Color(0xffbde0fe).withOpacity(0.8),
            spreadRadius: 3,
            blurRadius: 5,
            // offset: Offset(0, 4),
          )
        ],
      ),
      margin: EdgeInsets.fromLTRB(11, 5, 11, 5),
      // padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      width: 10,
      height: (MediaQuery.of(context).size.height / 5) - 100,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
        color: Color(0xffa2d2ff),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              buttonName,
              style: GoogleFonts.fredokaOne(
                textStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            Image.asset(
              buttonImage,
              height: imgH,
              width: imgW,
            ),
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}
