import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/Model/SearchSession.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Screens/CoachAllPaymentsScreen.dart';
import 'package:zaphry/View/Screens/PlayerAllPaymentsScreen.dart';
import 'package:zaphry/View/Screens/WebViewScreen.dart';
import 'package:zaphry/View/Widgets/PromotionalDialog.dart';
import 'package:zaphry/View/Widgets/mydrawer.dart';
import 'package:zaphry/View/Widgets/navbarwhite.dart';

import 'BookTrainingScreen.dart';

class PayNowScreen extends StatefulWidget {
  List<SearchSession> bookedSessions = [];
  double totalPrice = 0;

  PayNowScreen(this.bookedSessions) {
    for (int c = 0; c < bookedSessions.length; c++) {
      totalPrice += double.parse(bookedSessions[c].price);
    }
  }

  @override
  _PayNowScreenState createState() => _PayNowScreenState();
}

class _PayNowScreenState extends State<PayNowScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String makeSlotsString() {
    String slots = "";
    for (int c = 0; c < widget.bookedSessions.length; c++) {
      slots += widget.bookedSessions[c].id;
      if (c + 1 != widget.bookedSessions.length) {
        slots += ",";
      }
    }
    return slots;
  }

  Widget getListViewSession(int index) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.height10, horizontal: SizeConfig.width20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.height25),
        color: Color(0xffF9C303),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        widget.bookedSessions[index].date,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.width15,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.bookedSessions[index].startTime,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.width15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.width5),
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
                        widget.bookedSessions[index].sessionType,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.width15,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        width: SizeConfig.width80,
                        child: Text(
                          widget.bookedSessions[index].coach,
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
              Column(
                children: [
                  SizedBox(
                    height: SizeConfig.height15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IgnorePointer(
                        child: RatingBar.builder(
                          itemSize: SizeConfig.height18,
                          initialRating:
                              double.parse(widget.bookedSessions[index].rating),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
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
                        width: SizeConfig.width80,
                        child: OutlinedButton(
                          onPressed: () {},
                          child: Text(
                            "\$ ${widget.bookedSessions[index].price}",
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
                            backgroundColor: Color(0xffF9C303),
                            side: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              child: Icon(
                Icons.clear,
                size: SizeConfig.height18,
              ),
              onTap: () {
                setState(() {
                  widget.totalPrice -=
                      double.parse(widget.bookedSessions[index].price);
                  widget.bookedSessions.removeAt(index);
                });
              },
            ),
          ),
        ],
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
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('lib/Assets/images/booktraing.png'),
                        fit: BoxFit.cover),
                  ),
                  child: Padding(
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
                            Row(
                              children: [
                                BackButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BookTrainingScreen(),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  width: SizeConfig.width10,
                                ),
                                Text(
                                  "Credits",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: SizeConfig.height20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
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
                          height: SizeConfig.height35,
                        ),
                        Container(
                          height: SizeConfig.height380,
                          child: ListView.separated(
                            itemCount: widget.bookedSessions.length,
                            itemBuilder: (context, index) =>
                                getListViewSession(index),
                            separatorBuilder: (context, index) => SizedBox(
                              height: SizeConfig.height25,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.height20,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Total Amount",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  height: SizeConfig.height20,
                                  width: SizeConfig.width120,
                                  child: OutlinedButton(
                                    onPressed: () {},
                                    child: Text(
                                      "USD: ${widget.totalPrice.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Color(0xffF9C303),
                                        fontSize: SizeConfig.height10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      shape: new RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            SizeConfig.height30),
                                      ),
                                      backgroundColor: Colors.black,
                                      side: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizeConfig.height10,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox.shrink(),
                                Container(
                                  height: SizeConfig.height20,
                                  width: SizeConfig.width120,
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      if (widget.bookedSessions.length > 0) {
                                        EasyLoading.show();
                                        String slots = makeSlotsString();
                                        String response =
                                            await APICalls.payNow(slots);
                                        EasyLoading.dismiss();
                                        if (response ==
                                            "Successfully Created Payment") {
                                          Controller.showSnackBar(
                                              response, context);
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  WebViewScreen(
                                                      Controller.paymentLink),
                                            ),
                                          );
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Controller
                                                          .memberType ==
                                                      1
                                                  ? CoachAllPaymentsScreen()
                                                  : PlayerAllPaymentsScreen(),
                                            ),
                                          );
                                        } else if (response ==
                                            "Successfully Generated Payment") {
                                          await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return PromotionalDialog();
                                            },
                                          );
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Controller
                                                          .memberType ==
                                                      1
                                                  ? CoachAllPaymentsScreen()
                                                  : PlayerAllPaymentsScreen(),
                                            ),
                                          );
                                        } else {
                                          Controller.showSnackBar(
                                              response, context);
                                        }
                                      }
                                    },
                                    child: Text(
                                      "Pay Now",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: SizeConfig.height10,
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
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(
                          height: SizeConfig.height25,
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
                    currIndex: 3,
                    scaffoldKey: _scaffoldKey,
                  ),
                )
              ],
            )),
      ),
    );
  }
}
