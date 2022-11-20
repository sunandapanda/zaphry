import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/Model/Video.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Widgets/AddVideoDialog.dart';
import 'package:zaphry/View/Widgets/DeleteDialog.dart';
import 'package:zaphry/View/Widgets/mydrawer.dart';
import 'package:zaphry/View/Widgets/navbarwhite.dart';

import 'VideoPlayerScreen.dart';

class CoachVideoCategoriesScreen extends StatefulWidget {
  const CoachVideoCategoriesScreen({Key? key}) : super(key: key);

  @override
  _CoachVideoCategoriesScreenState createState() =>
      _CoachVideoCategoriesScreenState();
}

class _CoachVideoCategoriesScreenState
    extends State<CoachVideoCategoriesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController scrollController = ScrollController();

  bool showError = false;
  int pageNumber = 1;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getCategories();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!EasyLoading.isShow) {
          getVideos(index: selectedIndex);
        }
      }
    });
  }

  void getCategories() async {
    if (Controller.videoCategoryNames.length <= 0) {
      EasyLoading.show();
      String response = await APICalls.getCategories();
      EasyLoading.dismiss();
      if (response == "Successfully returned details") {
        setState(() {});
        getVideos();
      } else {
        Controller.showSnackBar(response, context);
        setState(() {
          showError = true;
        });
      }
    } else {
      getVideos();
    }
  }

  Future<void> getVideos({int? index}) async {
    EasyLoading.show();
    String videoResponse = await APICalls.getCoachVideos(
        index == null
            ? Controller.videoCategoryIDs[0]
            : Controller.videoCategoryIDs[index],
        pageNumber.toString(),
        "9");
    EasyLoading.dismiss();
    if (videoResponse != "Successfully returned Videos data") {
      Controller.showSnackBar(videoResponse, context);
    } else {
      pageNumber += 1;
      if (index != null) {
        selectedIndex = index;
      }
    }
    setState(() {});
  }

  Widget getVideoItem(Video video, bool isCoach) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            child: Image.network(video.image!, fit: BoxFit.cover),
          ),
        ),
      ),
      onTap: () async {
        EasyLoading.show();
        String response = await APICalls.getVideoDetails(video.id);
        EasyLoading.dismiss();
        if (response == "Successfully Retrieved Video Details") {
          if (Controller.videoDetails != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(allowEdit: isCoach),
              ),
            );
          } else {
            Controller.showSnackBar(
                "Unable to process request at the moment", context);
          }
        } else {
          Controller.showSnackBar(response, context);
        }
      },
      onLongPress: isCoach
          ? () async {
              bool result = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DeleteDialog();
                },
              );
              if (result) {
                EasyLoading.show();
                String response = await APICalls.deleteVideo(video.id);
                EasyLoading.dismiss();
                if (response == "Successfully Deleted Video") {
                  int itemIndex = Controller.userCoachVideos
                      .indexWhere((element) => element.id == video.id);
                  if (itemIndex >= 0) {
                    setState(() {
                      Controller.userCoachVideos.removeAt(itemIndex);
                    });
                  }
                }
                Controller.showSnackBar(response, context);
              }
            }
          : null,
    );
  }

  Widget getCoachVideos() {
    return Container(
      height: SizeConfig.height420,
      width: double.infinity,
      padding: EdgeInsets.only(
          top: SizeConfig.height10,
          left: SizeConfig.height10,
          right: SizeConfig.height10),
      child: Controller.userCoachVideos.length > 0
          ? GridView.count(
              controller: scrollController,
              crossAxisCount: 3,
              children: Controller.userCoachVideos
                  .map(
                    (coachVideo) => getVideoItem(coachVideo, true),
                  )
                  .toList(),
            )
          : Center(
              child: Text("No videos found in this category"),
            ),
    );
  }

  Widget getClubVideos() {
    return Container(
      height: SizeConfig.height420,
      width: double.infinity,
      padding: EdgeInsets.only(
          top: SizeConfig.height10,
          left: SizeConfig.height10,
          right: SizeConfig.height10),
      child: Controller.userClubVideos.length > 0
          ? GridView.count(
              controller: scrollController,
              crossAxisCount: 3,
              children: Controller.userClubVideos
                  .map(
                    (clubVideo) => getVideoItem(clubVideo, false),
                  )
                  .toList(),
            )
          : Center(
              child: Text("No videos found in this category"),
            ),
    );
  }

  Widget getTabBarViews() {
    return Container(
      height: SizeConfig.height400,
      child: TabBarView(
        //physics: NeverScrollableScrollPhysics(),
        children: [
          getCoachVideos(),
          getClubVideos(),
        ],
      ),
    );
  }

  Widget getCoachClubTabs() {
    return Container(
      child: TabBar(
        tabs: [
          Tab(
            text: "Coach Videos",
          ),
          Tab(
            text: "Club Videos",
          ),
        ],
      ),
    );
  }

  Widget getCategoryTabs() {
    return Container(
      height: SizeConfig.height50,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: Controller.videoCategoryNames.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.width5),
            child: Center(
              child: ElevatedButton(
                onPressed: selectedIndex != index
                    ? () {
                        pageNumber = 1;
                        getVideos(index: index);
                      }
                    : null,
                child: Text(
                  Controller.videoCategoryNames[index],
                  style: TextStyle(
                      color:
                          index == selectedIndex ? Colors.black : Colors.white),
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SizeConfig.height25),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                      index == selectedIndex
                          ? Color(0xffF9C303)
                          : Colors.black),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Controller.onWillPop(context),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          endDrawer: Mydrawer(),
          bottomNavigationBar: MynavWhite(
            colorType: 1,
            currIndex: Controller.memberType == 3 ? 2 : 3,
            scaffoldKey: _scaffoldKey,
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(SizeConfig.width35,
                        SizeConfig.height55, SizeConfig.width35, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "lib/Assets/images/zaphry.png",
                          fit: BoxFit.cover,
                          width: SizeConfig.width30,
                        ),
                        Text(
                          "Video Gallery",
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
                  ),
                  SizedBox(
                    height: SizeConfig.height15,
                  ),
                  getCategoryTabs(),
                  getCoachClubTabs(),
                  getTabBarViews(),
                ],
              ),
              /*Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: MynavWhite(
                  colorType: 1,
                  currIndex: Controller.memberType == 3 ? 2 : 3,
                ),
              ),*/
              showError
                  ? Center(
                      child: Text("Unable to load videos"),
                    )
                  : SizedBox.shrink(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Color(0xffF9C303),
            onPressed: () async {
              if (!showError) {
                bool response = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddVideoDialog(isCoach: true);
                  },
                );
                if (response) {
                  pageNumber = 1;
                  getVideos();
                  setState(() {
                    selectedIndex = 0;
                  });
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
