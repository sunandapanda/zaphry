import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';

class VerificationAssociatedScreen extends StatefulWidget {
  bool isEmail;

  VerificationAssociatedScreen(this.isEmail);

  @override
  _VerificationAssociatedScreenState createState() =>
      _VerificationAssociatedScreenState();
}

class _VerificationAssociatedScreenState
    extends State<VerificationAssociatedScreen> {
  Stopwatch? stopwatch;
  Timer? timer;
  bool isTimeUp = false;
  String code = "0o0o";

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch();
    timer = new Timer.periodic(new Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
    stopwatch!.start();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  String getRemainingTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var seconds = (120 - (secs % 60)).toString().padLeft(2, '0');

    if (seconds == "0" || seconds == "00") {
      isTimeUp = true;
      stopwatch!.stop();
    }

    return "00:$seconds";
  }

  String getAssociatedPhone() {
    if (Controller.memberType == 1) {
      return Controller.coachProfile!.phoneNo!;
    } else if (Controller.memberType == 2) {
      return Controller.playerProfile!.phoneNo!;
    } else {
      return Controller.clubProfile!.phoneNo!;
    }
  }

  String getAssociatedEmail() {
    if (Controller.memberType == 1) {
      return Controller.coachProfile!.email!;
    } else {
      return Controller.playerProfile!.email!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/Assets/images/bgimg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              //container for orange rectangle
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: SizeConfig.height550,
                    decoration: BoxDecoration(
                        color: Color(0xffF9C303),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(SizeConfig.height25),
                            topRight: Radius.circular(SizeConfig.height25))),
                    child: Column(
                      children: [
                        SizedBox(
                          height: SizeConfig.height50,
                        ),
                        Text(
                          "VERIFICATION",
                          style: TextStyle(
                            fontFamily: 'Bebas Neue',
                            fontSize: SizeConfig.height33,
                          ),
                        ),
                        Center(
                          child: Text(
                            widget.isEmail
                                ? "Please enter verification code from your email"
                                : "Please enter verification code from your phone",
                            style: TextStyle(
                                fontSize: SizeConfig.height13,
                                color: Colors.white),
                          ),
                        ),

                        SizedBox(
                          height: SizeConfig.height15,
                        ),

                        Text(
                          "Code",
                          style: TextStyle(
                            fontFamily: 'Bebas Neue',
                            fontSize: SizeConfig.height33,
                          ),
                        ),

                        SizedBox(
                          height: SizeConfig.height10,
                        ),

                        Container(
                          width: SizeConfig.width130,
                          child: PinCodeTextField(
                            appContext: context,
                            length: 4,
                            obscureText: false,
                            animationType: AnimationType.fade,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              fieldHeight: SizeConfig.height30,
                              fieldWidth: SizeConfig.width30,
                              activeFillColor: Colors.black,
                              inactiveColor: Colors.black,
                              activeColor: Colors.black,
                              selectedColor: Colors.white,
                            ),
                            onChanged: (value) {
                              code = value;
                              print("pin: " + value);
                            },
                            onCompleted: (value) {
                              code = value;
                              print("PIN Completed");
                            },
                          ),
                        ),

                        SizedBox(
                          height: 15,
                        ),

                        //signed up button

                        isTimeUp
                            ? GestureDetector(
                                onTap: () async {
                                  stopwatch!.start();
                                  setState(() {
                                    isTimeUp = false;
                                  });
                                  String response = "";
                                  EasyLoading.show();
                                  if (widget.isEmail) {
                                    response = await APICalls
                                        .sendCodeAgainAssociatedEmail(
                                            getAssociatedEmail());
                                  } else {
                                    response = await APICalls
                                        .sendCodeAgainAssociatedPhone(
                                            getAssociatedPhone());
                                  }
                                  EasyLoading.dismiss();
                                  Controller.showSnackBar(response, context);
                                },
                                child: Text(
                                  "Resend Code",
                                  style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              )
                            : Text(
                                "Resend Code in: " +
                                    getRemainingTime(
                                        stopwatch!.elapsedMilliseconds),
                                style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                              ),

                        SizedBox(
                          height: SizeConfig.height15,
                        ),
                        Container(
                          width: SizeConfig.width220,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (widget.isEmail) {
                                EasyLoading.show();
                                String response =
                                    await APICalls.verifyAssociatedEmail(
                                        getAssociatedEmail(), code);
                                EasyLoading.dismiss();
                                Controller.showSnackBar(response, context);
                                if (response == "Email Verified Successfully") {
                                  Navigator.of(context).pop();
                                }
                              } else {
                                EasyLoading.show();
                                String response =
                                    await APICalls.verifyAssociatedPhone(
                                        getAssociatedPhone(), code);
                                EasyLoading.dismiss();
                                Controller.showSnackBar(response, context);
                                if (response ==
                                    "Phone No. Verified Successfully") {
                                  Navigator.of(context).pop();
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: new RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(SizeConfig.height30),
                              ),
                              primary: Colors.black,
                            ),
                            child: Text(
                              "Verify",
                              style: TextStyle(
                                fontFamily: 'DM Sans B',
                                color: Colors.white,
                                fontSize: SizeConfig.height15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            child: BackButton(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
