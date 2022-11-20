import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Widgets/LogoutDialog.dart';
import 'package:zaphry/View/Widgets/mydrawer.dart';
import 'package:zaphry/View/Widgets/navbarwhite.dart';

import 'RegistrationFormScreen.dart';
import 'SignInScreen.dart';

class PlayerProfileScreen extends StatefulWidget {
  const PlayerProfileScreen({Key? key}) : super(key: key);

  @override
  _PlayerProfileScreenState createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool profileReceived = false;
  String loading = "Loading...";

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  Future<void> getProfile() async {
    if (Controller.ageGroupTexts.length <= 1) {
      await Controller.callProfileDropdownsAndCountryCodesAPI();
    }
    if (Controller.playerProfile != null) {
      setState(() {
        profileReceived = true;
      });
    } else {
      EasyLoading.show();
      String response = await APICalls.profile();
      EasyLoading.dismiss();
      if (response == "Successfully returned profile data") {
        setState(() {
          profileReceived = true;
        });
      } else {
        Controller.showSnackBar(response, context);
      }
    }
  }

  String getName() {
    if (profileReceived) {
      return Controller.playerProfile!.firstName +
          " " +
          Controller.playerProfile!.lastName;
    } else {
      return loading;
    }
  }

  String getContact() {
    if (profileReceived) {
      String? phoneNo = Controller.playerProfile!.phoneNo;
      if (phoneNo != null) {
        // this condition is added to remove '++' from numbers
        if (phoneNo[1] == "+") {
          return "+" + phoneNo.substring(2);
        }
        return phoneNo;
      } else {
        return "Not provided";
      }
    } else {
      return loading;
    }
  }

  String getEmail() {
    if (profileReceived) {
      String? email = Controller.playerProfile!.email;
      if (email != null) {
        return email;
      } else {
        return "Not provided";
      }
    } else {
      return loading;
    }
  }

  void goToRegistration() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RegistrationFormScreen(playerProfile: Controller.playerProfile),
      ),
    );
  }

  String getAgeGroupFromID(String ageID) {
    return Controller
        .ageGroupTexts[Controller.ageGroupValues.indexOf(int.parse(ageID))];
  }

  Widget getImage() {
    if (profileReceived) {
      if (Controller.playerProfile!.image != null) {
        return Image.network(Controller.playerProfile!.image!);
      }
    }
    return Image.asset("lib/Assets/images/user.png");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Controller.onWillPop(context),
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: Mydrawer(),
        backgroundColor: Color(0xffF9C303),
        bottomNavigationBar: MynavWhite(
          colorType: 0,
          currIndex: 1,
          scaffoldKey: _scaffoldKey,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(SizeConfig.width25,
                  SizeConfig.height40, SizeConfig.width25, SizeConfig.height10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "lib/Assets/images/zaphry.png",
                    width: SizeConfig.width30,
                  ),
                  Text(
                    "Player",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontFamily: 'Bebas Neue',
                      letterSpacing: 2,
                      fontSize: SizeConfig.height33,
                      color: Colors.black,
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
                  )
                ],
              ),
            ),
            Container(
              height: SizeConfig.height500,
              decoration: BoxDecoration(
                color: Color(0xffF9C303),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.width30),
                child: ListView(
                  children: [
                    CircleAvatar(
                      radius: SizeConfig.height75,
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.height75),
                        child: CircleAvatar(
                          backgroundColor: Color(0xffF9C303),
                          radius: SizeConfig.height70,
                          child: getImage(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.height40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontSize: SizeConfig.height12),
                        ),
                        Text(
                          getName(),
                          style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.none,
                              fontSize: SizeConfig.height12),
                        ),
                      ],
                    ),
                    Container(
                        child: Divider(
                      color: Colors.black,
                    )),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: SizeConfig.height5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "DoB",
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.height12),
                          ),
                          Text(
                            profileReceived
                                ? Controller.playerProfile!.dob
                                : loading,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.height12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        child: Divider(
                      color: Colors.black,
                    )),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: SizeConfig.height5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Gender",
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.height12),
                          ),
                          Text(
                            profileReceived
                                ? Controller.playerProfile!.gender
                                : loading,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.height12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        child: Divider(
                      color: Colors.black,
                    )),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: SizeConfig.height5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Contact",
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.height12),
                          ),
                          Text(
                            getContact(),
                            style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.height12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        child: Divider(
                      color: Colors.black,
                    )),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: SizeConfig.height5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Email",
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.height12),
                          ),
                          Text(
                            getEmail(),
                            style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.height12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        child: Divider(
                      color: Colors.black,
                    )),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: SizeConfig.height5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Zipcode",
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.height12),
                          ),
                          Text(
                            profileReceived
                                ? Controller.playerProfile!.zipCode
                                : loading,
                            style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.height12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        child: Divider(
                      color: Colors.black,
                    )),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: SizeConfig.height5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Experience",
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.height12),
                          ),
                          Text(
                            profileReceived
                                ? Controller.playerProfile!.experience
                                : loading,
                            style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.height12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        child: Divider(
                      color: Colors.black,
                    )),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: SizeConfig.height5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Age Group",
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.height12),
                          ),
                          Text(
                            profileReceived
                                ? getAgeGroupFromID(
                                    Controller.playerProfile!.ageGroups)
                                : loading,
                            style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.height12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        child: Divider(
                      color: Colors.black,
                    )),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: SizeConfig.height5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Organization",
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.height12),
                          ),
                          Text(
                            profileReceived
                                ? Controller.playerProfile!.organization
                                : loading,
                            style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.height12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        child: Divider(
                      color: Colors.black,
                    )),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: SizeConfig.height5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "About Me      ",
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.height12),
                          ),
                          Text(
                            profileReceived
                                ? Controller.playerProfile!.aboutMe
                                : loading,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.height12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        child: Divider(
                      color: Colors.black,
                    )),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: SizeConfig.height5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Club",
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.height12),
                          ),
                          Text(
                            profileReceived
                                ? (Controller.playerProfile!.club != null
                                    ? Controller.playerProfile!.club!
                                    : "Not Associated")
                                : loading,
                            style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.height12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        child: Divider(
                      color: Colors.black,
                    )),
                    SizedBox(
                      height: SizeConfig.height20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize:
                                Size(SizeConfig.width18, SizeConfig.height28),
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.width28),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.height5),
                            ),
                            primary: Colors.black,
                          ),
                          onPressed: () async {
                            if (Controller.timeZoneValues.length > 1) {
                              goToRegistration();
                            } else {
                              bool check = await Controller
                                  .callProfileDropdownsAndCountryCodesAPI();
                              if (check) {
                                goToRegistration();
                              } else {
                                Controller.showSnackBar(
                                    "Unable to process request at the time",
                                    context);
                              }
                            }
                          },
                          child: Text(
                            'Edit',
                            style: TextStyle(
                                fontSize: SizeConfig.height15,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.width15,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.black,
                                    width: SizeConfig.width2,
                                    style: BorderStyle.solid),
                                borderRadius:
                                    BorderRadius.circular(SizeConfig.height5)),
                            primary: Colors.transparent,
                            elevation: 0,
                            minimumSize:
                                Size(SizeConfig.width18, SizeConfig.height28),
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.width20),
                          ),
                          onPressed: () async {
                            bool result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return LogoutDialog();
                              },
                            );
                            if (result == true) {
                              /*String response = await APICalls.logout();
                                    print(response);*/
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              );
                            }
                          },
                          child: Text(
                            'Log out',
                            style: TextStyle(
                                fontSize: SizeConfig.height15,
                                color: Colors.black),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.height50,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
