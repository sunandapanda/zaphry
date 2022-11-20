import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Widgets/LoadMoreButton.dart';
import 'package:zaphry/View/Widgets/mydrawer.dart';
import 'package:zaphry/View/Widgets/navbarwhite.dart';

import 'ClubEventDetailsScreen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int upcomingEventsPageNo = 1;
  int interestedEventsPageNo = 1;

  @override
  void initState() {
    super.initState();
    getInterestedEvents(false);
  }

  void getInterestedEvents(bool onlyThis) async {
    EasyLoading.show();
    String response = await APICalls.getInterestedEvents(
        interestedEventsPageNo.toString(), "10");
    EasyLoading.dismiss();
    if (response == "Successfully Retrieved Interests Data") {
      interestedEventsPageNo += 1;
      setState(() {});
      if (!onlyThis) {
        getUpcomingEvents();
      }
    } else {
      Controller.showSnackBar(response, context);
    }
  }

  void getUpcomingEvents() async {
    EasyLoading.show();
    String response =
        await APICalls.getEvents(upcomingEventsPageNo.toString(), "10");
    EasyLoading.dismiss();
    if (response == "Successfully Retrieved Events") {
      upcomingEventsPageNo += 1;
      setState(() {});
    } else {
      Controller.showSnackBar(response, context);
    }
  }

  Widget upcomingEventsItem(int index) {
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
            child: Image.network(Controller.upcomingEvents[index].banner,
                fit: BoxFit.contain),
          ),
          title: Text(
            Controller.upcomingEvents[index].title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.height15,
                fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            Controller.upcomingEvents[index].startDateTime,
            style:
                TextStyle(color: Colors.black, fontSize: SizeConfig.height15),
          ),
          trailing: OutlinedButton(
            onPressed: () async {
              EasyLoading.show();
              String response = await APICalls.eventInterest(
                  Controller.upcomingEvents[index].eventID, "1");
              EasyLoading.dismiss();
              if (response == "Interest Inserted Successfully") {
                setState(() {
                  Controller.upcomingEvents.removeAt(index);
                });
                Controller.showSnackBar("Added to Interested Events", context);
                interestedEventsPageNo = 1;
                getInterestedEvents(true);
              } else {
                Controller.showSnackBar(response, context);
              }
            },
            child: Text(
              "Interested",
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.height10,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConfig.height30),
              ),
              side: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      onTap: () async {
        EasyLoading.show();
        String response = await APICalls.getEventDetails(
            Controller.upcomingEvents[index].eventID);
        EasyLoading.dismiss();
        if (response == "Successfully Retrieved EVent Details") {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClubEventDetailsScreen(
                  Controller.upcomingEvents[index].eventID, false),
            ),
          );
        } else {
          Controller.showSnackBar(response, context);
        }
      },
    );
  }

  Widget interestedEventsItem(int index) {
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
            child: Image.network(Controller.interestedEvents[index].banner,
                fit: BoxFit.contain),
          ),
          title: Text(
            Controller.interestedEvents[index].title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.height15,
                fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            Controller.interestedEvents[index].startDateTime,
            style:
                TextStyle(color: Colors.black, fontSize: SizeConfig.height15),
          ),
          trailing: OutlinedButton(
            onPressed: () async {
              EasyLoading.show();
              String response = await APICalls.eventInterest(
                  Controller.interestedEvents[index].eventID, "0");
              EasyLoading.dismiss();
              if (response == "Interest Removed Successfully") {
                setState(() {
                  Controller.interestedEvents.removeAt(index);
                });
                Controller.showSnackBar(
                    "Removed from Interested Events", context);
                upcomingEventsPageNo = 1;
                getUpcomingEvents();
              } else {
                Controller.showSnackBar(response, context);
              }
            },
            child: Text(
              "Remove",
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.height10,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConfig.height30),
              ),
              side: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      onTap: () async {
        EasyLoading.show();
        String response = await APICalls.getEventDetails(
            Controller.interestedEvents[index].eventID);
        EasyLoading.dismiss();
        if (response == "Successfully Retrieved EVent Details") {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClubEventDetailsScreen(
                  Controller.interestedEvents[index].eventID, false),
            ),
          );
        } else {
          Controller.showSnackBar(response, context);
        }
      },
    );
  }

  Widget getUpcomingEventsListView() {
    return ListView.separated(
      itemCount: Controller.upcomingEvents.length + 1,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: SizeConfig.height20,
        );
      },
      itemBuilder: (context, index) {
        if (Controller.upcomingEvents.length == 0) {
          return Center(
            child: Text("No upcoming events"),
          );
        } else {
          if (Controller.upcomingEvents.length == index) {
            return Align(
              child: LoadMoreButton(() => getUpcomingEvents()),
            );
          } else {
            return upcomingEventsItem(index);
          }
        }
      },
    );
  }

  Widget getInterestedEventsListView() {
    return ListView.separated(
      itemCount: Controller.interestedEvents.length + 1,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: SizeConfig.height20,
        );
      },
      itemBuilder: (context, index) {
        if (Controller.interestedEvents.length == 0) {
          return Center(
            child: Text("No events found"),
          );
        } else {
          if (Controller.interestedEvents.length == index) {
            return Align(
              child: LoadMoreButton(() => getInterestedEvents(true)),
            );
          } else {
            return interestedEventsItem(index);
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
                              "Events",
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
                              text: "Upcoming Events",
                            ),
                            Tab(
                              text: "Interested Events",
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
                            getUpcomingEventsListView(),
                            getInterestedEventsListView(),
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
