import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/Model/SearchSession.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Widgets/LoadMoreButton.dart';
import 'package:zaphry/View/Widgets/mydrawer.dart';
import 'package:zaphry/View/Widgets/navbarwhite.dart';

import 'PayNowScreen.dart';

class BookTrainingScreen extends StatefulWidget {
  const BookTrainingScreen({Key? key}) : super(key: key);

  @override
  _BookTrainingScreenState createState() => _BookTrainingScreenState();
}

class _BookTrainingScreenState extends State<BookTrainingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();
  int sessionPageNo = 1;
  double totalPrice = 0;
  List<SearchSession> selectedSessions = [];
  List<SearchSession> bookedSessions = [];

  @override
  void initState() {
    super.initState();
    searchSessions(true);
  }

  void searchSessions(bool isNew) async {
    EasyLoading.show();
    if (isNew) {
      setState(() {
        sessionPageNo = 1;
        totalPrice = 0;
        selectedSessions.clear();
      });
    }
    String startDate = selectedDay.toString().split(" ")[0];
    String endDate =
        selectedDay.add(Duration(days: 1)).toString().split(" ")[0];
    print(startDate + " - " + endDate);
    String response = await APICalls.search(
        startDate, endDate, "10", sessionPageNo.toString());
    EasyLoading.dismiss();
    if (response == "Successfully returned Sessions data") {
      sessionPageNo += 1;
      setState(() {});
    } else {
      Controller.showSnackBar(response, context);
    }
  }

  void bookSessionsAndProceed() async {
    EasyLoading.show();
    String response = await APICalls.getSessionTypes();
    if (response == "Successfully returned Session Types") {
      bookedSessions.clear();
      for (int c = 0; c < selectedSessions.length; c++) {
        if (Controller.dropdownSessionTypes
            .contains(selectedSessions[c].sessionType)) {
          String response = await APICalls.bookSession(
              selectedSessions[c].id,
              Controller.dropdownSessionTypes
                  .indexOf(selectedSessions[c].sessionType)
                  .toString());
          Controller.showSnackBar(response, context);
          if (response == "Session Booked Succesfully") {
            bookedSessions.add(selectedSessions[c]);
          }
        } else {
          Controller.showSnackBar(
              "Error while booking: ${selectedSessions[c].date}", context);
        }
      }
    } else {
      Controller.showSnackBar(
          "Unable to process request at the moment", context);
    }

    EasyLoading.dismiss();
    if (bookedSessions.length > 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PayNowScreen(bookedSessions),
        ),
      );
    }
  }

  void adjustPriceAndItems(int index) {
    setState(() {
      Controller.searchSessionList[index].booked =
          !Controller.searchSessionList[index].booked;
      if (Controller.searchSessionList[index].booked) {
        if (!selectedSessions.contains(Controller.searchSessionList[index])) {
          totalPrice += double.parse(Controller.searchSessionList[index].price);
          selectedSessions.add(Controller.searchSessionList[index]);
        }
      } else {
        if (selectedSessions.contains(Controller.searchSessionList[index])) {
          totalPrice -= double.parse(Controller.searchSessionList[index].price);
          selectedSessions.remove(Controller.searchSessionList[index]);
        }
      }
    });
  }

  Widget getSearchItem(int index) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.height10, horizontal: SizeConfig.width20),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.height25),
          color: Color(0xffF9C303),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      Controller.searchSessionList[index].date,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Controller.searchSessionList[index].startTime,
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
                      padding:
                          EdgeInsets.symmetric(horizontal: SizeConfig.width5),
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
                      Controller.searchSessionList[index].sessionType,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width15,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: SizeConfig.width80,
                      child: Text(
                        Controller.searchSessionList[index].coach,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.width12,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.height15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IgnorePointer(
                        child: RatingBar.builder(
                          itemSize: 18,
                          initialRating: double.parse(
                              Controller.searchSessionList[index].rating),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          maxRating: 5,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.width1,
                              vertical: SizeConfig.height8),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.black,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ),
                      Container(
                        height: SizeConfig.height20,
                        width: SizeConfig.width120,
                        child: OutlinedButton(
                          onPressed: () {
                            adjustPriceAndItems(index);
                          },
                          child: Text(
                            Controller.searchSessionList[index].booked
                                ? "BOOKED"
                                : "BOOK NOW",
                            style: TextStyle(
                              color: Controller.searchSessionList[index].booked
                                  ? Color(0xffF9C303)
                                  : Colors.black,
                              fontSize: SizeConfig.width10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.height30),
                            ),
                            backgroundColor:
                                Controller.searchSessionList[index].booked
                                    ? Colors.black
                                    : Color(0xffF9C303),
                            side: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Controller.onWillPop(context),
      child: SafeArea(
        child: Scaffold(
          //bottomNavigationBar: Mynav(),
          key: _scaffoldKey,
          endDrawer: Mydrawer(),
          body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('lib/Assets/images/booktraing.png'),
                    fit: BoxFit.cover),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: SizeConfig.height40,
                        left: SizeConfig.width30,
                        right: SizeConfig.width30,
                        bottom: SizeConfig.height30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Book Training",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: SizeConfig.height20,
                                  fontWeight: FontWeight.bold),
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
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.height25),
                            color: Colors.transparent,
                          ),
                          child: TableCalendar(
                            rowHeight: SizeConfig.height60,
                            firstDay: DateTime.now(),
                            lastDay: DateTime.utc(2030, 12, 31),
                            calendarFormat: CalendarFormat.week,
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                            ),
                            focusedDay: focusedDay,
                            selectedDayPredicate: (day) {
                              return isSameDay(selectedDay, day);
                            },
                            onDaySelected: (selected, focused) {
                              setState(() {
                                selectedDay = selected;
                                focusedDay = focused;
                              });
                              searchSessions(true);
                            },
                            onPageChanged: (focused) {
                              focusedDay = focused;
                            },
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: TextStyle(
                                color: Colors.black,
                                fontSize: SizeConfig.width12,
                              ),
                              weekendStyle: TextStyle(
                                color: Colors.black,
                                fontSize: SizeConfig.width12,
                              ),
                            ),
                            calendarStyle: CalendarStyle(
                              cellMargin: EdgeInsets.symmetric(
                                  vertical: SizeConfig.height12,
                                  horizontal: SizeConfig.width12),
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
                              outsideDecoration: BoxDecoration(
                                color: Color(0xffF9C303),
                                shape: BoxShape.circle,
                              ),
                              disabledTextStyle: TextStyle(
                                color: Colors.red,
                                fontSize: SizeConfig.width12,
                              ),
                              todayTextStyle: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.width12,
                              ),
                              selectedTextStyle: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.width12,
                              ),
                              defaultTextStyle: TextStyle(
                                color: Colors.black,
                                fontSize: SizeConfig.width12,
                              ),
                              weekendTextStyle: TextStyle(
                                color: Colors.black,
                                fontSize: SizeConfig.width12,
                              ),
                              outsideTextStyle: TextStyle(
                                color: Colors.black,
                                fontSize: SizeConfig.width12,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.height25,
                        ),
                        Container(
                          height: SizeConfig.height300,
                          child: ListView.separated(
                            itemCount: Controller.searchSessionList.length + 1,
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: SizeConfig.height20,
                              );
                            },
                            itemBuilder: (context, index) {
                              if (Controller.searchSessionList.length == 0) {
                                return Center(
                                  child: Text("No sessions found"),
                                );
                              } else {
                                if (Controller.searchSessionList.length ==
                                    index) {
                                  return Align(
                                    child: LoadMoreButton(
                                        () => searchSessions(false)),
                                  );
                                } else {
                                  return getSearchItem(index);
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    left: 0,
                    bottom: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.width30),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "Bookings(${selectedSessions.length}) | \$ $totalPrice"),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.height18)),
                                  primary: Colors.black,
                                  minimumSize: Size(
                                      SizeConfig.width10, SizeConfig.height30),
                                ),
                                onPressed: selectedSessions.length > 0
                                    ? () {
                                        bookSessionsAndProceed();
                                      }
                                    : null,
                                child: Text(
                                  'Proceed',
                                  style: TextStyle(
                                      fontSize: SizeConfig.height15,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.height5,
                        ),
                        MynavWhite(
                          colorType: 1,
                          currIndex: 2,
                          scaffoldKey: _scaffoldKey,
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
