import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';

class EditVideoDialog extends StatefulWidget {
  const EditVideoDialog({Key? key}) : super(key: key);

  @override
  _EditVideoDialogState createState() => _EditVideoDialogState();
}

class _EditVideoDialogState extends State<EditVideoDialog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController minutesController = TextEditingController();
  TextEditingController secondsController = TextEditingController();

  String dropdownCategoryValue = Controller.videoCategoryNames[0];
  String dropdownRecipients = "Both";

  bool status = true;

  List<String> recipientsDropdownList = ["Both", "Players", "Coaches"];

  bool showError = false;
  String errorMessage = "Error";

  @override
  void initState() {
    super.initState();

    titleController.text = Controller.videoDetails!.title;
    descriptionController.text = Controller.videoDetails!.description;
    minutesController.text = Controller.videoDetails!.duration.split(":")[0];
    secondsController.text = Controller.videoDetails!.duration.split(":")[1];
    dropdownCategoryValue = Controller.videoDetails!.category;
    dropdownRecipients = getRecipientsNames();
    status = Controller.videoDetails!.status == "1" ? true : false;
  }

  String getRecipientsNames() {
    if (Controller.videoDetails!.recipients == "1") {
      return "Both";
    } else if (Controller.videoDetails!.recipients == "2") {
      return "Players";
    } else {
      return "Coaches";
    }
  }

  void showErrorFunction(String err) {
    setState(() {
      showError = true;
      errorMessage = err;
    });
  }

  bool validateFields() {
    if (titleController.value.text.trim().length > 0) {
      if (descriptionController.value.text.trim().length > 0) {
        if (minutesController.value.text.trim().length > 0) {
          if (secondsController.value.text.trim().length > 0) {
            return true;
          } else {
            showErrorFunction("Please enter duration");
          }
        } else {
          showErrorFunction("Please enter duration");
        }
      } else {
        showErrorFunction("Please enter a description");
      }
    } else {
      showErrorFunction("Please enter a title");
    }
    return false;
  }

  String getCategoryID() {
    return Controller.videoCategoryIDs[
        Controller.videoCategoryNames.indexOf(dropdownCategoryValue)];
  }

  String getRecipientsID() {
    if (dropdownRecipients == "Both") {
      return "1";
    } else if (dropdownRecipients == "Players") {
      return "2";
    } else {
      return "3";
    }
  }

  String getDuration() {
    String minutes = minutesController.value.text.trim();
    if (minutes.length < 2) {
      minutes = "0" + minutes;
    }
    String seconds = secondsController.value.text.trim();
    if (seconds.length < 2) {
      seconds = "0" + seconds;
    }
    return minutes + ":" + seconds;
  }

  Future<void> onConfirmPressed() async {
    bool check = validateFields();
    if (check) {
      EasyLoading.show();
      String response = await APICalls.editVideo(
          videoID: Controller.videoDetails!.id.toString(),
          title: titleController.value.text.trim(),
          description: descriptionController.value.text.trim(),
          category: getCategoryID(),
          recipients: getRecipientsID(),
          status: status ? "1" : "2",
          duration: getDuration());
      EasyLoading.dismiss();
      Controller.showSnackBar(response, context);
      if (response == "Successfully Updated Video") {
        setState(() {
          Controller.videoDetails!.title = titleController.value.text.trim();
          Controller.videoDetails!.description =
              descriptionController.value.text.trim();
          Controller.videoDetails!.category = dropdownCategoryValue;
          Controller.videoDetails!.recipients = getRecipientsID();
          Controller.videoDetails!.status = status ? "1" : "2";
          Controller.videoDetails!.duration = getDuration();
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      contentPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.width15, vertical: SizeConfig.height30),
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(SizeConfig.height25))),
      content: SingleChildScrollView(
        child: Container(
          width: SizeConfig.width400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  "Edit Video",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: SizeConfig.height10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Title",
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(
                    height: SizeConfig.height35,
                    width: SizeConfig.width135,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(SizeConfig.height15)),
                    child: TextFormField(
                      controller: titleController,
                      //initialValue: "10",
                      textAlign: TextAlign.center,
                      cursorColor: Colors.black,
                      maxLines: 1,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.height15),
                        ),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: SizeConfig.width15,
                            bottom: SizeConfig.height11,
                            top: SizeConfig.height5,
                            right: SizeConfig.width15),
                        hintText: "Title",
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.height10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Category",
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.width25, vertical: 0),
                    height: SizeConfig.height35,
                    width: SizeConfig.width135,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(SizeConfig.height15)),
                    child: DropdownButton<String>(
                      dropdownColor: Color(0xffF9C303),
                      value: dropdownCategoryValue,
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
                          dropdownCategoryValue = newValue!;
                        });
                      },
                      items: Controller.videoCategoryNames
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
              SizedBox(height: SizeConfig.height10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Description",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: SizeConfig.height5),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.width25, vertical: 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(SizeConfig.height8)),
                child: TextField(
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "Video Description",
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.height10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Duration",
                    style: TextStyle(color: Colors.white),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: SizeConfig.height35,
                        width: SizeConfig.width50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(SizeConfig.height15)),
                        child: Center(
                          child: TextFormField(
                            controller: minutesController,
                            //initialValue: "10",
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.black,
                            maxLines: 1,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(2),
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]')),
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(SizeConfig.height15),
                              ),
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: SizeConfig.width5,
                                  bottom: SizeConfig.height13,
                                  top: SizeConfig.height5,
                                  right: SizeConfig.width5),
                              hintText: "mm",
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "   :   ",
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        height: SizeConfig.height35,
                        width: SizeConfig.width50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(SizeConfig.height15)),
                        child: TextFormField(
                          controller: secondsController,
                          //initialValue: "10",
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.black,
                          maxLines: 1,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(2),
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.height15),
                            ),
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: SizeConfig.width5,
                                bottom: SizeConfig.height13,
                                top: SizeConfig.height5,
                                right: SizeConfig.width5),
                            hintText: "ss",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.height10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recipients",
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.width25, vertical: 0),
                    height: SizeConfig.height35,
                    width: SizeConfig.width135,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(SizeConfig.height15)),
                    child: DropdownButton<String>(
                      dropdownColor: Color(0xffF9C303),
                      value: dropdownRecipients,
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
                          dropdownRecipients = newValue!;
                        });
                      },
                      items: recipientsDropdownList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
              SizedBox(height: SizeConfig.height10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Active",
                    style: TextStyle(color: Colors.white),
                  ),
                  Switch(
                    value: status,
                    onChanged: (value) {
                      setState(() {
                        status = value;
                      });
                    },
                  )
                ],
              ),
              SizedBox(height: SizeConfig.height10),
              showError
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : SizedBox.shrink(),
              SizedBox(height: SizeConfig.height20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.height25),
                          ),
                        ),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                            horizontal: SizeConfig.width25))),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onConfirmPressed();
                    },
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xffF9C303)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.height25),
                          ),
                        ),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                            horizontal: SizeConfig.width25))),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
