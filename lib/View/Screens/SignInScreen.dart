import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Screens/DashboardScreen.dart';
import 'package:zaphry/View/Screens/JoinAsScreen.dart';
import 'package:zaphry/View/Screens/RegistrationFormClubScreen.dart';
import 'package:zaphry/View/Screens/RegistrationFormScreen.dart';
import 'package:zaphry/View/Widgets/ForgetPasswordDialog.dart';

import 'DashboardClubScreen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool signWithPhone = false;
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  String? phoneCode;

  bool hidePassword = true;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> getCountryCodes() async {
    if (Controller.countryNamesAndCodes.length <= 0) {
      EasyLoading.show();
      String response = await APICalls.getCountries();
      EasyLoading.dismiss();
      if (response != "Successfully returned details") {
        Controller.showSnackBar(response, context);
        return false;
      }
    }
    return true;
  }

  void moveOn() async {
    if (Controller.signinResponse != null) {
      if (Controller.signinResponse!.profileStatus == "0") {
        bool check = await Controller.callProfileDropdownsAndCountryCodesAPI();
        if (check) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Controller.signinResponse!.userType == "3"
                  ? RegistrationFormClubScreen()
                  : RegistrationFormScreen(callProfileAPI: true),
            ),
          );
        } else {
          Controller.showSnackBar(
              "Unable to process request at the time", context);
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Controller.signinResponse!.userType == "3"
                ? DashboardClubScreen()
                : DashboardScreen(),
          ),
        );
      }
    }
  }

  void callSignInPhone() async {
    String phone = phoneEditingController.value.text.trim();
    String password = passwordEditingController.value.text.trim();
    if (phoneCode != null) {
      if (phone.length > 0) {
        if (password.length > 0) {
          if (password.length > 5) {
            EasyLoading.show();
            String response =
                await APICalls.signInPhone(phoneCode! + phone, password);
            EasyLoading.dismiss();
            Controller.showSnackBar(response, context);
            if (response == "Authenticated Successfully") {
              Controller.saveSignUsingType(false);
              moveOn();
            }
          } else {
            Controller.showSnackBar(
                "Passsword must be atleast 6 characters", context);
          }
        } else {
          Controller.showSnackBar("Enter a password", context);
        }
      } else {
        Controller.showSnackBar("Enter a phone number", context);
      }
    } else {
      Controller.showSnackBar("Select a country code", context);
    }
  }

  void callSignInEmail() async {
    String email = emailEditingController.value.text.trim();
    String password = passwordEditingController.value.text.trim();
    if (email.length > 0) {
      if (password.length > 0) {
        if (password.length > 5) {
          EasyLoading.show();
          String response = await APICalls.signInEmail(email, password);
          EasyLoading.dismiss();
          Controller.showSnackBar(response, context);
          if (response == "Authenticated Successfully") {
            Controller.saveSignUsingType(true);
            moveOn();
          }
        } else {
          Controller.showSnackBar(
              "Passsword must be atleast 6 characters", context);
        }
      } else {
        Controller.showSnackBar("Enter a password", context);
      }
    } else {
      Controller.showSnackBar("Enter an email address", context);
    }
  }

  Widget getDropdownSearchCode() {
    return DropdownSearch<String>(
      mode: Mode.BOTTOM_SHEET,
      showSelectedItem: true,
      showSearchBox: true,
      items: Controller.countryCodes,
      hint: "Code",
      selectedItem: phoneCode,
      onChanged: (value) {
        if (Controller.countryCodes.contains(value!.split(" ")[0])) {
          phoneCode = value.split(" ")[0];
        }
      },

      popupItemBuilder: (context, item, isSelected) {
        return Material(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.width10, vertical: SizeConfig.height15),
            child: Text(
              item,
              style: TextStyle(
                color: isSelected ? Color(0xffF9C303) : Colors.black,
                fontSize: SizeConfig.height15,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getPhoneRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: SizeConfig.width120,
          height: SizeConfig.height50,
          child: getDropdownSearchCode(),
        ),
        SizedBox(
          width: SizeConfig.width5,
        ),
        Expanded(
          child: TextFormField(
            controller: phoneEditingController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            ],
            decoration: InputDecoration(
              hintText: "Enter Phone No",
              labelText: "Phone No",
              labelStyle: TextStyle(
                color: Colors.white,
                fontFamily: "DM Sans M",
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Controller.onWillPop(context),
      child: Scaffold(
        body: SingleChildScrollView(
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
                      topRight: Radius.circular(SizeConfig.height25),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.height50,
                      ),
                      Text(
                        "WELCOME BACK",
                        style: TextStyle(
                          fontFamily: 'Bebas Neue',
                          fontSize: SizeConfig.height33,
                        ),
                      ),
                      Text(
                        "Sign In to Continue",
                        style: TextStyle(
                          fontFamily: 'DM Sans M',
                          color: Colors.white,
                          fontSize: SizeConfig.height17,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.height15,
                      ),

                      //Text fields

                      Padding(
                        padding: EdgeInsets.fromLTRB(SizeConfig.width40,
                            SizeConfig.height20, SizeConfig.width40, 0),
                        child: signWithPhone
                            ? getPhoneRow()
                            : TextFormField(
                                controller: emailEditingController,
                                keyboardType: signWithPhone
                                    ? TextInputType.phone
                                    : TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    hintText: "Enter Email Address",
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "DM Sans M")),
                                validator: (String? value) {
                                  if (value != null && value.isEmpty) {
                                    return "Please Enter your Email";
                                  }
                                  return null;
                                },
                              ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.width40),
                        child: TextFormField(
                          controller: passwordEditingController,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          obscureText: hidePassword,
                          decoration: InputDecoration(
                            hintText: "Enter Password",
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: "DM Sans M",
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(hidePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                            ),
                          ),
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return "Please Enter your Password";
                            } else if (value != null && value.length < 8) {
                              return "Password lenght should be atleast 8";
                            }
                            return null;
                          },
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(
                            left: SizeConfig.width40, top: SizeConfig.height12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                fontSize: SizeConfig.height12,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: () async {
                              if (signWithPhone) {
                                if (phoneCode != null) {
                                  if (phoneEditingController.value.text
                                          .trim()
                                          .length >
                                      0) {
                                    EasyLoading.show();
                                    String response =
                                        await APICalls.forgotPasswordPhone(
                                            phoneCode! +
                                                phoneEditingController
                                                    .value.text
                                                    .trim());
                                    EasyLoading.dismiss();
                                    if (response ==
                                        "A Code has been sent to your phone No.") {
                                      await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ForgetPasswordDialog(
                                              phoneCode! +
                                                  phoneEditingController
                                                      .value.text
                                                      .trim());
                                        },
                                      );
                                    } else {
                                      Controller.showSnackBar(
                                          response, context);
                                    }
                                  } else {
                                    Controller.showSnackBar(
                                        "Please enter a phone number", context);
                                  }
                                } else {
                                  Controller.showSnackBar(
                                      "Please select a country code", context);
                                }
                              } else {
                                if (emailEditingController.value.text
                                        .trim()
                                        .length >
                                    0) {
                                  EasyLoading.show();
                                  String response =
                                      await APICalls.forgotPasswordEmail(
                                          emailEditingController.value.text
                                              .trim());
                                  EasyLoading.dismiss();
                                  Controller.showSnackBar(response, context);
                                } else {
                                  Controller.showSnackBar(
                                      "Please enter an email address", context);
                                }
                              }
                            },
                          ),
                        ),
                      ),

                      SizedBox(
                        height: SizeConfig.height25,
                      ),

                      //signed in button

                      Container(
                        width: SizeConfig.width220,
                        child: ElevatedButton(
                          onPressed: () {
                            if (signWithPhone) {
                              callSignInPhone();
                            } else {
                              callSignInEmail();
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
                            "Sign In",
                            style: TextStyle(
                              fontFamily: 'DM Sans B',
                              color: Colors.white,
                              fontSize: SizeConfig.height15,
                            ),
                          ),
                        ),
                      ),

                      //Already have an account?SignUp

                      /*InkWell(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Sign In with email',
                              style: TextStyle(
                                fontFamily: 'DM Sans R',
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.mail),
                          ],
                        ),
                        onTap: () {},
                      ),*/

                      SizedBox(
                        height: SizeConfig.height10,
                      ),

                      Container(
                        width: SizeConfig.width220,
                        child: OutlinedButton(
                          onPressed: () async {
                            if (!signWithPhone) {
                              bool check = await getCountryCodes();
                              if (check) {
                                setState(() {
                                  signWithPhone = !signWithPhone;
                                });
                              }
                            } else {
                              setState(() {
                                signWithPhone = !signWithPhone;
                              });
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.height30),
                            ),
                            side: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          child: Text(
                            signWithPhone
                                ? 'Sign In with Email'
                                : 'Sign In with Phone',
                            style: TextStyle(
                              fontFamily: 'DM Sans B',
                              color: Colors.black,
                              fontSize: SizeConfig.height12,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: SizeConfig.height10,
                      ),

                      //Already have an account?SignUp

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontFamily: 'DM Sans R',
                              color: Colors.black,
                              fontSize: SizeConfig.height14,
                            ),
                          ),
                          InkWell(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontFamily: 'DM Sans B',
                                color: Colors.black,
                                fontSize: SizeConfig.height14,
                              ),
                            ),
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JoinAsScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
