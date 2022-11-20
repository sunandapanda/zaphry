import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/Model/TrainingPlanVideo.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Screens/TrainingPlanFinalScreen.dart';
import 'package:zaphry/View/Widgets/mydrawer.dart';

import 'VideoPlayerScreen.dart';

class TrainingPlanVideosSelectionScreen extends StatefulWidget {
  const TrainingPlanVideosSelectionScreen({Key? key}) : super(key: key);

  @override
  _TrainingPlanVideosSelectionScreenState createState() =>
      _TrainingPlanVideosSelectionScreenState();
}

class _TrainingPlanVideosSelectionScreenState
    extends State<TrainingPlanVideosSelectionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController scrollController = ScrollController();

  bool showError = false;
  int pageNumber = 1;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    Controller.trainingPlanSelectedVideos.clear();

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
    String videoResponse = await APICalls.getTrainingPlanVideos(
        index == null
            ? Controller.videoCategoryIDs[0]
            : Controller.videoCategoryIDs[index],
        pageNumber.toString(),
        "9");
    EasyLoading.dismiss();
    if (videoResponse != "Successfully Retrieved Videos") {
      Controller.showSnackBar(videoResponse, context);
    } else {
      pageNumber += 1;
      if (index != null) {
        selectedIndex = index;
      }
    }
    setState(() {});
  }

  bool checkIfSelected(String id) {
    int index = Controller.trainingPlanSelectedVideos
        .indexWhere((element) => element.id == id);
    if (index >= 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget getVideoItem(TrainingPlanVideo video) {
    return Container(
      decoration: BoxDecoration(
        color:
            checkIfSelected(video.id) ? Color(0xffF9C303) : Colors.transparent,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: GestureDetector(
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
              child: Image.network(video.image, fit: BoxFit.cover),
            ),
          ),
          onTap: () async {
            setState(() {
              if (checkIfSelected(video.id)) {
                Controller.trainingPlanSelectedVideos
                    .removeWhere((element) => element.id == video.id);
              } else {
                Controller.trainingPlanSelectedVideos.add(video);
              }
            });
          },
          onLongPress: () async {
            EasyLoading.show();
            String response = await APICalls.getVideoDetails(video.id);
            EasyLoading.dismiss();
            if (response == "Successfully Retrieved Video Details") {
              if (Controller.videoDetails != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(allowEdit: false),
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
        ),
      ),
    );
  }

  Widget getVideosContainer() {
    return Container(
      height: SizeConfig.height450,
      width: double.infinity,
      padding: EdgeInsets.only(
          top: SizeConfig.height10,
          left: SizeConfig.height10,
          right: SizeConfig.height10),
      child: Controller.trainingPlanVideos.length > 0
          ? GridView.count(
              controller: scrollController,
              crossAxisCount: 3,
              children: Controller.trainingPlanVideos
                  .map(
                    (video) => getVideoItem(video),
                  )
                  .toList(),
            )
          : Center(
              child: Text("No videos found in this category"),
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      endDrawer: Mydrawer(),
      /*bottomNavigationBar: MynavWhite(
        colorType: 1,
        currIndex: Controller.memberType == 3 ? 2 : 3,
      ),*/
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
                    BackButton(),
                    Text(
                      "Video Selection",
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
                          color: Colors.transparent,
                        ),
                        onPressed: null,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.height15,
              ),
              getCategoryTabs(),
              getVideosContainer(),
            ],
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.height10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Videos Selected: ${Controller.trainingPlanSelectedVideos.length}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.height15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.height18)),
                      primary: Colors.black,
                      minimumSize:
                          Size(SizeConfig.width10, SizeConfig.height30),
                    ),
                    onPressed: Controller.trainingPlanSelectedVideos.length > 0
                        ? () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TrainingPlanFinalScreen(),
                              ),
                            );
                            setState(() {});
                          }
                        : null,
                    child: Text(
                      'Proceed',
                      style: TextStyle(
                          fontSize: SizeConfig.height15, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          showError
              ? Center(
                  child: Text("Unable to load videos"),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
