import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Widgets/CoachCancelSessionReasonDialog.dart';
import 'package:zaphry/View/Widgets/DeleteDialog.dart';
import 'package:zaphry/View/Widgets/FeedbackDialog.dart';
import 'package:zaphry/View/Widgets/FeedbackViewDialog.dart';
import 'package:zaphry/View/Widgets/LoadMoreButton.dart';
import 'package:zaphry/View/Widgets/mydrawer.dart';
import 'package:zaphry/View/Widgets/navbarwhite.dart';

class CoachMySessionsScreen extends StatefulWidget {
  const CoachMySessionsScreen({Key? key}) : super(key: key);

  @override
  _CoachMySessionsScreenState createState() => _CoachMySessionsScreenState();
}

class _CoachMySessionsScreenState extends State<CoachMySessionsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int pastSessionsPageNo = 1;
  int upcomingSessionsPageNo = 1;

  @override
  void initState() {
    super.initState();
    getSessions();
  }

  void getCoachPastSessions() async {
    EasyLoading.show();
    String response = await APICalls.coachMySessions(
        "past", pastSessionsPageNo.toString(), "10");
    EasyLoading.dismiss();
    if (response == "Successfully returned Sessions data") {
      pastSessionsPageNo += 1;
      setState(() {});
    } else {
      Controller.showSnackBar(response, context);
    }
  }

  void getCoachUpcomingSessions() async {
    EasyLoading.show();
    String response = await APICalls.coachMySessions(
        "upcoming", upcomingSessionsPageNo.toString(), "5");
    EasyLoading.dismiss();
    if (response == "Successfully returned Sessions data") {
      upcomingSessionsPageNo += 1;
      setState(() {});
    } else {
      Controller.showSnackBar(response, context);
    }
  }

  void getSessions() async {
    if (Controller.memberType == 1) {
      getCoachUpcomingSessions();
      getCoachPastSessions();
    } else {}
  }

  String getAction(int index) {
    String action = Controller.coachUpcomingSessions[index].action;
    if (action == "none") {
      if (Controller.coachUpcomingSessions[index].timeToGo != null &&
          Controller.coachUpcomingSessions[index].timeToGo.length > 0) {
        return Controller.coachUpcomingSessions[index].timeToGo;
      }
      return "";
    } else {
      return action;
    }
  }

  bool checkAction(int index) {
    if (Controller.coachUpcomingSessions[index].action.toLowerCase() ==
        "delete") {
      return false;
    } else if (Controller.coachUpcomingSessions[index].action.toLowerCase() ==
        "cancel") {
      return false;
    } else {
      return true;
    }
  }

  bool checkFeedbackAction(int index) {
    String action = Controller.coachMyPastSessions[index].action.toLowerCase();
    if (action == "feedback" || action == "view feedback") {
      return true;
    } else {
      return false;
    }
  }

  Widget upcomingSessionsItem(int index) {
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
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      Controller.coachUpcomingSessions[index].date,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Controller.coachUpcomingSessions[index].startTime,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.width5),
                  height: SizeConfig.height30,
                  child: VerticalDivider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Controller.coachUpcomingSessions[index].sessionType,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width15,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: SizeConfig.width80,
                      child: Text(
                        Controller.coachUpcomingSessions[index].status,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.width10,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: checkAction(index)
                  ? Text(
                      getAction(index),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width12,
                          fontWeight: FontWeight.bold),
                    )
                  : Container(
                      height: SizeConfig.height20,
                      child: OutlinedButton(
                        onPressed: () async {
                          if (Controller.coachUpcomingSessions[index].action ==
                              "Delete") {
                            bool result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DeleteDialog();
                              },
                            );
                            if (result) {
                              EasyLoading.show();
                              String response =
                                  await APICalls.coachSessionDelete(Controller
                                      .coachUpcomingSessions[index].id);
                              EasyLoading.dismiss();
                              Controller.showSnackBar(response, context);
                              if (response ==
                                  "Successfully deleted the session") {
                                setState(() {
                                  Controller.coachUpcomingSessions
                                      .removeAt(index);
                                });
                              }
                            }
                          } else if (Controller
                                  .coachUpcomingSessions[index].action ==
                              "Cancel") {
                            var result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CoachCancelSessionReasonDialog(index);
                              },
                            );
                            if (result != null && result != false) {
                              EasyLoading.show();
                              String response =
                                  await APICalls.coachSessionCancel(
                                      Controller
                                          .coachUpcomingSessions[index].id,
                                      result);
                              EasyLoading.dismiss();
                              Controller.showSnackBar(response, context);
                              if (response ==
                                  "Successfully Cancelled the session") {
                                setState(() {
                                  Controller.coachUpcomingSessions
                                      .removeAt(index);
                                });
                              }
                            }
                          }
                        },
                        child: Text(
                          Controller.coachUpcomingSessions[index].action,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.width10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.height30),
                            ),
                            side: BorderSide(
                              color: Colors.black,
                            )),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pastSessionsItem(int index) {
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
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      Controller.coachMyPastSessions[index].date,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Controller.coachMyPastSessions[index].startTime,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.width5),
                  height: SizeConfig.height30,
                  child: VerticalDivider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Controller.coachMyPastSessions[index].sessionType,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width15,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: SizeConfig.width80,
                      child: Text(
                        Controller.coachMyPastSessions[index].status,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.width10,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: checkFeedbackAction(index)
                  ? Container(
                      height: SizeConfig.height20,
                      child: OutlinedButton(
                        onPressed: () async {
                          if (Controller.coachMyPastSessions[index].action
                                  .toLowerCase() ==
                              "feedback") {
                            if (Controller
                                    .coachMyPastSessions[index].coachFeedback ==
                                0) {
                              bool responseCheck = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return FeedbackDialog(
                                      Controller.coachMyPastSessions[index].id,
                                      Controller
                                          .coachMyPastSessions[index].startTime,
                                      Controller
                                          .coachMyPastSessions[index].date,
                                      Controller.coachMyPastSessions[index]
                                          .sessionType);
                                },
                              );
                              if (responseCheck) {
                                setState(() {
                                  Controller.coachMyPastSessions[index].action =
                                      "View Feedback";
                                });
                              }
                            }
                          } else if (Controller
                                  .coachMyPastSessions[index].action
                                  .toLowerCase() ==
                              "view feedback") {
                            EasyLoading.show();
                            String response = await APICalls.coachViewFeedback(
                                Controller.coachMyPastSessions[index].id);
                            EasyLoading.dismiss();
                            if (response ==
                                "Successfully Returned the feedback") {
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return FeedbackViewDialog();
                                },
                              );
                            } else {
                              Controller.showSnackBar(response, context);
                            }
                          }
                        },
                        child: Text(
                          Controller.coachMyPastSessions[index].action,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.width10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.height30),
                            ),
                            side: BorderSide(
                              color: Colors.black,
                            )),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "\$ " + Controller.coachMyPastSessions[index].price,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: SizeConfig.width15,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Price",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: SizeConfig.width10,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getUpcomingSessionsListView() {
    return ListView.separated(
      itemCount: Controller.coachUpcomingSessions.length + 1,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: SizeConfig.height20,
        );
      },
      itemBuilder: (context, index) {
        if (Controller.coachUpcomingSessions.length == 0) {
          return Center(
            child: Text("No upcoming sessions"),
          );
        } else {
          if (Controller.coachUpcomingSessions.length == index) {
            return Align(
              child: LoadMoreButton(() => getCoachUpcomingSessions()),
            );
          } else {
            return upcomingSessionsItem(index);
          }
        }
      },
    );
  }

  Widget getPastSessionsListView() {
    return ListView.separated(
      itemCount: Controller.coachMyPastSessions.length + 1,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: SizeConfig.height20,
        );
      },
      itemBuilder: (context, index) {
        if (Controller.coachMyPastSessions.length == 0) {
          return Center(
            child: Text("No session data found"),
          );
        } else {
          if (Controller.coachMyPastSessions.length == index) {
            return Align(
              child: IconButton(
                icon: Icon(Icons.add_circle_outline),
                iconSize: SizeConfig.height35,
                onPressed: () {
                  getCoachPastSessions();
                },
              ),
            );
          } else {
            return pastSessionsItem(index);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Controller.onWillPop(context),
      child: SafeArea(
        child: DefaultTabController(
          length: 2,
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
                            SizeConfig.height15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset(
                              "lib/Assets/images/zaphry.png",
                              width: SizeConfig.width25,
                            ),
                            Text(
                              "My Sessions",
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
                      Container(
                        child: TabBar(
                          tabs: [
                            Tab(
                              text: "Upcoming Sessions",
                            ),
                            Tab(
                              text: "Past Sessions",
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: SizeConfig.height450,
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.width30),
                        child: TabBarView(
                          children: [
                            getUpcomingSessionsListView(),
                            getPastSessionsListView(),
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
                      currIndex: 3,
                      scaffoldKey: _scaffoldKey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        /*child: Scaffold(
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
                              "My Sessions",
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Upcoming Sessions",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: SizeConfig.height18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.height25,
                            ),
                            Container(
                              height: SizeConfig.height200,
                              child: ListView.separated(
                                itemCount:
                                    Controller.coachUpcomingSessions.length + 1,
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: SizeConfig.height20,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  if (Controller.coachUpcomingSessions.length ==
                                      0) {
                                    return Center(
                                      child: Text("No upcoming sessions"),
                                    );
                                  } else {
                                    if (Controller
                                            .coachUpcomingSessions.length ==
                                        index) {
                                      return Align(
                                        child: LoadMoreButton(
                                            () => getCoachUpcomingSessions()),
                                      );
                                    } else {
                                      return upcomingSessionsItem(index);
                                    }
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.height25,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Past Sessions",
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
                              height: SizeConfig.height170,
                              child: ListView.separated(
                                itemCount:
                                    Controller.coachMyPastSessions.length + 1,
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: SizeConfig.height20,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  if (Controller.coachMyPastSessions.length ==
                                      0) {
                                    return Center(
                                      child: Text("No session data found"),
                                    );
                                  } else {
                                    if (Controller.coachMyPastSessions.length ==
                                        index) {
                                      return Align(
                                        child: IconButton(
                                          icon: Icon(Icons.add_circle_outline),
                                          iconSize: SizeConfig.height35,
                                          onPressed: () {
                                            getCoachPastSessions();
                                          },
                                        ),
                                      );
                                    } else {
                                      return pastSessionsItem(index);
                                    }
                                  }
                                },
                              ),
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
                      currIndex: 3,
                      scaffoldKey: _scaffoldKey,
                    ),
                  ),
                ],
              ),
            )),*/
      ),
    );
  }
}
