import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';

class InfoDialog extends StatelessWidget {
  String text;

  InfoDialog(this.text);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xffF9C303),
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(Radius.circular(SizeConfig.height25))),
      content: Text(
        text,
        //style: Theme.of(context).textTheme.bodyText2,
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
