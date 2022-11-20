import 'package:flutter/material.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Screens/xVideoSessionEditScreen.dart';
import 'package:zaphry/View/Widgets/mydrawer.dart';
import 'package:zaphry/View/Widgets/navbarwhite.dart';

class VideoSelectionScreen extends StatefulWidget {
  const VideoSelectionScreen({Key? key}) : super(key: key);

  @override
  _VideoSelectionScreenState createState() => _VideoSelectionScreenState();
}

class _VideoSelectionScreenState extends State<VideoSelectionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget slider2() {
    return Container(
      height: SizeConfig.height100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
              margin: EdgeInsets.symmetric(horizontal: SizeConfig.width8),
              child: //Text('text $i', style: TextStyle(fontSize: 16.0),)
                  Image.asset(
                'lib/Assets/images/img_rechtangle.png',
                fit: BoxFit.cover,
              ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // bottomNavigationBar: Mynav(),
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        endDrawer: Mydrawer(),
        body: Stack(
          children: [
            Container(
              padding:
                   EdgeInsets.symmetric(vertical: SizeConfig.height55, horizontal: SizeConfig.width35),
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
                          fontSize: SizeConfig.width20,
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
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.height18)),
                          primary: Colors.black,
                          minimumSize: Size(
                              SizeConfig.width10, SizeConfig.height30),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoSessionEditScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Proceed',
                          style: TextStyle(
                              fontSize: SizeConfig.height15,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.height10,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Dribbling",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.height17),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.height10,
                  ),
                  /*slider2(),
                  SizedBox(
                    height: 18,
                  ),
                  slider2(),
                  SizedBox(
                    height: 18,
                  ),
                  slider2(),*/
                  Container(
                    height: SizeConfig.height400,
                    width: SizeConfig.width400,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      itemCount: 15,
                      itemBuilder: (context, index) {
                        return Container(
                            height: SizeConfig.height100,
                            width: SizeConfig.width100,
                            //margin: EdgeInsets.symmetric(horizontal: 8.0),
                            child: //Text('text $i', style: TextStyle(fontSize: 16.0),)
                            Image.asset(
                              'lib/Assets/images/img_rechtangle.png',
                              fit: BoxFit.cover,
                            ));
                      },
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
