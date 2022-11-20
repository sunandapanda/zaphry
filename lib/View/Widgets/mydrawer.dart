import 'package:flutter/material.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Screens/CoachAllPaymentsScreen.dart';
import 'package:zaphry/View/Screens/CoachMySessionsScreen.dart';
import 'package:zaphry/View/Screens/CoachVideoCategoriesScreen.dart';
import 'package:zaphry/View/Screens/EventsScreen.dart';
import 'package:zaphry/View/Screens/PlayerAllPaymentsScreen.dart';
import 'package:zaphry/View/Screens/PlayerMyTrainingsScreen.dart';
import 'package:zaphry/View/Screens/PlayerVideoCategoriesScreen.dart';
import 'package:zaphry/View/Screens/SignInScreen.dart';
import 'package:zaphry/View/Screens/TrainingPlanScreen.dart';
import 'package:zaphry/View/Screens/TrainingProgramScreen.dart';
import 'package:zaphry/View/Screens/VerificationAssociatedScreen.dart';
import 'package:zaphry/View/Widgets/ChangePasswordDialog.dart';

import 'LogoutDialog.dart';

class Mydrawer extends StatefulWidget {
  const Mydrawer({Key? key}) : super(key: key);

  @override
  _MydrawerState createState() => _MydrawerState();
}

class _MydrawerState extends State<Mydrawer> {
  bool? isEmail;

  bool verificationTileCondition() {
    print("membertype: " + Controller.memberType.toString());
    if (Controller.memberType == 1) {
      if (Controller.coachProfile != null) {
        if (Controller.coachProfile!.emailVerified != null) {
          if (Controller.coachProfile!.emailVerified != "1") {
            if (Controller.coachProfile!.email != null) {
              if (Controller.coachProfile!.email!.length > 0) {
                setState(() {
                  isEmail = true;
                });
                return true;
              }
            }
          }
        }
        if (Controller.coachProfile!.phoneVerified != null) {
          if (Controller.coachProfile!.phoneVerified != "1") {
            if (Controller.coachProfile!.phoneNo != null) {
              if (Controller.coachProfile!.phoneNo!.length > 0) {
                setState(() {
                  isEmail = false;
                });
                return true;
              }
            }
          }
        }
      }
    } else if (Controller.memberType == 2) {
      if (Controller.playerProfile != null) {
        if (Controller.playerProfile!.emailVerified != null) {
          if (Controller.playerProfile!.emailVerified != "1") {
            if (Controller.playerProfile!.email != null) {
              if (Controller.playerProfile!.email!.length > 0) {
                setState(() {
                  isEmail = true;
                });
                return true;
              }
            }
          }
        }
        if (Controller.playerProfile!.phoneVerified != null) {
          if (Controller.playerProfile!.phoneVerified != "1") {
            if (Controller.playerProfile!.phoneNo != null) {
              if (Controller.playerProfile!.phoneNo!.length > 0) {
                setState(() {
                  isEmail = false;
                });
                return true;
              }
            }
          }
        }
      }
    } else if (Controller.memberType == 3) {
      if (Controller.clubProfile != null) {
        if (Controller.clubProfile!.phoneVerified != null) {
          if (Controller.clubProfile!.phoneVerified != "1") {
            if (Controller.clubProfile!.phoneNo != null) {
              if (Controller.clubProfile!.phoneNo!.length > 0) {
                setState(() {
                  isEmail = false;
                });
                return true;
              }
            }
          }
        }
      }
    }
    return false;
  }

  String getVerificationTileText() {
    if (isEmail != null) {
      if (isEmail!) {
        return "Verify your Email";
      } else {
        return "Verify your Phone Number";
      }
    } else {
      return "Verify";
    }
  }

  Widget getImage() {
    if (Controller.drawerImage != null) {
      if (Controller.drawerImage!.length > 0) {
        return Image.network(Controller.drawerImage!);
      }
    }
    return Image.asset(
      'lib/Assets/images/user.png',
      fit: BoxFit.fill,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xffF9C303),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: SizeConfig.height35,
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.height35),
                        child: CircleAvatar(
                          backgroundColor: Color(0xffF9C303),
                          radius: SizeConfig.height30,
                          child: getImage(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.height5,
                    ),
                    Text(
                      Controller.drawerName != null
                          ? Controller.drawerName!
                          : "Guest",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      Controller.drawerEmail != null
                          ? Controller.drawerEmail!
                          : "Guest Email",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              verificationTileCondition()
                  ? ListTile(
                      title: Text(
                        getVerificationTileText(),
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () {
                        if (isEmail != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VerificationAssociatedScreen(isEmail!),
                            ),
                          );
                        } else {
                          Controller.showSnackBar(
                              "Unable to process request at the moment",
                              context);
                        }
                      },
                    )
                  : SizedBox.shrink(),
              Controller.memberType == 2
                  ? ListTile(
                      title: Text("Trainings"),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayerMyTrainingsScreen(),
                          ),
                        );
                      },
                    )
                  : SizedBox.shrink(),
              Controller.memberType == 1
                  ? ListTile(
                      title: Text("Sessions"),
                      minVerticalPadding: 0,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoachMySessionsScreen(),
                          ),
                        );
                      },
                    )
                  : SizedBox.shrink(),
              Controller.memberType != 3
                  ? ListTile(
                      title: Text("Events"),
                      minVerticalPadding: 0,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventsScreen(),
                          ),
                        );
                      },
                    )
                  : SizedBox.shrink(),
              Controller.memberType == 1
                  ? ListTile(
                      title: Text("Training Plans"),
                      minVerticalPadding: 0,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrainingPlanScreen(),
                          ),
                        );
                      },
                    )
                  : SizedBox.shrink(),
              ListTile(
                title: Text("Training Programs"),
                minVerticalPadding: 0,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrainingProgramScreen(),
                    ),
                  );
                },
              ),
              Controller.memberType != 3
                  ? ListTile(
                      title: Text("Videos"),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Controller.memberType == 2
                                ? PlayerVideoCategoriesScreen()
                                : CoachVideoCategoriesScreen(),
                          ),
                        );
                      },
                    )
                  : SizedBox.shrink(),
              Controller.memberType != 3
                  ? ListTile(
                      title: Text("Payments"),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Controller.memberType == 1
                                ? CoachAllPaymentsScreen()
                                : PlayerAllPaymentsScreen(),
                          ),
                        );
                      },
                    )
                  : SizedBox.shrink(),
              ListTile(
                title: Text("Change Password"),
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ChangePasswordDialog();
                    },
                  );
                },
              ),
              ListTile(
                title: Text("Logout"),
                onTap: () async {
                  bool result = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return LogoutDialog();
                    },
                  );
                  if (result == true) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInScreen(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: Container(
              color: Color(0xffF9C303),
              padding: EdgeInsets.all(SizeConfig.width5),
              child: Center(
                child: Text(
                  "Zaphry App by DevDart",
                  style: TextStyle(
                      fontSize: SizeConfig.width12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
