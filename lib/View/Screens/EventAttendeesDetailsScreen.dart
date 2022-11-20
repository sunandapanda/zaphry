import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Widgets/LoadMoreButton.dart';
import 'package:zaphry/View/Widgets/RequestedProfileDialog.dart';
import 'package:zaphry/View/Widgets/mydrawer.dart';

class EventAttendeesDetailsScreen extends StatefulWidget {
  String eventID;

  EventAttendeesDetailsScreen(this.eventID);

  @override
  _EventAttendeesDetailsScreenState createState() =>
      _EventAttendeesDetailsScreenState();
}

class _EventAttendeesDetailsScreenState
    extends State<EventAttendeesDetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int attendeesPageNo = 1;

  @override
  void initState() {
    super.initState();
    getAttendees();
  }

  Future<void> getAttendees() async {
    EasyLoading.show();
    String response = await APICalls.getAttendeesDetails(
        widget.eventID, attendeesPageNo.toString(), "10");
    EasyLoading.dismiss();
    if (response == "Successfully Retrieved Events Users Data") {
      setState(() {
        attendeesPageNo += 1;
      });
    } else {
      Controller.showSnackBar(response, context);
    }
  }

  Widget attendeeItem(int index) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.height10, horizontal: SizeConfig.width20),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.height20),
          color: Color(0xffF9C303),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: SizeConfig.height25,
              backgroundColor: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(SizeConfig.height25),
                child: CircleAvatar(
                  backgroundColor: Color(0xffF9C303),
                  radius: SizeConfig.height23,
                  child: Image.network(Controller
                      .eventAttendeesDetailsList[index].eventUserImage!),
                ),
              ),
            ),
            SizedBox(width: SizeConfig.width15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: SizeConfig.width230,
                  child: Text(
                    Controller.eventAttendeesDetailsList[index].eventUserName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.height17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  Controller.eventAttendeesDetailsList[index].eventUserType,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.height15,
                  ),
                ),
                Text(
                  Controller.eventAttendeesDetailsList[index].eventUserZIPCode,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.height15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () async {
        EasyLoading.show();
        String response = await APICalls.requestProfile(
            Controller.eventAttendeesDetailsList[index].eventUserID);
        EasyLoading.dismiss();
        if (response == "Successfully returned profile data") {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return RequestedProfileDialog();
            },
          );
        } else {
          Controller.showSnackBar(response, context);
        }
      },
    );
  }

  Widget getAttendeesListView() {
    return ListView.separated(
      itemCount: Controller.eventAttendeesDetailsList.length + 1,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: SizeConfig.height20,
        );
      },
      itemBuilder: (context, index) {
        if (Controller.eventAttendeesDetailsList.length == 0) {
          return Center(
            child: Text("No Attendees Found"),
          );
        } else {
          if (Controller.eventAttendeesDetailsList.length == index) {
            return LoadMoreButton(() => getAttendees());
          } else {
            return attendeeItem(index);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          endDrawer: Mydrawer(),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('lib/Assets/images/booktraing.png'),
                  fit: BoxFit.cover),
            ),
            child: Column(
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
                      BackButton(),
                      Text(
                        "Attendees",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.height20,
                            fontWeight: FontWeight.bold),
                      ),
                      BackButton(
                        color: Colors.transparent,
                        onPressed: () {
                          // do nothing
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: SizeConfig.height500,
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.width30),
                  child: getAttendeesListView(),
                ),
              ],
            ),
          )),
    );
  }
}
