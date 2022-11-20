import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Widgets/LogoutDialog.dart';
import 'package:zaphry/View/Widgets/mydrawer.dart';
import 'package:zaphry/View/Widgets/navbarwhite.dart';

import 'RegistrationFormClubScreen.dart';
import 'SignInScreen.dart';

class ClubProfileScreen extends StatefulWidget {
  const ClubProfileScreen({Key? key}) : super(key: key);

  @override
  _ClubProfileScreenState createState() => _ClubProfileScreenState();
}

class _ClubProfileScreenState extends State<ClubProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool profileReceived = false;
  String loading = "Loading...";

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  Future<void> getProfile() async {
    if (Controller.clubProfile != null) {
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

  String getContact() {
    if (profileReceived) {
      String? phoneNo = Controller.clubProfile!.phoneNo;
      if (phoneNo != null) {
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
      String? email = Controller.clubProfile!.email;
      if (email != null) {
        return email;
      } else {
        return "Not provided";
      }
    } else {
      return loading;
    }
  }

  Widget getImage() {
    if (profileReceived) {
      if (Controller.clubProfile!.image != null) {
        return Image.network(Controller.clubProfile!.image!);
      }
    }
    return Image.asset("lib/Assets/images/user.png");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF9C303),
        key: _scaffoldKey,
        endDrawer: Mydrawer(),
        bottomNavigationBar: MynavWhite(
          colorType: 0,
          currIndex: 1,
          scaffoldKey: _scaffoldKey,
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xffF9C303),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.width30),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: SizeConfig.height10,
                          top: SizeConfig.height40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "lib/Assets/images/zaphry.png",
                            width: SizeConfig.width30,
                          ),
                          Text(
                            "CLUB PROFLE",
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
                    SizedBox(
                      height: SizeConfig.height10,
                    ),
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
                          profileReceived
                              ? Controller.clubProfile!.firstName
                              : loading,
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
                            "Registration No",
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.height12),
                          ),
                          Text(
                            profileReceived
                                ? Controller.clubProfile!.registrationNo
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
                            "Contact Person",
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.height12),
                          ),
                          Text(
                            profileReceived
                                ? Controller.clubProfile!.contactPerson
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
                            "Phone No",
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
                            "Address",
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.height12),
                          ),
                          Text(
                            profileReceived
                                ? Controller.clubProfile!.address
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
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RegistrationFormClubScreen(
                                  clubProfile: Controller.clubProfile,
                                ),
                              ),
                            );
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
                      height: SizeConfig.height20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
