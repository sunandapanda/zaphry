import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';

class PromotionalDialog extends StatelessWidget {
  PromotionalDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xffF9C303),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(SizeConfig.height25))),
      content: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
                text: 'Thank you for booking a session with ',
                style: TextStyle(fontSize: 15, color: Colors.black)),
            TextSpan(
              text: 'ZAPHRY',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: '\n\nEnjoy ZAPHRY Promotional Offer!!!!',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: "\n\nAll sessions are currently ",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: 'free',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: ". It's a limited-time offer.",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
