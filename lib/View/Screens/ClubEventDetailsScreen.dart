import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Screens/EditEventScreen.dart';
import 'package:zaphry/View/Widgets/InquiryDialog.dart';
import 'package:zaphry/View/Widgets/mydrawer.dart';
import 'package:zaphry/View/Widgets/navbarwhite.dart';

import 'PhotoViewerScreen.dart';

class ClubEventDetailsScreen extends StatefulWidget {
  String eventID;
  bool showEdit;

  ClubEventDetailsScreen(this.eventID, this.showEdit);

  @override
  _ClubEventDetailsScreenState createState() => _ClubEventDetailsScreenState();
}

class _ClubEventDetailsScreenState extends State<ClubEventDetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CarouselController carouselController = CarouselController();

  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();

    initializeVideo();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController!.dispose();

    super.dispose();
  }

  void initializeVideo() async {
    if (Controller.ageGroupTexts.length <= 1) {
      await Controller.callProfileDropdownsAndCountryCodesAPI();
    }
    if (Controller.clubEventDetails!.video != null) {
      videoPlayerController =
          VideoPlayerController.network(Controller.clubEventDetails!.video!);
      await Future.wait([videoPlayerController.initialize()]);

      chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: false,
        looping: true,
      );

      setState(() {});
    }
  }

  String getStartDate(int timestamp) {
    String tempDate =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toString();
    String date = tempDate.split(" ")[0];
    String formattedDate = date.split("-")[2] +
        "/" +
        date.split("-")[1] +
        "/" +
        date.split("-")[0];
    return formattedDate;
  }

  Widget getAttachments() {
    if (Controller.clubEventDetails!.attachments != null &&
        Controller.clubEventDetails!.attachments!.length > 0) {
      return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Images",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: SizeConfig.height10,
          ),
          Stack(
            children: [
              Container(
                height: SizeConfig.height150,
                width: double.infinity,
                child: CarouselSlider(
                  carouselController: carouselController,
                  options: CarouselOptions(
                    enableInfiniteScroll: true,
                    enlargeCenterPage: true,
                  ),
                  items: Controller.clubEventDetails!.attachments!
                      .map(
                        (imageLink) => GestureDetector(
                          child: Container(
                            width: double.infinity,
                            height: SizeConfig.height150,
                            child: Image.network(
                              imageLink,
                              fit: BoxFit.contain,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhotoViewerScreen(
                                    Controller.clubEventDetails!.attachments!
                                        .indexOf(imageLink),
                                    Controller.clubEventDetails!.attachments!),
                              ),
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      carouselController.nextPage();
                    });
                  },
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                child: IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      carouselController.previousPage();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget getVideo() {
    return Controller.clubEventDetails!.video != null
        ? Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Video",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: SizeConfig.height10,
              ),
              Container(
                height: SizeConfig.height200,
                width: double.infinity,
                //color: Color(0xffF9C303),
                child: Center(
                  child: chewieController != null &&
                          chewieController!
                              .videoPlayerController.value.isInitialized
                      ? Chewie(
                          controller: chewieController!,
                        )
                      : CircularProgressIndicator(
                          color: Colors.black,
                        ),
                ),
              ),
            ],
          )
        : SizedBox.shrink();
  }

  bool checkForInquiry() {
    if (widget.showEdit) {
      return true;
    } else {
      return Controller.clubEventDetails!.inquiryStatus == "1" ? true : false;
    }
  }

  String getAgeGroupFromID(String ageID) {
    return Controller
        .ageGroupTexts[Controller.ageGroupValues.indexOf(int.parse(ageID))];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // bottomNavigationBar: Mynav(),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        endDrawer: Mydrawer(),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.height55,
                  horizontal: SizeConfig.width35),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButton(),
                      Text(
                        "Event Details",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.height20,
                          fontWeight: FontWeight.bold,
                        ),
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
                  SizedBox(
                    height: SizeConfig.height20,
                  ),
                  Container(
                    height: SizeConfig.height500,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Container(
                          height: SizeConfig.height150,
                          width: double.infinity,
                          //color: Color(0xffF9C303),
                          child: Image.network(
                            Controller.clubEventDetails!.banner,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.height15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                Controller.clubEventDetails!.title,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: SizeConfig.height17),
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.width10,
                            ),
                            checkForInquiry()
                                ? ElevatedButton(
                                    onPressed: () async {
                                      if (widget.showEdit) {
                                        if (Controller.ageGroupTexts.length >
                                            1) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditEventScreen(
                                                      widget.eventID),
                                            ),
                                          );
                                        } else {
                                          bool check = await Controller
                                              .callProfileDropdownsAndCountryCodesAPI();
                                          if (check) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditEventScreen(
                                                        widget.eventID),
                                              ),
                                            );
                                          } else {
                                            Controller.showSnackBar(
                                                "Unable to process request at the time",
                                                context);
                                          }
                                        }
                                      } else {
                                        await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return InquiryDialog(
                                                widget.eventID);
                                          },
                                        );
                                      }
                                    },
                                    child: Text(
                                      widget.showEdit ? "Edit" : "Inquire",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.black),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                SizeConfig.height25),
                                          ),
                                        ),
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.symmetric(
                                                horizontal:
                                                    SizeConfig.width25))),
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: SizeConfig.height10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Start Date",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              getStartDate(int.parse(
                                  Controller.clubEventDetails!.startDateTime)),
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: SizeConfig.height10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Author",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              Controller.clubEventDetails!.eventUserName,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: SizeConfig.height10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Age Group",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              getAgeGroupFromID(
                                  Controller.clubEventDetails!.ageGroup),
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: SizeConfig.height10,
                        ),
                        Text(
                          "Description",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.height10,
                        ),
                        Text(
                          Controller.clubEventDetails!.description,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: SizeConfig.height10,
                        ),
                        getAttachments(),
                        getVideo(),
                      ],
                    ),
                  ),
                ],
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
            ),
          ],
        ));
  }
}
