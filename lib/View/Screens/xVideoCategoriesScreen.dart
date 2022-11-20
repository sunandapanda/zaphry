import 'package:flutter/material.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Screens/xVideoSelectionScreen.dart';
import 'package:zaphry/View/Widgets/mydrawer.dart';
import 'package:zaphry/View/Widgets/navbarwhite.dart';

class VideoCategoriesScreen extends StatefulWidget {
  bool selectOrView = true; // true for select

  VideoCategoriesScreen(this.selectOrView);

  @override
  _VideoCategoriesScreenState createState() => _VideoCategoriesScreenState();
}

class _VideoCategoriesScreenState extends State<VideoCategoriesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget slider2() {
    return Container(
      height: SizeConfig.height100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: SizeConfig.width8),
              child: //Text('text $i', style: TextStyle(fontSize: 16.0),)
                  Image.asset(
                'lib/Assets/images/img_rechtangle.png',
                fit: BoxFit.cover,
              ),
            ),
            onTap: () {
              /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(),
                ),
              );*/
              // TODO
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Controller.onWillPop(context),
      child: Scaffold(
          //bottomNavigationBar: Mynav(),
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          endDrawer: Mydrawer(),
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.height55,
                    horizontal: SizeConfig.width35),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
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
                            "Training Plan",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Categories",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.height20),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  print("Private");
                                },
                                child: Text(
                                  'Private',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(Size(
                                        SizeConfig.width15,
                                        SizeConfig.height25)),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(
                                            horizontal: SizeConfig.width15)),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.black),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            SizeConfig.height25),
                                      ),
                                    )),
                              ),
                              Container(
                                height: SizeConfig.height25,
                                child: VerticalDivider(
                                  thickness: 1,
                                  color: Colors.black,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  print("Private");
                                },
                                child: Text(
                                  'Public',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(0),
                                    minimumSize: MaterialStateProperty.all(Size(
                                        SizeConfig.width15,
                                        SizeConfig.height25)),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(
                                            horizontal: SizeConfig.width15)),
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            SizeConfig.height25),
                                      ),
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.height10,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          child: Text(
                            "Dribling",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.height17),
                          ),
                          onTap: () {
                            if (Controller.memberType == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoSelectionScreen(),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.height15,
                      ),
                      slider2(),
                      SizedBox(
                        height: SizeConfig.height15,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          child: Text(
                            "Shooting",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.height17),
                          ),
                          onTap: () {
                            if (Controller.memberType == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoSelectionScreen(),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.height15,
                      ),
                      slider2(),
                      SizedBox(
                        height: SizeConfig.height15,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          child: Text(
                            "Moves",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.height17),
                          ),
                          onTap: () {
                            if (Controller.memberType == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoSelectionScreen(),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.height15,
                      ),
                      slider2(),
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
                  currIndex: Controller.memberType == 3 ? 2 : 3,
                  scaffoldKey: _scaffoldKey,
                ),
              ),
            ],
          )),
    );
  }
}
