import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Screens/VideoPlayerSingleScreen.dart';

import 'PhotoViewerScreen.dart';

class TrainingProgramDetailsScreen extends StatefulWidget {
  const TrainingProgramDetailsScreen({Key? key}) : super(key: key);

  @override
  _TrainingProgramDetailsScreenState createState() =>
      _TrainingProgramDetailsScreenState();
}

class _TrainingProgramDetailsScreenState
    extends State<TrainingProgramDetailsScreen> {
  void viewAttachment(int index) {
    String? attachmentType = lookupMimeType(
        Controller.trainingProgramDetails!.variants[index].attachment!);
    if (attachmentType != null) {
      print("attachment type: " + attachmentType);
      if (attachmentType.startsWith("image")) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoViewerScreen(0, [
              Controller.trainingProgramDetails!.variants[index].attachment!
            ]),
          ),
        );
      } else if (attachmentType.startsWith("video")) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerSingleScreen(
                Controller.trainingProgramDetails!.variants[index].attachment!),
          ),
        );
      } else {
        Controller.showSnackBar("Unable to view attachment", context);
      }
    }
  }

  Widget getVariantItem(int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: SizeConfig.height15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Variant Title",
              style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.height18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              Controller.trainingProgramDetails!.variants[index].title,
              style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.width17,
              ),
            ),
          ],
        ),
        Divider(color: Colors.white),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Description:",
            style: TextStyle(
              color: Colors.black,
              fontSize: SizeConfig.height18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: SizeConfig.height10),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            Controller.trainingProgramDetails!.variants[index].description,
            style: TextStyle(
              color: Colors.black,
              fontSize: SizeConfig.width17,
            ),
          ),
        ),
        Divider(color: Colors.white),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Duration",
              style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.height18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              Controller.trainingProgramDetails!.variants[index].duration +
                  " Weeks",
              style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.width17,
              ),
            ),
          ],
        ),
        Divider(color: Colors.white),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Start Date-Time",
              style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.height18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              Controller.trainingProgramDetails!.variants[index].startDateTime,
              style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.width17,
              ),
            ),
          ],
        ),
        Controller.trainingProgramDetails!.variants[index].attachment != null
            ? Divider(color: Colors.white)
            : SizedBox.shrink(),
        Controller.trainingProgramDetails!.variants[index].attachment != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Attachment",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.height18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      viewAttachment(index);
                    },
                    child: Text(
                      "View",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.height25),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                  ),
                ],
              )
            : SizedBox.shrink(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9C303),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.height10,
              horizontal: SizeConfig.width15,
            ),
            child: Column(
              children: [
                SizedBox(height: SizeConfig.height10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackButton(),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        Controller.trainingProgramDetails!.title,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.height20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    BackButton(color: Colors.transparent),
                  ],
                ),
                SizedBox(height: SizeConfig.height10),
                Container(
                  height: SizeConfig.height600,
                  child: ListView.separated(
                    itemCount:
                        Controller.trainingProgramDetails!.variants.length,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.black,
                      thickness: 3,
                    ),
                    itemBuilder: (context, index) => getVariantItem(index),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
