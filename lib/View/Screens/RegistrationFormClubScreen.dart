import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/Model/ClubProfile.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Screens/ClubProfileScreen.dart';
import 'package:zaphry/View/Widgets/mydrawer.dart';
import 'package:zaphry/View/Widgets/navbarwhite.dart';

class RegistrationFormClubScreen extends StatefulWidget {
  ClubProfile? clubProfile;

  RegistrationFormClubScreen({this.clubProfile});

  @override
  _RegistrationFormClubScreenState createState() =>
      _RegistrationFormClubScreenState();
}

class _RegistrationFormClubScreenState
    extends State<RegistrationFormClubScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool imageAvailable = false;
  bool imageLocalOverride = false;
  String imagePath = "";
  bool sendImageToAPI = false;
  String? phoneCode = "+1 UNITED STATES";

  TextEditingController nameController = TextEditingController();
  TextEditingController registrationNoController = TextEditingController();
  TextEditingController contactPersonController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  String oldPhone = "";

  @override
  void initState() {
    super.initState();

    getCountryCodes();
  }

  void getCountryCodes() async {
    if (Controller.countryNamesAndCodes.length <= 0) {
      EasyLoading.show();
      String response = await APICalls.getCountries();
      EasyLoading.dismiss();
      if (response != "Successfully returned details") {
        Controller.showSnackBar(response, context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ClubProfileScreen(),
          ),
        );
      }
    }
    getPreviousProfile();
  }

  void getPreviousProfile() {
    if (widget.clubProfile != null) {
      setState(() {
        imageAvailable = true;
        imagePath = widget.clubProfile!.image!;
        nameController.text = widget.clubProfile!.firstName;
        registrationNoController.text = widget.clubProfile!.registrationNo;
        contactPersonController.text = widget.clubProfile!.contactPerson;
        phoneCode = widget.clubProfile!.phonePrefix;
        phoneNoController.text =
            widget.clubProfile!.phoneNo!.substring(phoneCode!.length);
        oldPhone = widget.clubProfile!.phoneNo!.substring(phoneCode!.length);
        addressController.text = widget.clubProfile!.address;
      });
    }
  }

  bool validateClubProfile() {
    if (nameController.value.text.trim().length > 0) {
      if (registrationNoController.value.text.trim().length > 0) {
        if (contactPersonController.value.text.trim().length > 0) {
          if (phoneCode != null) {
            if (phoneNoController.value.text.trim().length > 0) {
              if (addressController.value.text.trim().length > 0) {
                /*if (imageAvailable) {
                  return true;
                } else {
                  Controller.showSnackBar("Please add an image", context);
                }*/
                return true;
              } else {
                Controller.showSnackBar("Please enter an address", context);
              }
            } else {
              Controller.showSnackBar("Please enter a phone number", context);
            }
          } else {
            Controller.showSnackBar("Please select a country code", context);
          }
        } else {
          Controller.showSnackBar(
              "Please enter name of the contact person", context);
        }
      } else {
        Controller.showSnackBar("Please enter a registration number", context);
      }
    } else {
      Controller.showSnackBar("Please enter a club name", context);
    }
    return false;
  }

  void saveOnPressed() async {
    bool check = validateClubProfile();
    if (check) {
      bool profileUpdated = false;
      EasyLoading.show();
      String response = await APICalls.editProfile(
          picture: imagePath,
          sendImage: sendImageToAPI,
          firstName: nameController.value.text.trim(),
          lastName: " ",
          regNo: registrationNoController.value.text.trim(),
          contactPerson: contactPersonController.value.text.trim(),
          address: addressController.value.text.trim());
      if (response == "Successfully Updated Profile Data") {
        profileUpdated = true;
        Controller.saveProfileStatus("1");
        // check if phone needs to be updated
        if (Controller.clubProfile!.phoneVerified != null &&
            Controller.clubProfile!.phoneVerified == "1") {
          // do nothing here
        } else {
          if (oldPhone != phoneCode! + phoneNoController.value.text.trim()) {
            String phoneResponse = await APICalls.editAssociatedPhone(
                phoneCode! + phoneNoController.value.text.trim(), phoneCode!);
            if (phoneResponse ==
                "Code is sent to provided phone no. with verification code.") {
              Controller.showSnackBar(
                  "A verification code has been sent to the provided phone number",
                  context);
              setState(() {
                Controller.clubProfile!.phoneNo =
                    phoneCode! + phoneNoController.value.text.trim();
              });
            } else {
              Controller.showSnackBar(phoneResponse, context);
            }
          }
        }

        // Update Profile Locally
        Controller.saveDrawerData(nameController.value.text.trim(),
            Controller.clubProfile!.email, Controller.clubProfile!.image);
        setState(() {
          Controller.clubProfile!.firstName = nameController.value.text.trim();
          Controller.clubProfile!.registrationNo =
              registrationNoController.value.text.trim();
          Controller.clubProfile!.contactPerson =
              contactPersonController.value.text.trim();
          Controller.clubProfile!.address = addressController.value.text.trim();
        });
      } else {
        Controller.showSnackBar(response, context);
      }
      EasyLoading.dismiss();
      if (profileUpdated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ClubProfileScreen(),
          ),
        );
      }
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

  Widget getInsidePhone() {
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
            controller: phoneNoController,
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
                )),
          ),
        )
      ],
    );
  }

  Widget getPhoneRow() {
    if (widget.clubProfile != null) {
      if (widget.clubProfile!.phoneVerified! == "1") {
        return IgnorePointer(child: getInsidePhone());
      } else {
        return getInsidePhone();
      }
    } else {
      return getInsidePhone();
    }
  }

  Image getImageToShow() {
    if ((widget.clubProfile != null) && !imageLocalOverride) {
      return Image.network(imagePath);
    } else {
      if (imageAvailable) {
        return Image.file(File(imagePath));
      } else {
        return Image.asset('lib/Assets/images/cameraIcon.png');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Controller.onWillPop(context),
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            key: _scaffoldKey,
            endDrawer: Mydrawer(),
            backgroundColor: Color(0xffF9C303),
            //  bottomNavigationBar: Mynav(),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(SizeConfig.width25, 0,
                        SizeConfig.width25, SizeConfig.height40),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              SizeConfig.width25,
                              SizeConfig.height20,
                              SizeConfig.width25,
                              SizeConfig.height15),
                          child: GestureDetector(
                            onTap: () async {
                              final ImagePicker _picker = ImagePicker();
                              final XFile? image = await _picker.pickImage(
                                  source: ImageSource.gallery);
                              if (image != null) {
                                setState(() {
                                  imageAvailable = true;
                                  imageLocalOverride = true;
                                  sendImageToAPI = true;
                                  imagePath = image.path;
                                });
                              }
                            },
                            child: CircleAvatar(
                              radius: SizeConfig.height45,
                              backgroundColor: Colors.white,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(SizeConfig.height45),
                                child: CircleAvatar(
                                  backgroundColor: Color(0xffF9C303),
                                  radius: SizeConfig.height40,
                                  child: getImageToShow(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("About Club",
                              style: TextStyle(
                                  fontSize: SizeConfig.height18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        TextFormField(
                          controller: nameController,
                          maxLength: 40,
                          decoration: InputDecoration(
                            hintText: "Enter Club Name",
                            labelText: "Name",
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            counterText: "",
                          ),
                        ),
                        TextFormField(
                          controller: registrationNoController,
                          decoration: InputDecoration(
                              hintText: "Enter Registration No",
                              labelText: "Registration No",
                              labelStyle: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                        TextFormField(
                          controller: contactPersonController,
                          decoration: InputDecoration(
                              hintText: "Enter Contact Person's Name",
                              labelText: "Contact Person",
                              labelStyle: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                        getPhoneRow(),
                        TextFormField(
                          controller: addressController,
                          decoration: InputDecoration(
                              hintText: "Enter Address",
                              labelText: "Address",
                              labelStyle: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                        SizedBox(
                          height: SizeConfig.height15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: SizeConfig.width110,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ClubProfileScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.height25),
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black),
                                ),
                              ),
                            ),
                            Container(
                              width: SizeConfig.width110,
                              child: ElevatedButton(
                                onPressed: () {
                                  saveOnPressed();
                                },
                                child: Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.height25),
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.height300,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: MynavWhite(
                    colorType: 0,
                    currIndex: 1,
                    scaffoldKey: _scaffoldKey,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
