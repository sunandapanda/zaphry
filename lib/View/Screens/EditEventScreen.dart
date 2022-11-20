import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';

class EditEventScreen extends StatefulWidget {
  String eventID;

  EditEventScreen(this.eventID);

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String dropdownAgeGroup = 'Select Age Group';

  bool isStartDateSelected = false;
  DateTime startDate = DateTime.now();

  bool isStartTimeSelected = false;
  DateTime startTimeFormatted = DateTime.now();
  var timeFormat = DateFormat("hh:mm a");

  bool inquiring = true;

  bool bannerAttached = false;
  String bannerPath = "";

  bool videoAttached = false;
  String videoPath = "";

  @override
  void initState() {
    super.initState();

    getOldData();
  }

  void getOldData() {
    if (Controller.clubEventDetails != null) {
      EasyLoading.show();
      titleController.text = Controller.clubEventDetails!.title;
      descriptionController.text = Controller.clubEventDetails!.description;
      inquiring = Controller.clubEventDetails!.inquiryStatus == "1";
      dropdownAgeGroup = getAgeGroupName();
      setDateAndTime();
      EasyLoading.dismiss();
    } else {
      Controller.showSnackBar(
          "Unable to process request at the moment", context);
      Navigator.of(context).pop(false);
    }
  }

  String getAgeGroupName() {
    if (Controller.clubEventDetails!.ageGroup == "0") {
      return "Any";
    } else {
      return "Under " + Controller.clubEventDetails!.ageGroup;
    }
  }

  setDateAndTime() {
    setState(() {
      String tempDate = DateTime.fromMillisecondsSinceEpoch(
              int.parse(Controller.clubEventDetails!.startDateTime) * 1000)
          .toString();
      startDate = DateTime.parse(tempDate);
      startTimeFormatted = DateTime.parse(tempDate);

      print(tempDate);

      isStartDateSelected = true;
      isStartTimeSelected = true;
    });
  }

  String getAgeGroupID() {
    return Controller
        .ageGroupValues[Controller.ageGroupTexts.indexOf(dropdownAgeGroup)]
        .toString();
  }

  String getStartDateTime() {
    //String time = timeFormat.format(startTimeFormatted).split(" ")[0];
    String date = startDate.toString().split(" ")[0];
    DateTime temp = DateTime.parse(
        date + " " + startTimeFormatted.toString().split(" ")[1]);
    return ((temp.millisecondsSinceEpoch / 1000).truncate()).toString();
  }

  bool validateData() {
    if (titleController.value.text.trim().length > 0) {
      if (descriptionController.value.text.trim().length > 0) {
        if (isStartDateSelected) {
          if (isStartTimeSelected) {
            if (dropdownAgeGroup != "Select Age Group") {
              return true;
            } else {
              Controller.showSnackBar("Please select an age group", context);
            }
          } else {
            Controller.showSnackBar("Please select a time", context);
          }
        } else {
          Controller.showSnackBar("Please select a date", context);
        }
      } else {
        Controller.showSnackBar("Please add description", context);
      }
    } else {
      Controller.showSnackBar("Please add a title", context);
    }
    return false;
  }

  void saveOnPressed() async {
    bool check = validateData();
    if (check) {
      EasyLoading.show();
      String response = await APICalls.editEvent(
          eventID: widget.eventID,
          title: titleController.value.text.trim(),
          description: descriptionController.value.text.trim(),
          ageGroups: getAgeGroupID(),
          startDateTime: getStartDateTime(),
          inquiring: inquiring ? "1" : "0",
          image: bannerPath,
          video: videoPath,
          sendVideo: videoAttached,
          sendImage: bannerAttached);
      EasyLoading.dismiss();
      Controller.showSnackBar(response, context);
      if (response == "Successfully Updated Event") {
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9C303),
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.width25),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  0, //SizeConfig.width25,
                  SizeConfig.height40,
                  0, //SizeConfig.width25,
                  SizeConfig.height30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackButton(),
                    Text(
                      "Edit Event",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.height20,
                          fontWeight: FontWeight.bold),
                    ),
                    BackButton(
                      color: Colors.transparent,
                      onPressed: () {
                        // do nothing
                      },
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                    hintText: "Enter Title",
                    labelText: "Title",
                    labelStyle: TextStyle(
                      color: Colors.black,
                    )),
              ),
              SizedBox(height: SizeConfig.height10),
              DropdownButton<String>(
                isExpanded: true,
                value: dropdownAgeGroup,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
                iconSize: SizeConfig.height24,
                elevation: 16,
                dropdownColor: Colors.white,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: SizeConfig.height15,
                ),
                underline: Container(
                  height: SizeConfig.height1,
                  color: Colors.black,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownAgeGroup = newValue!;
                  });
                },
                items: Controller.ageGroupTexts
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: SizeConfig.height10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Start Date",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.height16,
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.width25, vertical: 0),
                      height: SizeConfig.height35,
                      width: SizeConfig.width135,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius:
                              BorderRadius.circular(SizeConfig.height15)),
                      child: Center(
                        child: Text(
                          isStartDateSelected
                              ? startDate.toString().split(" ")[0]
                              : "Select",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.width16,
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        currentTime: DateTime.now(),
                        onChanged: (date) {},
                        onConfirm: (date) {
                          setState(() {
                            startDate = date;
                            isStartDateSelected = true;
                          });
                        },
                      );
                    },
                  )
                ],
              ),
              SizedBox(height: SizeConfig.height10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Start Time",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.height16,
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.width25, vertical: 0),
                      height: SizeConfig.height35,
                      width: SizeConfig.width135,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius:
                              BorderRadius.circular(SizeConfig.height15)),
                      child: Center(
                        child: Text(
                          isStartTimeSelected
                              ? timeFormat.format(startTimeFormatted)
                              : "Select",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.width16,
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      DatePicker.showTime12hPicker(
                        context,
                        showTitleActions: true,
                        currentTime: DateTime.now(),
                        onChanged: (date) {},
                        onConfirm: (date) {
                          /*DateTime newDate = DateTime.parse(
                              widget.daySelected.toString().split(" ")[0] +
                                  " " +
                                  date.toString().split(" ")[1]);
                          DateTime checkTime = DateTime.now();
                          checkTime = checkTime.add(Duration(minutes: 10));
                          if (newDate.isBefore(checkTime)) {
                            Controller.showSnackBar(
                                "Time should be at least 10 mins in the future",
                                context);
                          } else {
                            setState(() {
                              startTimeFormatted = date;
                              isStartTimeSelected = true;
                            });
                          }*/
                          setState(() {
                            startTimeFormatted = date;
                            isStartTimeSelected = true;
                          });
                        },
                      );
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Inquiring",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.height16,
                    ),
                  ),
                  Switch(
                    value: inquiring,
                    onChanged: (value) {
                      setState(() {
                        inquiring = value;
                      });
                    },
                    activeColor: Colors.green,
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.height10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Description",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.height16,
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.height5),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.width15, vertical: 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(SizeConfig.height8)),
                child: TextField(
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Enter event details",
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
                    "Banner",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.height16,
                    ),
                  ),
                  Container(
                    width: SizeConfig.width135,
                    child: ElevatedButton(
                      onPressed: () async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            bannerAttached = true;
                            bannerPath = image.path;
                          });
                        }
                      },
                      child: Text(
                        bannerAttached ? "Attached" : "Pick image",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.height25),
                            ),
                          ),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: SizeConfig.width25))),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.height10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Video",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.height16,
                    ),
                  ),
                  Container(
                    width: SizeConfig.width135,
                    child: ElevatedButton(
                      onPressed: () async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? video = await _picker.pickVideo(
                            source: ImageSource.gallery);
                        if (video != null) {
                          setState(() {
                            videoAttached = true;
                            videoPath = video.path;
                          });
                        }
                      },
                      child: Text(
                        videoAttached ? "Attached" : "Pick video",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.height25),
                            ),
                          ),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: SizeConfig.width25))),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.height20),
              ElevatedButton(
                onPressed: () {
                  saveOnPressed();
                },
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SizeConfig.height25),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: SizeConfig.width50),
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
