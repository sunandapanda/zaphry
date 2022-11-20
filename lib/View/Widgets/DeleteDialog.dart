import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xffF9C303),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(SizeConfig.height25),
        ),
      ),
      content: Text(
        "Are you sure you want to delete?",
        //style: Theme.of(context).textTheme.bodyText2,
      ),
      actions: [
        TextButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
