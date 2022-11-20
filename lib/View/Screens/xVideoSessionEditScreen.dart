import 'package:flutter/material.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Widgets/mydrawer.dart';
import 'package:zaphry/View/Widgets/navbarwhite.dart';

class VideoSessionEditScreen extends StatefulWidget {
  const VideoSessionEditScreen({Key? key}) : super(key: key);

  @override
  _VideoSessionEditScreenState createState() => _VideoSessionEditScreenState();
}

class _VideoSessionEditScreenState extends State<VideoSessionEditScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // bottomNavigationBar: Mynav(),
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        endDrawer: Mydrawer(),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.height55,
                    horizontal: SizeConfig.width35),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "lib/Assets/images/zaphry.png",
                          fit: BoxFit.cover,
                          width: SizeConfig.width30,
                        ),
                        Text(
                          "Dribbling",
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
                      height: SizeConfig.height30,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Details",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.height17),
                      ),
                    ),
                    SizedBox(height: SizeConfig.height5),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Duration of this session is 9 mins. In this session you will learn more about dribbling.",
                        style: TextStyle(
                            color: Colors.black, fontSize: SizeConfig.height13),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.height30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'lib/Assets/images/smallrectangle.png',
                              fit: BoxFit.cover,
                              width: SizeConfig.width35,
                            ),
                            SizedBox(
                              width: SizeConfig.width8,
                            ),
                            Text(
                              "Straight Cone Dribble",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "0:44",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.width5,
                            ),
                            Icon(Icons.clear)
                          ],
                        )
                      ],
                    ),
                    Container(
                      height: SizeConfig.height10,
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'lib/Assets/images/smallrectangle.png',
                              fit: BoxFit.cover,
                              width: SizeConfig.width35,
                            ),
                            SizedBox(
                              width: SizeConfig.width8,
                            ),
                            Text(
                              "Straight Cone Dribble",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "0:44",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.width5,
                            ),
                            Icon(Icons.clear)
                          ],
                        )
                      ],
                    ),
                    Container(
                      height: SizeConfig.height10,
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'lib/Assets/images/smallrectangle.png',
                              fit: BoxFit.cover,
                              width: SizeConfig.width35,
                            ),
                            SizedBox(
                              width: SizeConfig.width8,
                            ),
                            Text(
                              "Straight Cone Dribble",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "0:44",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.width5,
                            ),
                            Icon(Icons.clear)
                          ],
                        )
                      ],
                    ),
                    Container(
                      height: SizeConfig.height10,
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'lib/Assets/images/smallrectangle.png',
                              fit: BoxFit.cover,
                              width: SizeConfig.width35,
                            ),
                            SizedBox(
                              width: SizeConfig.width8,
                            ),
                            Text(
                              "Straight Cone Dribble",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "0:44",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.width5,
                            ),
                            Icon(Icons.clear)
                          ],
                        )
                      ],
                    ),
                    Container(
                      height: SizeConfig.height10,
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'lib/Assets/images/smallrectangle.png',
                              fit: BoxFit.cover,
                              width: SizeConfig.width35,
                            ),
                            SizedBox(
                              width: SizeConfig.width8,
                            ),
                            Text(
                              "Straight Cone Dribble",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "0:44",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.width5,
                            ),
                            Icon(Icons.clear)
                          ],
                        )
                      ],
                    ),
                    Container(
                      height: SizeConfig.height10,
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.height35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              print("add videos");
                            },
                            child: Text(
                              "Add Video",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        horizontal: SizeConfig.width25)),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.height25),
                                )))),
                        ElevatedButton(
                            onPressed: () {
                              print("add videos");
                            },
                            child: Text(
                              "Save & Print",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        horizontal: SizeConfig.width20)),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.height25),
                                )))),
                      ],
                    )
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
            ),
          ],
        ));
  }
}
