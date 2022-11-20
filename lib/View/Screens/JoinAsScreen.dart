import 'package:flutter/material.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';

import 'SignInScreen.dart';
import 'SignUpScreen.dart';

class JoinAsScreen extends StatefulWidget {
  const JoinAsScreen({Key? key}) : super(key: key);

  @override
  _JoinAsScreenState createState() => _JoinAsScreenState();
}

class _JoinAsScreenState extends State<JoinAsScreen> {
  void goToSignUp(int memberType) {
    Controller.memberType = memberType;
    Controller.saveMemberType(memberType.toString());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Controller.onWillPop(context),
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/Assets/images/bgjoinas.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.width30),
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.height80,
                  ),
                  Center(
                      child: Image.asset(
                    'lib/Assets/images/zaphry2.png',
                    fit: BoxFit.scaleDown,
                    width: SizeConfig.width160,
                  )),
                  SizedBox(
                    height: SizeConfig.height45,
                  ),
                  Text(
                    "SELECT TO CONTINUE",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.height30,
                        color: Colors.white,
                        fontFamily: 'Bebas Neue',
                        letterSpacing: 2),
                  ),
                  Text(
                    "I am ____",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.height25,
                        color: Colors.white,
                        letterSpacing: 2),
                  ),
                  SizedBox(
                    height: SizeConfig.height45,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          goToSignUp(2);
                        },
                        child: Text(
                          "Player",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.height20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.height10),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            Color(0xffF9C303),
                          ),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(
                                vertical: SizeConfig.height30,
                                horizontal: SizeConfig.width30),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          goToSignUp(1);
                        },
                        child: Text(
                          "Coach",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.height20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.height10),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            Color(0xffF9C303),
                          ),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(
                                vertical: SizeConfig.height30,
                                horizontal: SizeConfig.width30),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.height40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          goToSignUp(3);
                        },
                        child: Text(
                          " Club ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.height20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.height10),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            Color(0xffF9C303),
                          ),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(
                                vertical: SizeConfig.height30,
                                horizontal: SizeConfig.width30),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          //TODO: goToSignUp(0);
                        },
                        child: Text(
                          " More ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.height20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.height10),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            Color(0xffF9C303),
                          ),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(
                                vertical: SizeConfig.height30,
                                horizontal: SizeConfig.width30),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.height40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          fontFamily: 'DM Sans R',
                          color: Colors.white,
                          fontSize: SizeConfig.height14,
                        ),
                      ),
                      InkWell(
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontFamily: 'DM Sans B',
                            color: Color(0xffF9C303),
                            fontSize: SizeConfig.height14,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
