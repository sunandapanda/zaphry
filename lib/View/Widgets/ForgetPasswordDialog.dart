import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';

class ForgetPasswordDialog extends StatefulWidget {
  String phone;

  ForgetPasswordDialog(this.phone);

  @override
  _ForgetPasswordDialogState createState() => _ForgetPasswordDialogState();
}

class _ForgetPasswordDialogState extends State<ForgetPasswordDialog> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  String code = "o0o";

  bool showError = false;
  String errorMessage = "Error";

  void setError(String errMsg) {
    setState(() {
      errorMessage = errMsg;
      showError = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      contentPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.width20, vertical: SizeConfig.height20),
      backgroundColor: Color(0xffF9C303),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(SizeConfig.height25))),
      title: Text("Forget Password"),
      content: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.height25),
            color: Color(0xffF9C303),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Code:"),
              ),
              SizedBox(height: SizeConfig.height10),
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
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Password:"),
              ),
              TextFormField(
                controller: newPasswordController,
                style: TextStyle(
                  color: Colors.black,
                ),
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter New Password",
                  labelText: 'New Password',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: "DM Sans M",
                  ),
                ),
              ),
              TextFormField(
                controller: confirmNewPasswordController,
                style: TextStyle(
                  color: Colors.black,
                ),
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm New Password",
                  labelText: 'Confirm New Password',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: "DM Sans M",
                  ),
                ),
              ),
              showError
                  ? SizedBox(height: SizeConfig.height10)
                  : SizedBox.shrink(),
              showError
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : SizedBox.shrink(),
              showError
                  ? SizedBox(height: SizeConfig.height10)
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            "Confirm",
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () async {
            if (code.length == 4) {
              if (newPasswordController.value.text.trim().length > 0) {
                if (newPasswordController.value.text.trim().length >= 6) {
                  if (confirmNewPasswordController.value.text.trim().length >
                      0) {
                    if (newPasswordController.value.text.trim() ==
                        confirmNewPasswordController.value.text.trim()) {
                      EasyLoading.show();
                      String response =
                          await APICalls.forgotPasswordPhoneVerify(
                              widget.phone,
                              code,
                              newPasswordController.value.text.trim(),
                              confirmNewPasswordController.value.text.trim());
                      EasyLoading.dismiss();
                      if (response == "Password Reset Successfully.") {
                        Controller.showSnackBar(response, context);
                        Navigator.of(context).pop();
                      } else {
                        setError(response);
                      }
                    } else {
                      setError("Passwords do not match");
                    }
                  } else {
                    setError("Please confirm password");
                  }
                } else {
                  setError("Password must be at least 6 characters");
                }
              } else {
                setError("Please enter a password");
              }
            } else {
              setError("Please enter the verification code");
            }
          },
        ),
      ],
    );
  }
}
