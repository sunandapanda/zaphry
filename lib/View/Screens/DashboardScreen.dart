import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Widgets/LoadMoreButton.dart';
import 'package:zaphry/View/Widgets/mydrawer.dart';
import 'package:zaphry/View/Widgets/navbarwhite.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int allSessionsPageNo = 1;
  int upcomingSessionsPageNo = 1;

  @override
  void initState() {
    super.initState();
    getDashboard();
  }

  void getCoachAllSessions() async {
    EasyLoading.show();
    String response = await APICalls.coachDashboard(
        "all", allSessionsPageNo.toString(), "10");
    EasyLoading.dismiss();
    if (response == "Successfully returned Sessions data") {
      allSessionsPageNo += 1;
      setState(() {});
    } else {
      Controller.showSnackBar(response, context);
    }
  }

  void getCoachUpcomingSessions() async {
    EasyLoading.show();
    String response = await APICalls.coachDashboard(
        "upcoming", upcomingSessionsPageNo.toString(), "5");
    EasyLoading.dismiss();
    if (response == "Successfully returned Sessions data") {
      upcomingSessionsPageNo += 1;
      setState(() {});
    } else {
      Controller.showSnackBar(response, context);
    }
  }

  void getPlayerAllSessions() async {
    EasyLoading.show();
    String response = await APICalls.playerDashboard(
        "all", allSessionsPageNo.toString(), "10");
    EasyLoading.dismiss();
    if (response == "Successfully returned Sessions data") {
      allSessionsPageNo += 1;
      setState(() {});
    } else {
      Controller.showSnackBar(response, context);
    }
  }

  void getPlayerUpcomingSessions() async {
    EasyLoading.show();
    String response = await APICalls.playerDashboard(
        "upcoming", upcomingSessionsPageNo.toString(), "5");
    EasyLoading.dismiss();
    if (response == "Successfully returned Sessions data") {
      upcomingSessionsPageNo += 1;
      setState(() {});
    } else {
      Controller.showSnackBar(response, context);
    }
  }

  void getDashboard() async {
    if (Controller.memberType == 1) {
      getCoachUpcomingSessions();
      getCoachAllSessions();
    } else {
      getPlayerUpcomingSessions();
      getPlayerAllSessions();
    }
  }

  // Coach
  Widget coachUpcomingSessionsItem(int index) {
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
              child: Controller.coachUpcomingSessions[index].action !=
                      "Session Started"
                  ? Text(
                      Controller.coachUpcomingSessions[index].action,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width12,
                          fontWeight: FontWeight.bold),
                    )
                  : Container(
                      height: SizeConfig.height20,
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: go to link
                          // Controller.upcomingSessions[index].link
                        },
                        child: Text(
                          " Join ",
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

  // Coach
  Widget coachAllSessionsItem(int index) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.height10, horizontal: SizeConfig.width15),
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
                      Controller.coachDashboardAllSessions[index].date,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Controller.coachDashboardAllSessions[index].startTime,
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
                      Controller.coachDashboardAllSessions[index].sessionType,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width15,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: SizeConfig.width80,
                      child: Text(
                        Controller.coachDashboardAllSessions[index].status,
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
              child: Text(
                "\$ " + Controller.coachDashboardAllSessions[index].price,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.width15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Coach
  Widget getCoachUpcomingListView() {
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
            child: Text("No confirmed sessions today"),
          );
        } else {
          if (Controller.coachUpcomingSessions.length == index) {
            return Align(
              child: LoadMoreButton(() => getPlayerAllSessions()),
            );
          } else {
            return coachUpcomingSessionsItem(index);
          }
        }
      },
    );
  }

  // Coach
  Widget getCoachAllListView() {
    return ListView.separated(
      itemCount: Controller.coachDashboardAllSessions.length + 1,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: SizeConfig.height20,
        );
      },
      itemBuilder: (context, index) {
        if (Controller.coachDashboardAllSessions.length == 0) {
          return Center(
            child: Text("No session data found"),
          );
        } else {
          if (Controller.coachDashboardAllSessions.length == index) {
            return Align(
              child: LoadMoreButton(() => getPlayerAllSessions()),
            );
          } else {
            return coachAllSessionsItem(index);
          }
        }
      },
    );
  }

  // Player
  Widget playerUpcomingSessionsItem(int index) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.height10, horizontal: SizeConfig.width15),
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
            Align(
              alignment: Alignment.centerRight,
              child: Controller.playerUpcomingSessions[index].action !=
                      "Session Started"
                  ? Text(
                      Controller.playerUpcomingSessions[index].action,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width12,
                          fontWeight: FontWeight.bold),
                    )
                  : Container(
                      height: SizeConfig.height20,
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: go to link
                          // Controller.upcomingSessions[index].link
                        },
                        child: Text(
                          " Join ",
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

  // Player
  Widget playerAllSessionsItem(int index) {
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
                      Controller.playerDashboardAllSessions[index].date,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Controller.playerDashboardAllSessions[index].startTime,
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
                      Controller.playerDashboardAllSessions[index].sessionType,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width15,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: SizeConfig.width80,
                      child: Text(
                        Controller.playerDashboardAllSessions[index].coach,
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
              child: Text(
                "\$ " + Controller.playerDashboardAllSessions[index].price,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.width15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Player
  Widget getPlayerUpcomingListView() {
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
            child: Text("No confirmed sessions today"),
          );
        } else {
          if (Controller.playerUpcomingSessions.length == index) {
            return Align(
              child: LoadMoreButton(() => getPlayerAllSessions()),
            );
          } else {
            return playerUpcomingSessionsItem(index);
          }
        }
      },
    );
  }

  // Player
  Widget getPlayerAllListView() {
    return ListView.separated(
      itemCount: Controller.playerDashboardAllSessions.length + 1,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: SizeConfig.height20,
        );
      },
      itemBuilder: (context, index) {
        if (Controller.playerDashboardAllSessions.length == 0) {
          return Center(
            child: Text("No session data found"),
          );
        } else {
          if (Controller.playerDashboardAllSessions.length == index) {
            return Align(
              child: LoadMoreButton(() => getPlayerAllSessions()),
            );
          } else {
            return playerAllSessionsItem(index);
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
                        Container(
                          child: TabBar(
                            tabs: [
                              Tab(
                                text: "Today's Sessions",
                              ),
                              Tab(
                                text: "All Sessions",
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
                              Controller.memberType == 1
                                  ? getCoachUpcomingListView()
                                  : getPlayerUpcomingListView(),
                              Controller.memberType == 1
                                  ? getCoachAllListView()
                                  : getPlayerAllListView(),
                            ],
                          ),
                        ),
                        /*Padding(
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
                                height: SizeConfig.height150,
                                child: Controller.memberType == 1
                                    ? getCoachUpcomingListView()
                                    : getPlayerUpcomingListView(),
                              ),
                              SizedBox(
                                height: SizeConfig.height25,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "All Sessions",
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
                                height: SizeConfig.height220,
                                child: Controller.memberType == 1
                                    ? getCoachAllListView()
                                    : getPlayerAllListView(),
                              ),
                            ],
                          ),
                        ),*/
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
      ),
    );
  }
}
