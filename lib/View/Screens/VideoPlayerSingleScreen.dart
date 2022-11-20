import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';

class VideoPlayerSingleScreen extends StatefulWidget {
  String videoPath;

  VideoPlayerSingleScreen(this.videoPath);

  @override
  _VideoPlayerSingleScreenState createState() =>
      _VideoPlayerSingleScreenState();
}

class _VideoPlayerSingleScreenState extends State<VideoPlayerSingleScreen> {
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
    videoPlayerController = VideoPlayerController.network(widget.videoPath);
    await Future.wait([videoPlayerController.initialize()]);

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: Mynav(),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.height55, horizontal: SizeConfig.width35),
        child: Center(
          child: chewieController != null &&
                  chewieController!.videoPlayerController.value.isInitialized
              ? Chewie(
                  controller: chewieController!,
                )
              : CircularProgressIndicator(
                  color: Colors.black,
                ),
        ),
      ),
    );
  }
}
