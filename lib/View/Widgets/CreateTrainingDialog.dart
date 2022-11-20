import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';

class CreateTrainingDialog extends StatefulWidget {
  DateTime daySelected = DateTime.now();

  CreateTrainingDialog(this.daySelected);

  @override
  _CreateTrainingDialogState createState() => _CreateTrainingDialogState();
}

class _CreateTrainingDialogState extends State<CreateTrainingDialog> {
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isRecurrent = false;
  String dropdownSessionType = "Select";
  String dropdownRecursion = "1 Week";
  List<bool> daysSelected = [false, true, true, true, true, true, false];
  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  List<String> recursionList = ['1 Week', "2 Weeks", "1 Month", "2 Months"];
  bool isStartTimeSelected = false;
  var dateFormat = DateFormat("hh:mm a");

  //TimeOfDay startTimeSelected = TimeOfDay.fromDateTime(DateTime.now());
  DateTime startTimeFormatted = DateTime.now();

  Future<void> confirmSession() async {
    if (isStartTimeSelected) {
      if (dropdownSessionType != "Select") {
        if (priceController.value.text.trim().length > 0) {
          if (descriptionController.value.text.trim().length > 0) {
            EasyLoading.show();
            String response = "";
            String dateTime = widget.daySelected.toString().split(" ")[0] +
                " " +
                startTimeFormatted.toString().split(" ")[1].substring(0, 8);
            if (isRecurrent) {
              response = await APICalls.createSession(
                  dateTime: dateTime,
                  sessionType: Controller.dropdownSessionTypes
                      .indexOf(dropdownSessionType)
                      .toString(),
                  price: priceController.value.text.trim(),
                  description: descriptionController.value.text.trim(),
                  recursionType: "2",
                  duration:
                      (recursionList.indexOf(dropdownRecursion) + 1).toString(),
                  sunday: daysSelected[0] ? "1" : "0",
                  monday: daysSelected[1] ? "1" : "0",
                  tuesday: daysSelected[2] ? "1" : "0",
                  wednesday: daysSelected[3] ? "1" : "0",
                  thursday: daysSelected[4] ? "1" : "0",
                  friday: daysSelected[5] ? "1" : "0",
                  saturday: daysSelected[6] ? "1" : "0");
            } else {
              response = await APICalls.createSession(
                  dateTime: dateTime,
                  sessionType: Controller.dropdownSessionTypes
                      .indexOf(dropdownSessionType)
                      .toString(),
                  price: priceController.value.text.trim(),
                  description: descriptionController.value.text.trim(),
                  recursionType: "1");
            }
            EasyLoading.dismiss();
            Controller.showSnackBar(response, context);
            if (response == "Session Created Successfully" ||
                response == "Sessions Created Successfully") {
              Navigator.of(context).pop();
            }
          } else {
            Controller.showSnackBar("Enter a description", context);
          }
        } else {
          Controller.showSnackBar("Enter a price", context);
        }
      } else {
        Controller.showSnackBar("Select a session type", context);
      }
    } else {
      Controller.showSnackBar("Select a time", context);
    }
  }

  String adjustTimeDigits(int value) {
    String temp = value.toString();
    if (temp.length == 1) {
      return "0$value";
    } else {
      return temp;
    }
  }

  Widget getDayCircle(String day, int index) {
    return GestureDetector(
      child: CircleAvatar(
        radius: SizeConfig.width15,
        backgroundColor: daysSelected[index] ? Color(0xffF9C303) : Colors.white,
        child: Text(
          day,
          style: TextStyle(
              color: daysSelected[index] ? Colors.white : Colors.black),
        ),
      ),
      onTap: () {
        setState(() {
          daysSelected[index] = !daysSelected[index];
        });
      },
    );
  }

  Widget getRecurrentSettings() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Repeat",
                style: TextStyle(color: Colors.white),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.width20, vertical: 0),
                height: SizeConfig.height35,
                width: SizeConfig.width140,
                decoration: BoxDecoration(
                    color: Color(0xffF9C303),
                    borderRadius: BorderRadius.circular(SizeConfig.height15)),
                child: DropdownButton<String>(
                  dropdownColor: Color(0xffF9C303),
                  value: dropdownRecursion,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: SizeConfig.width24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.all(0),
                    color: Colors.transparent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownRecursion = newValue!;
                    });
                  },
                  items: recursionList
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
          Container(
            padding: EdgeInsets.only(
                top: SizeConfig.height15, bottom: SizeConfig.height15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getDayCircle("S", 0),
                getDayCircle("M", 1),
                getDayCircle("T", 2),
                getDayCircle("W", 3),
                getDayCircle("T", 4),
                getDayCircle("F", 5),
                getDayCircle("S", 6),
              ],
            ),
          ),
        ],
      ),
    );
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
          child: Form(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Session : ${widget.daySelected.day}, ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.height18,
                    ),
                  ),
                  Text(
                    months[widget.daySelected.month - 1],
                    style: TextStyle(
                      color: Color(0xffF9C303),
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.height18,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: SizeConfig.height30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Time",
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.width25, vertical: 0),
                      height: SizeConfig.height35,
                      width: SizeConfig.width135,
                      decoration: BoxDecoration(
                          color: Color(0xffF9C303),
                          borderRadius:
                              BorderRadius.circular(SizeConfig.height15)),
                      child: Center(
                        child: Text(isStartTimeSelected
                            ? dateFormat.format(startTimeFormatted)
                            : "Select"),
                      ),
                    ),
                    onTap: () async {
                      DatePicker.showTime12hPicker(
                        context,
                        showTitleActions: true,
                        currentTime: DateTime.now(),
                        onChanged: (date) {},
                        onConfirm: (date) {
                          DateTime newDate = DateTime.parse(
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
                          }
                        },
                      );
                    },
                  )
                ],
              ),
              SizedBox(
                height: SizeConfig.height15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Session",
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.width25, vertical: 0),
                    height: SizeConfig.height35,
                    width: SizeConfig.width135,
                    decoration: BoxDecoration(
                        color: Color(0xffF9C303),
                        borderRadius:
                            BorderRadius.circular(SizeConfig.height15)),
                    child: DropdownButton<String>(
                      dropdownColor: Color(0xffF9C303),
                      value: dropdownSessionType,
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
                          dropdownSessionType = newValue!;
                        });
                      },
                      items: Controller.dropdownSessionTypes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: SizeConfig.width14),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: SizeConfig.height15,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Price",
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
                          controller: priceController,
                          //initialValue: "10",
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.black,
                          maxLines: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          onChanged: (value) {
                            if (double.parse(value) < 1) {
                              priceController.text = "1";
                            } else if (double.parse(value) > 9999) {
                              priceController.text = "9999";
                            }
                          },
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
                                top: SizeConfig.height11,
                                right: SizeConfig.width15),
                            hintText: "\$ 20",
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.height15,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Description",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.height8,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      //padding: EdgeInsets.symmetric(horizontal: SizeConfig.width10, vertical: 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(SizeConfig.height15)),
                      child: TextField(
                        controller: descriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        cursorColor: Colors.black,
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
                              top: SizeConfig.height11,
                              right: SizeConfig.width15),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: Colors.white,
                        ),
                        child: Checkbox(
                          activeColor: Color(0xffF9C303),
                          value: isRecurrent,
                          onChanged: (value) {
                            setState(() {
                              isRecurrent = !isRecurrent;
                            });
                          },
                        ),
                      ),
                      Text(
                        'Recurrent',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  Container(
                    child: isRecurrent
                        ? getRecurrentSettings()
                        : SizedBox.shrink(),
                  ),
                ],
              ),
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
                      confirmSession();
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
          )),
        ),
      ),
    );
  }
}
