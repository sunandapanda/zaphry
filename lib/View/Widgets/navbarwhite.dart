import 'package:flutter/material.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Screens/BookTrainingScreen.dart';
import 'package:zaphry/View/Screens/ClubProfileScreen.dart';
import 'package:zaphry/View/Screens/ClubVideoCategoriesScreen.dart';
import 'package:zaphry/View/Screens/CoachProfileScreen.dart';
import 'package:zaphry/View/Screens/CreateTrainingScreen.dart';
import 'package:zaphry/View/Screens/DashboardClubScreen.dart';
import 'package:zaphry/View/Screens/DashboardScreen.dart';
import 'package:zaphry/View/Screens/PlayerProfileScreen.dart';

class MynavWhite extends StatefulWidget {
  int colorType = 0; // 0 for white, 1 for yellow
  int currIndex = 0;

  GlobalKey<ScaffoldState>? scaffoldKey;

  MynavWhite({required this.colorType, required this.currIndex, required this.scaffoldKey});

  @override
  _MynavWhiteState createState() => _MynavWhiteState();
}

class _MynavWhiteState extends State<MynavWhite> {
  Color getSelectedColor(int index) {
    if (index == widget.currIndex) {
      return widget.colorType == 0 ? Color(0xffF9C303) : Colors.white;
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(SizeConfig.height20),
        topRight: Radius.circular(SizeConfig.height20),
      ),
      child: BottomNavigationBar(
        currentIndex: widget.currIndex,
        onTap: (value) {
          if (widget.currIndex != 0 && value == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Controller.memberType == 3
                    ? DashboardClubScreen()
                    : DashboardScreen(),
              ),
            );
          } else if (widget.currIndex != 1 && value == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Controller.memberType == 1
                    ? CoachProfileScreen()
                    : (Controller.memberType == 2
                        ? PlayerProfileScreen()
                        : ClubProfileScreen()),
              ),
            );
          } else if (widget.currIndex != 2 && value == 2) {
            if (Controller.memberType == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateTrainingScreen(),
                ),
              );
            } else if (Controller.memberType == 2) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BookTrainingScreen(),
                ),
              );
            } else if (Controller.memberType == 3) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ClubVideoCategoriesScreen(),
                ),
              );
            }
          } else if (value == 3) {
            if (widget.scaffoldKey != null) {
              widget.scaffoldKey!.currentState!.openEndDrawer();
            }
          }
          /*if (!(widget.currIndex != 3 && value == 3)) {
            setState(() {
              widget.currIndex = value;
            });
          }*/
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
            fontSize: SizeConfig.height10,
            fontWeight: FontWeight.bold,
            color: Colors.black),
        unselectedLabelStyle: TextStyle(
            fontSize: SizeConfig.height10,
            fontWeight: FontWeight.bold,
            color: Colors.black),
        elevation: 0,
        backgroundColor:
            widget.colorType == 0 ? Colors.white : Color(0xffF9C303),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: getSelectedColor(0),
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_box,
                color: getSelectedColor(1),
              ),
              label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(
              Controller.memberType != 3
                  ? Icons.control_point
                  : Icons.video_collection,
              color: getSelectedColor(2),
            ),
            label: Controller.memberType == 1
                ? 'Create Session'
                : (Controller.memberType == 2
                    ? 'Book Session'
                    : 'Video Gallery'),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.menu,
                color: getSelectedColor(3),
              ),
              label: "Menu"),
        ],
      ),
    );
  }
}
