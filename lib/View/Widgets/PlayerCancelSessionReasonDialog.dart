import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';

import 'CancelDialog.dart';

class PlayerCancelSessionReasonDialog extends StatefulWidget {
  int index = 0;

  PlayerCancelSessionReasonDialog(this.index);

  @override
  _PlayerCancelSessionReasonDialogState createState() =>
      _PlayerCancelSessionReasonDialogState();
}

class _PlayerCancelSessionReasonDialogState extends State<PlayerCancelSessionReasonDialog> {
  TextEditingController reasonController = TextEditingController();

  Widget getSessionInfoContainer() {
    return Container(
      padding: EdgeInsets.only(bottom: SizeConfig.height10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.height20),
        color: Color(0xffF9C303),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Text(
                  Controller.playerUpcomingSessions[widget.index].date,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.height15,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  Controller.playerUpcomingSessions[widget.index].startTime,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.height15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.width5),
              height: SizeConfig.height30,
              child: VerticalDivider(
                color: Colors.black,
                thickness: 1,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Controller.playerUpcomingSessions[widget.index].sessionType,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.height15,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  Controller.playerUpcomingSessions[widget.index].status,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.height10,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getReasonTextField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.width5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig.height8),
      ),
      child: TextField(
        controller: reasonController,
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          hintText: "Enter reason here",
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xffF9C303),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(SizeConfig.height25),
        ),
      ),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getSessionInfoContainer(),
            getReasonTextField(),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            "Back",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: Text(
            "Proceed",
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () async {
            if (reasonController.value.text.trim().length > 0) {
              bool result = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CancelDialog();
                },
              );
              if (result) {
                Navigator.of(context).pop(reasonController.value.text.trim());
              } else {
                Navigator.of(context).pop(false);
              }
            } else {
              Controller.showSnackBar("Please enter a reason", context);
            }
          },
        ),
      ],
    );
  }
}
