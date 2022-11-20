import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Screens/PhotoViewerScreen.dart';
import 'package:zaphry/View/Widgets/EditVideoDialog.dart';
import 'package:zaphry/View/Widgets/mydrawer.dart';
import 'package:zaphry/View/Widgets/navbarwhite.dart';

class VideoPlayerScreen extends StatefulWidget {
  bool allowEdit;

  VideoPlayerScreen({required this.allowEdit});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CarouselController carouselController = CarouselController();

  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();

    initializeVideo();

    /*videoPlayerController =
    VideoPlayerController.network(Controller.videoDetails!.videoLink)
      ..initialize().then((_) {
        setState(() {
          videoPlayerController!.play();
        });
      });*/
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController!.dispose();

    super.dispose();
  }

  void initializeVideo() async {
    videoPlayerController =
        VideoPlayerController.network(Controller.videoDetails!.videoLink);
    await Future.wait([videoPlayerController.initialize()]);

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );

    setState(() {});
  }

  String getRecipients(String value) {
    if (value == "1") {
      return "Both";
    } else if (value == "2") {
      return "Players";
    } else {
      return "Coaches";
    }
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
                        Controller.videoDetails!.category,
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
                  SizedBox(
                    height: SizeConfig.height10,
                  ),
                  Container(
                    height: SizeConfig.height280,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        SizedBox(height: SizeConfig.height5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                Controller.videoDetails!.title,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: SizeConfig.height17),
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.width10,
                            ),
                            widget.allowEdit
                                ? ElevatedButton(
                                    onPressed: () async {
                                      await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return EditVideoDialog();
                                        },
                                      );
                                      setState(() {});
                                    },
                                    child: Text(
                                      "Edit",
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
                              "Duration",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              Controller.videoDetails!.duration,
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
                              Controller.videoDetails!.author,
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
                              "Recipients",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              getRecipients(
                                  Controller.videoDetails!.recipients),
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
                              "Status",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              Controller.videoDetails!.status == "1"
                                  ? "Active"
                                  : "Inactive",
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
                          Controller.videoDetails!.description,
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
                        Controller.videoDetails!.imagesLinks.length > 0
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Images",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                        Controller.videoDetails!.imagesLinks.length > 0
                            ? SizedBox(
                                height: SizeConfig.height10,
                              )
                            : SizedBox.shrink(),
                        Controller.videoDetails!.imagesLinks.length > 0
                            ? Stack(
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
                                      items: Controller
                                          .videoDetails!.imagesLinks
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
                                                    builder: (context) =>
                                                        PhotoViewerScreen(
                                                            Controller
                                                                .videoDetails!
                                                                .imagesLinks
                                                                .indexOf(
                                                                    imageLink),
                                                            Controller
                                                                .videoDetails!
                                                                .imagesLinks),
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
                              )
                            /*Column(
                                children: Controller.videoDetails!.imagesLinks
                                    .map((imageLink) => Container(
                                          width: double.infinity,
                                          height: SizeConfig.height150,
                                          child: Image.network(
                                            imageLink,
                                            fit: BoxFit.contain,
                                          ),
                                        ))
                                    .toList(),
                              )*/
                            : SizedBox.shrink(),
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
                currIndex: Controller.memberType == 3 ? 2 : 3,
                scaffoldKey: _scaffoldKey,
              ),
            ),
          ],
        ));
  }
}
