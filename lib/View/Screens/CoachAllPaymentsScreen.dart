import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Widgets/LoadMoreButton.dart';
import 'package:zaphry/View/Widgets/mydrawer.dart';
import 'package:zaphry/View/Widgets/navbarwhite.dart';

class CoachAllPaymentsScreen extends StatefulWidget {
  const CoachAllPaymentsScreen({Key? key}) : super(key: key);

  @override
  _CoachAllPaymentsScreenState createState() => _CoachAllPaymentsScreenState();
}

class _CoachAllPaymentsScreenState extends State<CoachAllPaymentsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int pastPaymentsPageNo = 1;
  int upcomingPaymentsPageNo = 1;

  @override
  void initState() {
    super.initState();
    getPayments();
  }

  void getPastPayments() async {
    EasyLoading.show();
    String response = await APICalls.coachMyPayments(
        "past", pastPaymentsPageNo.toString(), "10");
    EasyLoading.dismiss();
    if (response == "Successfully returned Sessions data") {
      pastPaymentsPageNo += 1;
      setState(() {});
    } else {
      Controller.showSnackBar(response, context);
    }
  }

  void getUpcomingPayments() async {
    EasyLoading.show();
    String response = await APICalls.coachMyPayments(
        "upcoming", upcomingPaymentsPageNo.toString(), "5");
    EasyLoading.dismiss();
    if (response == "Successfully returned Sessions data") {
      upcomingPaymentsPageNo += 1;
      setState(() {});
    } else {
      Controller.showSnackBar(response, context);
    }
  }

  void getPayments() async {
    getUpcomingPayments();
    getPastPayments();
  }

  Widget upcomingPaymentsItem(int index) {
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
                      Controller.coachPendingPayments[index].date,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Controller.coachPendingPayments[index].startTime,
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
                      Controller.coachPendingPayments[index].sessionType,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width15,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: SizeConfig.width100,
                      child: Text(
                        Controller.coachPendingPayments[index].status,
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
                "\$ " + Controller.coachPendingPayments[index].price,
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

  Widget pastPaymentsItem(int index) {
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
                      Controller.coachSuccessfulPayments[index].dateTime
                          .substring(0, 12),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Controller.coachSuccessfulPayments[index].dateTime
                          .substring(13),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width10,
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
                      Controller.coachSuccessfulPayments[index].sessionType,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.width15,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: SizeConfig.width100,
                      child: Text(
                        Controller.coachSuccessfulPayments[index].status,
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
                "\$ " + Controller.coachSuccessfulPayments[index].price,
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

  Widget getUpcomingPaymentsListView() {
    return ListView.separated(
      itemCount: Controller.coachPendingPayments.length + 1,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: SizeConfig.height20,
        );
      },
      itemBuilder: (context, index) {
        if (Controller.coachPendingPayments.length == 0) {
          return Center(
            child: Text("No upcoming Payments"),
          );
        } else {
          if (Controller.coachPendingPayments.length == index) {
            return Align(
              child: LoadMoreButton(() => getUpcomingPayments()),
            );
          } else {
            return upcomingPaymentsItem(index);
          }
        }
      },
    );
  }

  Widget getPastPaymentsListView() {
    return ListView.separated(
      itemCount: Controller.coachSuccessfulPayments.length + 1,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: SizeConfig.height20,
        );
      },
      itemBuilder: (context, index) {
        if (Controller.coachSuccessfulPayments.length == 0) {
          return Center(
            child: Text("No payment data found"),
          );
        } else {
          if (Controller.coachSuccessfulPayments.length == index) {
            return Align(
              child: LoadMoreButton(() => getPastPayments()),
            );
          } else {
            return pastPaymentsItem(index);
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
                                "My Payments",
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
                                text: "Past Payments",
                              ),
                              Tab(
                                text: "Upcoming Payments",
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
                              getPastPaymentsListView(),
                              getUpcomingPaymentsListView(),
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
              )),
        ),
      ),
    );
  }
}
