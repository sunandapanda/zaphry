import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Screens/AddEventScreen.dart';
import 'package:zaphry/View/Screens/EventAttendeesDetailsScreen.dart';
import 'package:zaphry/View/Widgets/DeleteDialog.dart';
import 'package:zaphry/View/Widgets/LoadMoreButton.dart';
import 'package:zaphry/View/Widgets/mydrawer.dart';
import 'package:zaphry/View/Widgets/navbarwhite.dart';

import 'ClubEventDetailsScreen.dart';

class DashboardClubScreen extends StatefulWidget {
  const DashboardClubScreen({Key? key}) : super(key: key);

  @override
  _DashboardClubScreenState createState() => _DashboardClubScreenState();
}

class _DashboardClubScreenState extends State<DashboardClubScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int eventsPageNo = 1;

  @override
  void initState() {
    super.initState();
    getDashboard();
  }

  void getClubEvents() async {
    EasyLoading.show();
    String response = await APICalls.clubEvents(eventsPageNo.toString(), "10");
    EasyLoading.dismiss();
    if (response == "Successfully Retrieved Events") {
      eventsPageNo += 1;
      setState(() {});
    } else {
      Controller.showSnackBar(
          "Unable to process request at the moment", context);
    }
  }

  void getClubRequests() async {
    EasyLoading.show();
    String response = await APICalls.getClubRequests();
    EasyLoading.dismiss();
    if (response != "Successfully Returned Data") {
      Controller.showSnackBar(
          "Unable to process request at the moment", context);
    }
    setState(() {});
  }

  void getDashboard() async {
    if (Controller.clubEvents.length <= 0) {
      getClubEvents();
    }
    getClubRequests();
  }

  void requestAction(String userID, String action, int index) async {
    EasyLoading.show();
    String response = await APICalls.clubRequestAction(userID, action);
    EasyLoading.dismiss();
    Controller.showSnackBar(response, context);
    if (response == "Successfully Rejected Association Request" ||
        response == "Successfully Approved Association Request") {
      setState(() {
        Controller.clubRequests.removeAt(index);
      });
    }
  }

  String getDateFromTimestamp(int timestamp) {
    String tempDate =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toString();
    String date = tempDate.split(" ")[0];
    //String time = tempDate.split(" ")[1];
    String formattedDate = date.split("-")[2] +
        "/" +
        date.split("-")[1] +
        "/" +
        date.split("-")[0];
    //String formattedTime = time.substring(0, 5);
    return formattedDate;
  }

  Widget clubEventsItem(int index) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.height10, horizontal: SizeConfig.width15),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.height20),
          color: Color(0xffF9C303),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: Container(
            height: SizeConfig.height50,
            width: SizeConfig.width70,
            child: Image.network(Controller.clubEvents[index].banner,
                fit: BoxFit.contain),
          ),
          title: Text(
            Controller.clubEvents[index].title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.height15,
                fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            getDateFromTimestamp(
                int.parse(Controller.clubEvents[index].startDateTime)),
            style:
                TextStyle(color: Colors.black, fontSize: SizeConfig.height15),
          ),
          trailing: OutlinedButton(
            onPressed: Controller.clubEvents[index].attendees == 0
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventAttendeesDetailsScreen(
                            Controller.clubEvents[index].id),
                      ),
                    );
                  },
            child: Text(
              "${Controller.clubEvents[index].attendees} Attendees",
              style: TextStyle(
                color: Controller.clubEvents[index].attendees == 0
                    ? Colors.black
                    : Colors.white,
                fontSize: SizeConfig.height10,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: Controller.clubEvents[index].attendees == 0
                  ? Color(0xffF9C303)
                  : Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConfig.height30),
              ),
              side: BorderSide(
                color: Controller.clubEvents[index].attendees == 0
                    ? Color(0xffF9C303)
                    : Colors.black,
              ),
            ),
          ),
        ),
      ),
      onTap: () async {
        EasyLoading.show();
        String response =
            await APICalls.getEventDetails(Controller.clubEvents[index].id);
        EasyLoading.dismiss();
        if (response == "Successfully Retrieved EVent Details") {
          bool check = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ClubEventDetailsScreen(Controller.clubEvents[index].id, true),
            ),
          );
          if (check) {
            eventsPageNo = 1;
            getClubEvents();
          }
        } else {
          Controller.showSnackBar(response, context);
        }
      },
      onLongPress: () async {
        bool result = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return DeleteDialog();
          },
        );
        if (result) {
          EasyLoading.show();
          String response =
              await APICalls.deleteEvent(Controller.clubEvents[index].id);
          EasyLoading.dismiss();
          if (response == "Successfully Deleted Event") {
            setState(() {
              Controller.clubEvents.removeAt(index);
            });
          }
          Controller.showSnackBar(response, context);
        }
      },
    );
  }

  Widget getEventsListView() {
    return ListView.separated(
      itemCount: Controller.clubEvents.length + 1,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: SizeConfig.height20,
        );
      },
      itemBuilder: (context, index) {
        if (Controller.clubEvents.length == 0) {
          return Center(
            child: Text("No events found"),
          );
        } else {
          if (Controller.clubEvents.length == index) {
            return Align(
              child: LoadMoreButton(() => getClubEvents()),
            );
          } else {
            return clubEventsItem(index);
          }
        }
      },
    );
  }

  Widget clubRequestsItem(int index) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.height10, horizontal: SizeConfig.width20),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.height20),
          color: Color(0xffF9C303),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Controller.clubRequests[index].userType +
                  " :  " +
                  Controller.clubRequests[index].userName,
              style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.height17,
                fontWeight: FontWeight.bold,
              ),
            ),
            Controller.clubRequests[index].email != null
                ? Text(
                    Controller.clubRequests[index].email!,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.height15,
                        fontWeight: FontWeight.bold),
                  )
                : SizedBox.shrink(),
            Controller.clubRequests[index].phoneNo != null
                ? Text(
                    Controller.clubRequests[index].phoneNo!,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.height15,
                        fontWeight: FontWeight.bold),
                  )
                : SizedBox.shrink(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: SizeConfig.height20,
                  child: ElevatedButton(
                    onPressed: () {
                      requestAction(
                          Controller.clubRequests[index].userID, "0", index);
                    },
                    child: Text(
                      "Reject",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.height10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.height30),
                        ),
                        side: BorderSide(
                          color: Colors.red,
                        )),
                  ),
                ),
                SizedBox(width: SizeConfig.width10),
                Container(
                  height: SizeConfig.height20,
                  child: ElevatedButton(
                    onPressed: () {
                      requestAction(
                          Controller.clubRequests[index].userID, "1", index);
                    },
                    child: Text(
                      "Approve",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.height10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.height30),
                        ),
                        side: BorderSide(
                          color: Colors.green,
                        )),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getRequestsListView() {
    return ListView.separated(
      itemCount: Controller.clubRequests.length + 1,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: SizeConfig.height20,
        );
      },
      itemBuilder: (context, index) {
        if (Controller.clubRequests.length == 0) {
          return Center(
            child: Text("No new requests"),
          );
        } else {
          if (Controller.clubRequests.length == index) {
            return SizedBox.shrink();
          } else {
            return clubRequestsItem(index);
          }
        }
      },
    );
  }

  Future<void> goToAddEvent() async {
    bool check = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEventScreen(),
      ),
    );
    if (check) {
      eventsPageNo = 1;
      getClubEvents();
    }
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
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            SizeConfig.width25,
                            SizeConfig.height40,
                            SizeConfig.width25,
                            SizeConfig.height30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset(
                              "lib/Assets/images/zaphry.png",
                              width: SizeConfig.width25,
                            ),
                            Text(
                              "Dashboard",
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
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 0,
                            left: SizeConfig.width30,
                            right: SizeConfig.width30,
                            bottom: SizeConfig.height30),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Events",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: SizeConfig.height18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  height: SizeConfig.height20,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (Controller.ageGroupTexts.length > 1) {
                                        goToAddEvent();
                                      } else {
                                        bool check = await Controller
                                            .callProfileDropdownsAndCountryCodesAPI();
                                        if (check) {
                                          goToAddEvent();
                                        } else {
                                          Controller.showSnackBar(
                                              "Unable to process request at the time",
                                              context);
                                        }
                                      }
                                    },
                                    child: Text(
                                      "Add Event",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: SizeConfig.height10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              SizeConfig.height30),
                                        ),
                                        side: BorderSide(
                                          color: Colors.black,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizeConfig.height25,
                            ),
                            Container(
                              height: SizeConfig.height220,
                              child: getEventsListView(),
                            ),
                            SizedBox(
                              height: SizeConfig.height25,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Club Association Requests",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: SizeConfig.height18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.height15,
                            ),
                            Container(
                              height: SizeConfig.height150,
                              child: getRequestsListView(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    left: 0,
                    bottom: 0,
                    child: MynavWhite(
                      colorType: 1,
                      currIndex: 0,
                      scaffoldKey: _scaffoldKey,
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
