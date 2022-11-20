import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Widgets/FeedbackDialog.dart';
import 'package:zaphry/View/Widgets/FeedbackViewDialog.dart';
import 'package:zaphry/View/Widgets/LoadMoreButton.dart';
import 'package:zaphry/View/Widgets/PlayerCancelSessionReasonDialog.dart';
import 'package:zaphry/View/Widgets/mydrawer.dart';
import 'package:zaphry/View/Widgets/navbarwhite.dart';

class PlayerMyTrainingsScreen extends StatefulWidget {
  const PlayerMyTrainingsScreen({Key? key}) : super(key: key);

  @override
  _PlayerMyTrainingsScreenState createState() =>
      _PlayerMyTrainingsScreenState();
}

class _PlayerMyTrainingsScreenState extends State<PlayerMyTrainingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int pastSessionsPageNo = 1;
  int upcomingSessionsPageNo = 1;

  @override
  void initState() {
    super.initState();
    getTrainings();
  }

  void getPlayerPastSessions() async {
    EasyLoading.show();
    String response = await APICalls.playerMyTrainings(
        "past", pastSessionsPageNo.toString(), "10");
    EasyLoading.dismiss();
    if (response == "Successfully returned Sessions data") {
      pastSessionsPageNo += 1;
      setState(() {});
    } else {
      Controller.showSnackBar(response, context);
    }
  }

  void getPlayerUpcomingSessions() async {
    EasyLoading.show();
    String response = await APICalls.playerMyTrainings(
        "upcoming", upcomingSessionsPageNo.toString(), "5");
    EasyLoading.dismiss();
    if (response == "Successfully returned Sessions data") {
      upcomingSessionsPageNo += 1;
      setState(() {});
    } else {
      Controller.showSnackBar(response, context);
    }
  }

  void getTrainings() async {
    getPlayerUpcomingSessions();
    getPlayerPastSessions();
  }

  String getAction(int index) {
    String action = Controller.playerUpcomingSessions[index].action;
    if (action == "none") {
      if (Controller.playerUpcomingSessions[index].timeToGo != null &&
          Controller.playerUpcomingSessions[index].timeToGo.length > 0) {
        return Controller.playerUpcomingSessions[index].timeToGo;
      }
      return "";
    } else {
      return action;
    }
  }

  bool checkAction(int index) {
    if (Controller.playerUpcomingSessions[index].action.toLowerCase() ==
        "delete") {
      return false;
    } else if (Controller.playerUpcomingSessions[index].action.toLowerCase() ==
        "cancel") {
      return false;
    } else {
      return true;
    }
  }

  bool checkFeedbackAction(int index) {
    String action = Controller.playerMyPastSessions[index].action.toLowerCase();
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
                      Controller.playerUpcomingSessions[index].date,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Controller.playerUpcomingSessions[index].startTime,
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
                      Controller.playerUpcomingSessions[index].sessionType,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width15,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: SizeConfig.width80,
                      child: Text(
                        Controller.playerUpcomingSessions[index].coach,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Controller.playerUpcomingSessions[index].status,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.width10,
                      fontWeight: FontWeight.normal),
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
                              if (Controller
                                      .playerUpcomingSessions[index].action ==
                                  "Cancel") {
                                var result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return PlayerCancelSessionReasonDialog(
                                        index);
                                  },
                                );
                                if (result != null && result != false) {
                                  EasyLoading.show();
                                  String response =
                                      await APICalls.playerSessionCancel(
                                          Controller
                                              .playerUpcomingSessions[index].id,
                                          result);
                                  EasyLoading.dismiss();
                                  Controller.showSnackBar(response, context);
                                  if (response ==
                                      "Successfully Cancelled the session") {
                                    setState(() {
                                      Controller.playerUpcomingSessions
                                          .removeAt(index);
                                    });
                                  }
                                }
                              }
                            },
                            child: Text(
                              Controller.playerUpcomingSessions[index].action,
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
                              ),
                            ),
                          ),
                        ),
                ),
              ],
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
                      Controller.playerMyPastSessions[index].date,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Controller.playerMyPastSessions[index].startTime,
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
                      Controller.playerMyPastSessions[index].sessionType,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width15,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: SizeConfig.width80,
                      child: Text(
                        Controller.playerMyPastSessions[index].coach,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Controller.playerMyPastSessions[index].status,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.width10,
                      fontWeight: FontWeight.normal),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: checkFeedbackAction(index)
                      ? Container(
                          height: SizeConfig.height20,
                          child: OutlinedButton(
                            onPressed: () async {
                              if (Controller.playerMyPastSessions[index].action
                                      .toLowerCase() ==
                                  "feedback") {
                                if (Controller.playerMyPastSessions[index]
                                        .playerFeedback ==
                                    0) {
                                  bool responseCheck = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return FeedbackDialog(
                                        Controller
                                            .playerMyPastSessions[index].id,
                                        Controller.playerMyPastSessions[index]
                                            .startTime,
                                        Controller
                                            .playerMyPastSessions[index].date,
                                        Controller.playerMyPastSessions[index]
                                            .sessionType,
                                        coach: Controller
                                            .playerMyPastSessions[index].coach,
                                      );
                                    },
                                  );
                                  if (responseCheck) {
                                    setState(() {
                                      Controller.playerMyPastSessions[index]
                                          .action = "View Feedback";
                                    });
                                  }
                                }
                              } else if (Controller
                                      .playerMyPastSessions[index].action
                                      .toLowerCase() ==
                                  "view feedback") {
                                EasyLoading.show();
                                String response =
                                    await APICalls.playerViewFeedback(Controller
                                        .playerMyPastSessions[index].id);
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
                              Controller.playerMyPastSessions[index].action,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: SizeConfig.width10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.height30),
                                ),
                                side: BorderSide(
                                  color: Colors.black,
                                )),
                          ),
                        )
                      : Text(
                          "\$ " + Controller.playerMyPastSessions[index].price,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: SizeConfig.width15,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getUpcomingSessionsListView() {
    return ListView.separated(
      itemCount: Controller.playerUpcomingSessions.length + 1,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: SizeConfig.height20,
        );
      },
      itemBuilder: (context, index) {
        if (Controller.playerUpcomingSessions.length == 0) {
          return Center(
            child: Text("No upcoming sessions"),
          );
        } else {
          if (Controller.playerUpcomingSessions.length == index) {
            return Align(
              child: LoadMoreButton(() => getPlayerUpcomingSessions()),
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
      itemCount: Controller.playerMyPastSessions.length + 1,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: SizeConfig.height20,
        );
      },
      itemBuilder: (context, index) {
        if (Controller.playerMyPastSessions.length == 0) {
          return Center(
            child: Text("No session data found"),
          );
        } else {
          if (Controller.playerMyPastSessions.length == index) {
            return Align(
              child: LoadMoreButton(() => getPlayerPastSessions()),
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
                              "My trainings",
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
      ),
    );
  }
}
