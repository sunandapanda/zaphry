import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';

class InquiryDialog extends StatefulWidget {
  String eventID;

  InquiryDialog(this.eventID);

  @override
  _InquiryDialogState createState() => _InquiryDialogState();
}

class _InquiryDialogState extends State<InquiryDialog> {
  TextEditingController inquiryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xffF9C303),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(SizeConfig.height25),
        ),
      ),
      title: Text("How can we help?"),
      content: Container(
        width: SizeConfig.width400,
        child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: SizeConfig.width25, vertical: 0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(SizeConfig.height8)),
          child: TextField(
            controller: inquiryController,
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: "Inquiry",
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            "Send",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () async {
            if (inquiryController.text.trim().length > 0) {
              EasyLoading.show();
              String response = await APICalls.sendInquiry(
                  widget.eventID, inquiryController.text.trim());
              EasyLoading.dismiss();
              Controller.showSnackBar(response, context);
              if (response == "Inquiry Sent Successfully") {
                Navigator.of(context).pop();
              }
            } else {
              Controller.showSnackBar("Please enter your inquiry", context);
            }
          },
        ),
      ],
    );
  }
}
