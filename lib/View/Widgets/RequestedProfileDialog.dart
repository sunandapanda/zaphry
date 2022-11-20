import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';

class RequestedProfileDialog extends StatefulWidget {
  const RequestedProfileDialog({Key? key}) : super(key: key);

  @override
  _RequestedProfileDialogState createState() => _RequestedProfileDialogState();
}

class _RequestedProfileDialogState extends State<RequestedProfileDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xffF9C303),
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(SizeConfig.height25),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: SizeConfig.height55,
            backgroundColor: Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(SizeConfig.height55),
              child: CircleAvatar(
                backgroundColor: Color(0xffF9C303),
                radius: SizeConfig.height50,
                child: Image.network(Controller.requestedProfile!.image),
              ),
            ),
          ),
          SizedBox(height: SizeConfig.height10),
          Text(
            Controller.requestedProfile!.firstName +
                " " +
                Controller.requestedProfile!.lastName,
            style: TextStyle(
              color: Colors.black,
              fontSize: SizeConfig.height17,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: SizeConfig.height5),
          Text(
            Controller.requestedProfile!.userType == "1" ? "Coach" : "Player",
            style: TextStyle(
              color: Colors.black,
              fontSize: SizeConfig.height15,
            ),
          ),
          Divider(color: Colors.black),
          Controller.requestedProfile!.email != null
              ? SizedBox(height: SizeConfig.height10)
              : SizedBox.shrink(),
          Controller.requestedProfile!.email != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Email",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.width15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      Controller.requestedProfile!.email!,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.width15,
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink(),
          Controller.requestedProfile!.phoneNo != null
              ? SizedBox(height: SizeConfig.height10)
              : SizedBox.shrink(),
          Controller.requestedProfile!.phoneNo != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Phone No.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.width15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      Controller.requestedProfile!.phoneNo!,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.width15,
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink(),
          Controller.requestedProfile!.dob != null
              ? SizedBox(height: SizeConfig.height10)
              : SizedBox.shrink(),
          Controller.requestedProfile!.dob != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "DOB",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.width15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      Controller.requestedProfile!.dob!,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.width15,
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink(),
          SizedBox(height: SizeConfig.height10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Gender",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: SizeConfig.width15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                Controller.requestedProfile!.gender,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: SizeConfig.width15,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.height10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Zip Code",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: SizeConfig.width15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                Controller.requestedProfile!.zipCode,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: SizeConfig.width15,
                ),
              ),
            ],
          ),
          Controller.requestedProfile!.meetingLink != null
              ? SizedBox(height: SizeConfig.height10)
              : SizedBox.shrink(),
          Controller.requestedProfile!.meetingLink != null
              ? GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Meeting Link     ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          Controller.requestedProfile!.meetingLink!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.width15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onLongPress: () {
                    FlutterClipboard.copy(
                            Controller.requestedProfile!.meetingLink!)
                        .then((value) => Controller.showSnackBar(
                            "Copied to Clipboard", context));
                  },
                )
              : SizedBox.shrink(),
          SizedBox(height: SizeConfig.height10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "About Me:",
              style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.width15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: SizeConfig.height5),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              Controller.requestedProfile!.aboutMe,
              style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.width15,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            "Dismiss",
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
