import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xffF9C303),
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(Radius.circular(SizeConfig.height25))),
      content: Text(
        "Are you sure you want to logout?",
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
            "Logout",
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () async {
            EasyLoading.show();
            String response = await APICalls.logout();
            EasyLoading.dismiss();
            Controller.showSnackBar(response, context);
            if (response == "Logout Successfully" || response == "Session Closed Successfully") {
              Navigator.of(context).pop(true);
            }
          },
        ),
      ],
    );
  }
}
