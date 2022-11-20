import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';

class FeedbackDialog extends StatefulWidget {
  String sessionID = "";
  String time = "";
  String date = "";
  String sessionType = "";
  String? coach = "";

  FeedbackDialog(this.sessionID, this.time, this.date, this.sessionType,
      {this.coach});

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  String dropdownDelivery = "Delivered & it was Good";
  List<String> deliveryList = [
    "Delivered & it was Good",
    "Delivered but not Good",
    "Not Delivered"
  ];
  TextEditingController remarksController = TextEditingController();
  double userRating = 3;
  bool showError = false;

  String getDeliveryInteger(String str) {
    if (str == "Not Delivered") {
      return "0";
    } else if (str == "Delivered & it was Good") {
      return "1";
    } else {
      return "2";
    }
  }

  Widget getRatingItems() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RatingBar.builder(
                    itemSize: 20,
                    initialRating: userRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.width2,
                        vertical: SizeConfig.height15),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.black,
                    ),
                    onRatingUpdate: (rating) {
                      userRating = rating;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(SizeConfig.height15)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.height8, horizontal: SizeConfig.width8),
            child: TextFormField(
              controller: remarksController,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.height15),
                ),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    vertical: SizeConfig.height10,
                    horizontal: SizeConfig.width10),
                hintText: "Remarks",
              ),
            ),
          ),
        ),
        showError
            ? Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: SizeConfig.height15,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Enter your remarks.",
                      style: TextStyle(
                          color: Colors.red, fontSize: SizeConfig.width15),
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
    return AlertDialog(
      scrollable: true,
      contentPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.width20, vertical: SizeConfig.height20),
      backgroundColor: Color(0xffF9C303),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(SizeConfig.height25))),
      content: SingleChildScrollView(
        child: Container(
          width: SizeConfig.width390,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.height25),
            color: Color(0xffF9C303),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: Icon(
                      Icons.clear,
                      size: SizeConfig.height18,
                    ),
                    onTap: () => Navigator.of(context).pop(false),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Column(
                      children: [
                        Text(
                          widget.date,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: SizeConfig.width15,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.time,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: SizeConfig.width15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.width5),
                          height: SizeConfig.height30,
                          child: VerticalDivider(
                            color: Colors.black,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.sessionType,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: SizeConfig.width15,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.coach != null ? widget.coach! : "",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: SizeConfig.width10,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ]),
                ],
              ),
              SizedBox(
                height: SizeConfig.height20,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.width25, vertical: 0),
                height: SizeConfig.height40,
                width: SizeConfig.width230,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(SizeConfig.height15)),
                child: DropdownButton<String>(
                  dropdownColor: Colors.white,
                  value: dropdownDelivery,
                  //icon: const Icon(Icons.arrow_drop_down),
                  //iconSize: SizeConfig.width24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: SizeConfig.height2,
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.all(0),
                    color: Colors.transparent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownDelivery = newValue!;
                    });
                  },
                  items: deliveryList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: SizeConfig.width10),
                      ),
                    );
                  }).toList(),
                ),
              ),
              dropdownDelivery != "Not Delivered"
                  ? getRatingItems()
                  : SizedBox.shrink(),
              SizedBox(
                height: SizeConfig.height15,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      showError = false;
                    });
                    if (remarksController.value.text.trim().length > 0) {
                      EasyLoading.show();
                      String response = "";
                      if (Controller.memberType == 1) {
                        response = await APICalls.coachSessionFeedback(
                            widget.sessionID,
                            getDeliveryInteger(dropdownDelivery),
                            userRating.toString(),
                            remarksController.value.text.trim());
                      } else if (Controller.memberType == 2) {
                        response = await APICalls.playerSessionFeedback(
                            widget.sessionID,
                            getDeliveryInteger(dropdownDelivery),
                            userRating.toString(),
                            remarksController.value.text.trim());
                      }
                      EasyLoading.dismiss();
                      Controller.showSnackBar(response, context);
                      if (response == "Feedback Successfully Submitted ") {
                        Navigator.of(context).pop(true);
                      }
                    } else {
                      setState(() {
                        showError = true;
                      });
                    }
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.black,
                    ),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: SizeConfig.width25)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.height15),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
