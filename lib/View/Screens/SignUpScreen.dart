import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Screens/SignInScreen.dart';
import 'package:zaphry/View/Screens/VerificationScreen.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen();

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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

  String getMemberTypeText() {
    if (Controller.memberType == 1) {
      return "Joining as Coach";
    } else if (Controller.memberType == 2) {
      return "Joining as Player";
    } else {
      return "Joining as Club";
    }
  }

  void callSignUpPhone() async {
    String phone = phoneEditingController.value.text.trim();
    String password = passwordEditingController.value.text.trim();
    if (phoneCode != null) {
      if (phone.length > 0) {
        if (password.length > 0) {
          if (password.length > 5) {
            EasyLoading.show();
            String response =
                await APICalls.signUpPhone(phoneCode! + phone, password);
            EasyLoading.dismiss();
            Controller.showSnackBar(response, context);
            if (response == "Registered Successfully" ||
                response == "Coach Registered Successfully.") {
              Controller.saveSignUsingType(false);
              Controller.phone = phoneCode! + phone;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => VerificationScreen(),
                ),
              );
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

  void callSignUpEmail() async {
    String email = emailEditingController.value.text.trim();
    String password = passwordEditingController.value.text.trim();
    if (email.length > 0) {
      if (password.length > 0) {
        if (password.length > 5) {
          EasyLoading.show();
          String response = await APICalls.signUpEmail(email, password);
          EasyLoading.dismiss();
          Controller.showSnackBar(response, context);
          if (response == "Registered Successfully") {
            Controller.saveSignUsingType(true);
            Controller.email = email;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => VerificationScreen(),
              ),
            );
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
    return Scaffold(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: SizeConfig.height15),
                  child: BackButton(
                    color: Colors.white,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
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
                      "LET’S GET STARTED",
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

                    //Join as Coach Button

                    Text(
                      getMemberTypeText(),
                      style: TextStyle(
                        fontFamily: 'Bebas Neue',
                        fontSize: SizeConfig.height25,
                      ),
                    ),

                    SizedBox(
                      height: SizeConfig.height10,
                    ),

                    //Text fields

                    Padding(
                      padding: EdgeInsets.fromLTRB(SizeConfig.width40,
                          SizeConfig.height20, SizeConfig.width40, 0),
                      child: signWithPhone
                          ? getPhoneRow()
                          : TextFormField(
                              controller: emailEditingController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: "Enter Email Address",
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "DM Sans M"),
                              ),
                              validator: (String? value) {
                                if (value != null && value.isEmpty) {
                                  return "Please Enter your Email";
                                }
                                return null;
                              },
                            ),
                    ),

                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: SizeConfig.width40),
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

                    SizedBox(
                      height: SizeConfig.height25,
                    ),

                    //signed up button

                    Container(
                      width: SizeConfig.width220,
                      child: ElevatedButton(
                        onPressed: () {
                          if (signWithPhone) {
                            callSignUpPhone();
                          } else {
                            callSignUpEmail();
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
                          "Sign Up",
                          style: TextStyle(
                            fontFamily: 'DM Sans B',
                            color: Colors.white,
                            fontSize: SizeConfig.height15,
                          ),
                        ),
                      ),
                    ),
                    Controller.memberType != 3
                        ? SizedBox(
                            height: SizeConfig.height10,
                          )
                        : SizedBox.shrink(),

                    Controller.memberType != 3
                        ? Container(
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
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.height30),
                                ),
                                side: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              child: Text(
                                signWithPhone
                                    ? 'Sign Up with Email'
                                    : 'Sign Up with Phone',
                                style: TextStyle(
                                  fontFamily: 'DM Sans B',
                                  color: Colors.black,
                                  fontSize: SizeConfig.height12,
                                ),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),

                    SizedBox(
                      height: SizeConfig.height10,
                    ),

                    //Already have an account?SignUp

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            fontFamily: 'DM Sans R',
                            color: Colors.black,
                            fontSize: SizeConfig.height14,
                          ),
                        ),
                        InkWell(
                          child: Text(
                            'Sign In',
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
            ],
          ),
        ),
      ),
    );
  }
}
