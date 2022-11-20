import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:video_player/video_player.dart';
import 'package:zaphry/Controller/Controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController? videoPlayerController;

  @override
  void initState() {
    super.initState();

    videoPlayerController =
        VideoPlayerController.asset('lib/Assets/videos/splashVideo.mp4')
          ..initialize().then((_) {
            setState(() {
              videoPlayerController!.play();
            });
          });

    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.threeBounce
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Color(0xffF9C303)
      ..backgroundColor = Colors.black
      ..indicatorColor = Color(0xffF9C303)
      ..textColor = Color(0xffF9C303)
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..maskType = EasyLoadingMaskType.black
      ..userInteractions = false
      ..dismissOnTap = false;

    Timer(Duration(seconds: 5), () async {
      getNextScreen();
    });
  }

  void getNextScreen() async {
    EasyLoading.show();
    Widget nextScreen = await Controller.fromSplashToScreen();
    EasyLoading.dismiss();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => nextScreen,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: videoPlayerController!.value.isInitialized
          ? VideoPlayer(videoPlayerController!)
          : Image.asset('lib/Assets/images/splashImage.png'),
    );
  }
}
