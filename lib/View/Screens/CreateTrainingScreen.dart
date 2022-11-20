import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Widgets/CreateTrainingDialog.dart';
import 'package:zaphry/View/Widgets/mydrawer.dart';
import 'package:zaphry/View/Widgets/navbarwhite.dart';

class CreateTrainingScreen extends StatefulWidget {
  const CreateTrainingScreen({Key? key}) : super(key: key);

  @override
  _CreateTrainingScreenState createState() => _CreateTrainingScreenState();
}

class _CreateTrainingScreenState extends State<CreateTrainingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay = DateTime.now();

  bool sessionTypesReceived = false;

  @override
  void initState() {
    super.initState();
    getSessionTypes();
  }

  Future<void> getSessionTypes() async {
    String response = await APICalls.getSessionTypes();
    if (response == "Successfully returned Session Types") {
      setState(() {
        sessionTypesReceived = true;
      });
    }
  }

  void callCreateSessionDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateTrainingDialog(selectedDay!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          //bottomNavigationBar: Mynav(),
          key: _scaffoldKey,
          endDrawer: Mydrawer(),
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/Assets/images/avalbg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.height40,
                      left: SizeConfig.width30,
                      right: SizeConfig.width30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "lib/Assets/images/zaphry.png",
                            width: SizeConfig.width25,
                          ),
                          Container(
                            child: IconButton(
                              icon: Icon(
                                Icons.menu,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                _scaffoldKey.currentState!.openEndDrawer();
                              },
                            ),
                          ),
                        ],
                      ),

                      // Calender
                      SizedBox(
                        height: SizeConfig.height10,
                      ),

                      Text(
                        "Choose Available Session",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.height20,
                        ),
                      ),
                      // Calender
                      SizedBox(
                        height: SizeConfig.height30,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.height25),
                          color: Color(0xffF9C303),
                        ),
                        child: TableCalendar(
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: TextStyle(color: Colors.black),
                            weekendStyle: TextStyle(color: Colors.black),
                          ),
                          rowHeight: SizeConfig.height60,
                          firstDay: DateTime.now(),
                          lastDay: DateTime.utc(2030, 12, 31),
                          calendarFormat: CalendarFormat.month,
                          headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                          ),
                          focusedDay: focusedDay,
                          selectedDayPredicate: (day) {
                            return isSameDay(selectedDay, day);
                          },
                          onDaySelected: (selected, focused) async {
                            setState(() {
                              selectedDay = selected;
                              focusedDay = focused;
                            });
                            if (!sessionTypesReceived) {
                              EasyLoading.show();
                              await getSessionTypes();
                              EasyLoading.dismiss();
                              if (!sessionTypesReceived) {
                                Controller.showSnackBar(
                                    "An error occured, please try again later",
                                    context);
                              } else {
                                callCreateSessionDialog();
                              }
                            } else {
                              callCreateSessionDialog();
                            }
                          },
                          onPageChanged: (focused) {
                            focusedDay = focused;
                          },
                          calendarStyle: CalendarStyle(
                            cellMargin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.width12,
                                vertical: SizeConfig.height12),
                            todayDecoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            defaultDecoration: BoxDecoration(
                              color: Color(0xffF9C303),
                              shape: BoxShape.circle,
                            ),
                            weekendDecoration: BoxDecoration(
                              color: Color(0xffF9C303),
                              shape: BoxShape.circle,
                            ),
                            disabledTextStyle: TextStyle(color: Colors.red),
                            todayTextStyle: TextStyle(color: Colors.white),
                            selectedTextStyle: TextStyle(color: Colors.white),
                            defaultTextStyle: TextStyle(color: Colors.black),
                            weekendTextStyle: TextStyle(color: Colors.black),
                            outsideTextStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: MynavWhite(
                  colorType: 1,
                  currIndex: 2,
                  scaffoldKey: _scaffoldKey,
                ),
              ),
            ],
          )),
    );
  }
}
