import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/Model/CoachProfile.dart';
import 'package:zaphry/Model/PlayerProfile.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Screens/CoachProfileScreen.dart';
import 'package:zaphry/View/Screens/PlayerProfileScreen.dart';
import 'package:zaphry/View/Widgets/InfoDialog.dart';
import 'package:zaphry/View/Widgets/mydrawer.dart';
import 'package:zaphry/View/Widgets/navbarwhite.dart';

class RegistrationFormScreen extends StatefulWidget {
  PlayerProfile? playerProfile;
  CoachProfile? coachProfile;
  bool? callProfileAPI;

  RegistrationFormScreen(
      {this.playerProfile, this.coachProfile, this.callProfileAPI});

  @override
  _RegistrationFormScreenState createState() => _RegistrationFormScreenState();
}

class _RegistrationFormScreenState extends State<RegistrationFormScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool maleCheckbox = false;
  bool femaleCheckbox = false;
  bool otherCheckbox = false;
  String dropdownTimeZone = 'Select Time Zone';
  String dropdownAgeGroup = 'Select Age Group';
  String dropdownExperience = 'Select Experience';
  String dropdownClubAssociation = 'Select Club';
  bool imageAvailable = false;
  bool imageLocalOverride = false;
  String imagePath = "";
  String dob = "Date of Birth";
  String? phoneCode = "+1";
  bool sendImageToAPI = false;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController publicURLController = TextEditingController();
  TextEditingController meetingLinkController = TextEditingController();
  TextEditingController clubOrgController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();

  String oldEmail = "";
  String oldPhone = "";

  @override
  void initState() {
    super.initState();

    getPreviousProfile();
  }

  Future<void> getPreviousProfile() async {
    // only to get url on first time sign up
    if (Controller.memberType == 1) {
      if (widget.callProfileAPI != null) {
        if (widget.callProfileAPI!) {
          await callProfileAPI();
        }
      } else if (Controller.profileStatus != "1") {
        await callProfileAPI();
      }
    }
    // previous profile
    if (widget.playerProfile != null || widget.coachProfile != null) {
      if (Controller.memberType == 1) {
        getPreviousCoachProfile();
      } else {
        getPreviousPlayerProfile();
      }
    }
  }

  Future<void> callProfileAPI() async {
    EasyLoading.show();
    String response = await APICalls.profile(forURL: true);
    EasyLoading.dismiss();
    if (response == "Successfully returned profile data") {
      if (Controller.publicURL != null) {
        setState(() {
          publicURLController.text = Controller.publicURL!;
        });
      }
    } else {
      Controller.showSnackBar("Unable to fetch Public URL", context);
    }
  }

  void getPreviousCoachProfile() {
    setState(() {
      imageAvailable = true;
      imagePath = widget.coachProfile!.image!;
      firstNameController.text = widget.coachProfile!.firstName;
      lastNameController.text = widget.coachProfile!.lastName;
      if (widget.coachProfile!.gender == "Male") {
        maleCheckbox = true;
      } else if (widget.coachProfile!.gender == "Female") {
        femaleCheckbox = true;
      } else {
        otherCheckbox = true;
      }
      if (Controller.signUsingEmail) {
        if (widget.coachProfile!.phoneNo != null) {
          phoneCode = widget.coachProfile!.phonePrefix;
          phoneNoController.text =
              widget.coachProfile!.phoneNo!.substring(phoneCode!.length);
          oldPhone = widget.coachProfile!.phoneNo!.substring(phoneCode!.length);
        } else {
          phoneNoController.text = "";
        }
      } else {
        if (widget.coachProfile!.email != null) {
          emailController.text = widget.coachProfile!.email!;
          oldEmail = widget.coachProfile!.email!;
        } else {
          emailController.text = "";
        }
      }
      zipCodeController.text = widget.coachProfile!.zipCode;
      dropdownTimeZone = getTimeZoneNameFromID(widget.coachProfile!.timeZoneID);
      clubOrgController.text = widget.coachProfile!.organization;
      dropdownExperience = getExperienceFromID(widget.coachProfile!.experience);
      dropdownAgeGroup = getAgeGroupFromID(widget.coachProfile!.ageGroups);
      aboutMeController.text = widget.coachProfile!.aboutMe;
      publicURLController.text = widget.coachProfile!.publicURL;
      meetingLinkController.text = widget.coachProfile!.meetingLink;
      if (widget.coachProfile!.club != null) {
        if (Controller.clubNames.contains(widget.coachProfile!.club!)) {
          dropdownClubAssociation = widget.coachProfile!.club!;
        }
      }
    });
  }

  void getPreviousPlayerProfile() {
    setState(() {
      imageAvailable = true;
      imagePath = widget.playerProfile!.image!;
      firstNameController.text = widget.playerProfile!.firstName;
      lastNameController.text = widget.playerProfile!.lastName;
      if (widget.playerProfile!.gender == "Male") {
        maleCheckbox = true;
      } else if (widget.playerProfile!.gender == "Female") {
        femaleCheckbox = true;
      } else {
        otherCheckbox = true;
      }
      if (Controller.signUsingEmail) {
        if (widget.playerProfile!.phoneNo != null) {
          phoneCode = widget.playerProfile!.phonePrefix;
          phoneNoController.text =
              widget.playerProfile!.phoneNo!.substring(phoneCode!.length);
          oldPhone =
              widget.playerProfile!.phoneNo!.substring(phoneCode!.length);
        } else {
          phoneNoController.text = "";
        }
      } else {
        if (widget.playerProfile!.email != null) {
          emailController.text = widget.playerProfile!.email!;
          oldEmail = widget.playerProfile!.email!;
        } else {
          emailController.text = "";
        }
      }
      dob = widget.playerProfile!.dob;
      zipCodeController.text = widget.playerProfile!.zipCode;
      dropdownTimeZone =
          getTimeZoneNameFromID(widget.playerProfile!.timeZoneID);
      clubOrgController.text = widget.playerProfile!.organization;
      dropdownExperience =
          getExperienceFromID(widget.playerProfile!.experience);
      dropdownAgeGroup = getAgeGroupFromID(widget.playerProfile!.ageGroups);
      aboutMeController.text = widget.playerProfile!.aboutMe;
      if (widget.playerProfile!.club != null) {
        if (Controller.clubNames.contains(widget.playerProfile!.club!)) {
          dropdownClubAssociation = widget.playerProfile!.club!;
        }
      }
    });
  }

  bool validateImage() {
    if (widget.coachProfile != null || widget.playerProfile != null) {
      if (imageLocalOverride) {
        sendImageToAPI = true;
      }
      return true;
    } else {
      if (imageAvailable) {
        sendImageToAPI = true;
        return true;
      }
    }
    //Controller.showSnackBar("Please upload an image", context);
    return true; //false;
  }

  bool validateEmailPhone() {
    if (Controller.signUsingEmail) {
      if (phoneNoController.value.text.trim().length > 0) {
        return validateImage();
      } else {
        Controller.showSnackBar("Please enter phone number", context);
        return false;
      }
    } else {
      if (emailController.value.text.trim().length > 0) {
        return validateImage();
      } else {
        Controller.showSnackBar("Please enter email", context);
        return false;
      }
    }
  }

  bool validateCoachProfile() {
    if (firstNameController.value.text.trim().length > 0) {
      if (lastNameController.value.text.trim().length > 0) {
        if (zipCodeController.value.text.trim().length > 0) {
          if (zipCodeController.value.text.trim().length == 5 ||
              zipCodeController.value.text.trim().length == 6) {
            if (dropdownExperience != "Select Experience") {
              if (dropdownTimeZone != "Select Time Zone") {
                if (dropdownAgeGroup != "Select Age Group") {
                  if (maleCheckbox || femaleCheckbox || otherCheckbox) {
                    if (publicURLController.value.text.trim().length > 0) {
                      if (meetingLinkController.value.text.trim().length > 0) {
                        if (phoneCode != null) {
                          return validateEmailPhone();
                        } else {
                          Controller.showSnackBar(
                              "Please select a country code", context);
                          return false;
                        }
                      } else {
                        Controller.showSnackBar(
                            "Please enter a meeting link", context);
                        return false;
                      }
                    } else {
                      Controller.showSnackBar(
                          "Please enter your public url", context);
                      return false;
                    }
                  } else {
                    Controller.showSnackBar("Please select a gender", context);
                    return false;
                  }
                } else {
                  Controller.showSnackBar(
                      "Please select an age group", context);
                  return false;
                }
              } else {
                Controller.showSnackBar("Please select a time zone", context);
                return false;
              }
            } else {
              Controller.showSnackBar("Please enter experience", context);
              return false;
            }
          } else {
            Controller.showSnackBar(
                "Zip code must be at least 5 characters", context);
            return false;
          }
        } else {
          Controller.showSnackBar("Please enter zip code", context);
          return false;
        }
      } else {
        Controller.showSnackBar("Please enter last name", context);
        return false;
      }
    } else {
      Controller.showSnackBar("Please enter first name", context);
      return false;
    }
  }

  bool validatePlayerProfile() {
    if (firstNameController.value.text.trim().length > 0) {
      if (lastNameController.value.text.trim().length > 0) {
        if (zipCodeController.value.text.trim().length > 0) {
          if (zipCodeController.value.text.trim().length == 5 ||
              zipCodeController.value.text.trim().length == 6) {
            if (dropdownExperience != "Select Experience") {
              if (dropdownTimeZone != "Select Time Zone") {
                if (dropdownAgeGroup != "Select Age Group") {
                  if (maleCheckbox || femaleCheckbox || otherCheckbox) {
                    if (phoneCode != null) {
                      return validateEmailPhone();
                    } else {
                      Controller.showSnackBar(
                          "Please select a country code", context);
                      return false;
                    }
                  } else {
                    Controller.showSnackBar("Please select a gender", context);
                    return false;
                  }
                } else {
                  Controller.showSnackBar(
                      "Please select an age group", context);
                  return false;
                }
              } else {
                Controller.showSnackBar("Please select a time zone", context);
                return false;
              }
            } else {
              Controller.showSnackBar("Please enter experience", context);
              return false;
            }
          } else {
            Controller.showSnackBar(
                "Zip code must be at least 5 characters", context);
            return false;
          }
        } else {
          Controller.showSnackBar("Please enter zip code", context);
          return false;
        }
      } else {
        Controller.showSnackBar("Please enter last name", context);
        return false;
      }
    } else {
      Controller.showSnackBar("Please enter first name", context);
      return false;
    }
  }

  Image getImageToShow() {
    if ((widget.playerProfile != null || widget.coachProfile != null) &&
        !imageLocalOverride) {
      return Image.network(imagePath);
    } else {
      if (imageAvailable) {
        return Image.file(File(imagePath));
      } else {
        return Image.asset('lib/Assets/images/cameraIcon.png');
      }
    }
  }

  String getGenderFromCheckbox() {
    if (maleCheckbox) {
      return "Male";
    } else if (femaleCheckbox) {
      return "Female";
    } else {
      return "Other";
    }
  }

  String getTimeZoneNameFromID(String timeZone) {
    return Controller.timeZoneValues[Controller.timeZoneKeys.indexOf(timeZone)];
  }

  String getTimezoneIDFromName() {
    return Controller
        .timeZoneKeys[Controller.timeZoneValues.indexOf(dropdownTimeZone)];
  }

  String getAgeGroupFromID(String ageID) {
    return Controller
        .ageGroupTexts[Controller.ageGroupValues.indexOf(int.parse(ageID))];
  }

  String getAgeGroupID() {
    return Controller
        .ageGroupValues[Controller.ageGroupTexts.indexOf(dropdownAgeGroup)]
        .toString();
  }

  String getExperienceFromID(String expID) {
    return Controller
        .experienceTexts[Controller.experienceValues.indexOf(int.parse(expID))];
  }

  String getExperienceID() {
    return Controller.experienceValues[
            Controller.experienceTexts.indexOf(dropdownExperience)]
        .toString();
  }

  Future<void> showFinalDialog(String text) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return InfoDialog(text);
      },
    );
  }

  String getFinalDOB() {
    if (dob == "Date of Birth") {
      return "";
    }
    return dob;
  }

  void saveOnPressed() async {
    bool profileUpdated = false;
    bool clubAssociated = false;
    bool phoneAssociated = false;
    bool emailAssociated = false;
    if (Controller.memberType == 1) {
      bool check = validateCoachProfile();
      if (check) {
        EasyLoading.show();
        String response = await APICalls.editProfile(
            picture: imagePath,
            sendImage: sendImageToAPI,
            firstName: firstNameController.value.text.trim(),
            lastName: lastNameController.value.text.trim(),
            gender: getGenderFromCheckbox(),
            zipCode: zipCodeController.value.text.trim(),
            timeZone: getTimezoneIDFromName(),
            org: clubOrgController.value.text.trim(),
            experience: getExperienceID(),
            ageGroup: getAgeGroupID(),
            aboutMe: aboutMeController.value.text.trim(),
            publicURL: publicURLController.value.text.trim(),
            meetingLink: meetingLinkController.value.text.trim());
        print("---profile---");
        if (response == "Successfully Updated Profile Data") {
          Controller.saveProfileStatus("1");
          // if profile is updated
          profileUpdated = true;
        } else {
          Controller.showSnackBar(
              "Unable to update profile at the moment", context);
        }
        // associate club
        int idIndex = Controller.clubNames.indexOf(dropdownClubAssociation);
        if (idIndex > 0) {
          // if club exists
          String response2 =
              await APICalls.clubAssociation(Controller.clubIDs[idIndex]);
          if (response2 ==
              "Association requested successfully. Wait for club approval.") {
            // if club association is requested
            clubAssociated = true;
          } else {
            Controller.showSnackBar(response2, context);
          }
        } else {
          Controller.showSnackBar(
              "Unable to request club association at the moment", context);
        }
        print("---club---");
        // associate phone or email
        if (Controller.signUsingEmail) {
          if (Controller.coachProfile != null &&
              Controller.coachProfile!.phoneVerified != null &&
              Controller.coachProfile!.phoneVerified == "1") {
            // do nothing here
          } else {
            if (oldPhone != phoneCode! + phoneNoController.value.text.trim()) {
              String responsePhone = await APICalls.editAssociatedPhone(
                  phoneCode! + phoneNoController.value.text.trim(), phoneCode!);
              if (responsePhone ==
                  "Code is sent to provided phone no. with verification code.") {
                phoneAssociated = true;
              } else {
                Controller.showSnackBar("Unable to add phone number", context);
              }
            }
          }
        } else {
          if (Controller.coachProfile!.emailVerified != null &&
              Controller.coachProfile!.emailVerified == "1") {
            // do nothing here
          } else {
            if (oldEmail != emailController.value.text.trim()) {
              String responseEmail = await APICalls.editAssociatedEmail(
                  emailController.value.text.trim());
              if (responseEmail ==
                  "Email is sent to provided email address with verification code.") {
                emailAssociated = true;
              } else {
                Controller.showSnackBar("Unable to add email", context);
              }
            }
          }
        }
        print("---phone or email---");
        EasyLoading.dismiss();
      }
    } else if (Controller.memberType == 2) {
      bool check = validatePlayerProfile();
      if (check) {
        EasyLoading.show();
        // Update Profile
        String response = await APICalls.editProfile(
            picture: imagePath,
            sendImage: sendImageToAPI,
            firstName: firstNameController.value.text.trim(),
            lastName: lastNameController.value.text.trim(),
            gender: getGenderFromCheckbox(),
            dob: getFinalDOB(),
            zipCode: zipCodeController.value.text.trim(),
            timeZone: getTimezoneIDFromName(),
            org: clubOrgController.value.text.trim(),
            experience: getExperienceID(),
            ageGroup: getAgeGroupID(),
            aboutMe: aboutMeController.value.text.trim());
        if (response == "Successfully Updated Profile Data") {
          Controller.saveProfileStatus("1");
          profileUpdated = true;
        } else {
          Controller.showSnackBar(
              "Unable to update profile at the moment", context);
        }
        // associate club
        int idIndex = Controller.clubNames.indexOf(dropdownClubAssociation);
        if (idIndex >= 0) {
          // if club exists
          String response2 =
              await APICalls.clubAssociation(Controller.clubIDs[idIndex]);
          print("response2: " + response2);
          if (response2 ==
              "Association requested successfully. Wait for club approval.") {
            clubAssociated = true;
          } else {
            Controller.showSnackBar(response2, context);
          }
        } else {
          Controller.showSnackBar(
              "Unable to request club association at the moment", context);
        }
        // associate phone or email
        if (Controller.signUsingEmail) {
          if (Controller.playerProfile != null &&
              Controller.playerProfile!.phoneVerified != null &&
              Controller.playerProfile!.phoneVerified == "1") {
            // do nothing here
          } else {
            if (oldPhone != phoneCode! + phoneNoController.value.text.trim()) {
              String responsePhone = await APICalls.editAssociatedPhone(
                  phoneCode! + phoneNoController.value.text.trim(), phoneCode!);
              if (responsePhone ==
                  "Code is sent to provided phone no. with verification code.") {
                phoneAssociated = true;
              } else {
                Controller.showSnackBar("Unable to add phone number", context);
              }
            }
          }
        } else {
          if (Controller.playerProfile!.emailVerified != null &&
              Controller.playerProfile!.emailVerified == "1") {
            // do nothing here
          } else {
            if (oldEmail != emailController.value.text.trim()) {
              String responseEmail = await APICalls.editAssociatedEmail(
                  emailController.value.text.trim());
              if (responseEmail ==
                  "Email is sent to provided email address with verification code.") {
                emailAssociated = true;
              } else {
                Controller.showSnackBar("Unable to add email", context);
              }
            }
          }
        }
        EasyLoading.dismiss();
      }
    }
    // after all api calls
    if (profileUpdated) {
      await showFinalDialog("Profile has been updated");
    }
    if (clubAssociated) {
      await showFinalDialog(
          "You request for joining the club has been forwarded. Waiting for approval by the club.");
    }
    if (phoneAssociated) {
      await showFinalDialog(
          "A verification code has been sent to the provided phone number");
    }
    if (emailAssociated) {
      await showFinalDialog(
          "A verification code has been sent to the provided email address");
    }
    if (profileUpdated && Controller.memberType == 1) {
      if (Controller.coachProfile != null) {
        Controller.coachProfile!.firstName =
            firstNameController.value.text.trim();
        Controller.coachProfile!.lastName =
            lastNameController.value.text.trim();
        Controller.coachProfile!.gender = getGenderFromCheckbox();
        Controller.coachProfile!.zipCode = zipCodeController.value.text.trim();
        Controller.coachProfile!.timeZone = dropdownTimeZone;
        Controller.coachProfile!.organization =
            clubOrgController.value.text.trim();
        Controller.coachProfile!.experience = getExperienceID();
        Controller.coachProfile!.ageGroups = getAgeGroupID();
        Controller.coachProfile!.aboutMe = aboutMeController.value.text.trim();
        Controller.coachProfile!.publicURL =
            publicURLController.value.text.trim();
        Controller.coachProfile!.meetingLink =
            meetingLinkController.value.text.trim();
        if (phoneAssociated) {
          Controller.coachProfile!.phoneNo =
              phoneCode! + phoneNoController.value.text.trim();
        }
        if (emailAssociated) {
          Controller.coachProfile!.email = emailController.value.text.trim();
        }
        setState(() {});
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Controller.memberType == 1
              ? CoachProfileScreen()
              : PlayerProfileScreen(),
        ),
      );
    } else if (profileUpdated && Controller.memberType == 2) {
      if (Controller.playerProfile != null) {
        Controller.playerProfile!.firstName =
            firstNameController.value.text.trim();
        Controller.playerProfile!.lastName =
            lastNameController.value.text.trim();
        Controller.playerProfile!.gender = getGenderFromCheckbox();
        Controller.playerProfile!.dob = dob;
        Controller.playerProfile!.zipCode = zipCodeController.value.text.trim();
        Controller.playerProfile!.timeZone = dropdownTimeZone;
        Controller.playerProfile!.organization =
            clubOrgController.value.text.trim();
        Controller.playerProfile!.experience = getExperienceID();
        Controller.playerProfile!.ageGroups = getAgeGroupID();
        Controller.playerProfile!.aboutMe = aboutMeController.value.text.trim();
        if (phoneAssociated) {
          Controller.playerProfile!.phoneNo =
              phoneCode! + phoneNoController.value.text.trim();
        }
        if (emailAssociated) {
          Controller.playerProfile!.email = emailController.value.text.trim();
        }
        setState(() {});
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Controller.memberType == 1
              ? CoachProfileScreen()
              : PlayerProfileScreen(),
        ),
      );
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
                  color: Colors.black,
                )),
          ),
        )
      ],
    );
  }

  Widget getPhoneTextField() {
    if (widget.coachProfile != null) {
      if (widget.coachProfile!.phoneVerified! == "1") {
        return IgnorePointer(child: getInsidePhone());
      } else {
        return getInsidePhone();
      }
    } else if (widget.playerProfile != null) {
      if (widget.playerProfile!.phoneVerified! == "1") {
        return IgnorePointer(child: getInsidePhone());
      } else {
        return getInsidePhone();
      }
    } else {
      return getInsidePhone();
    }
  }

  Widget getInsideEmail() {
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
          hintText: "Enter Email",
          labelText: "Email",
          labelStyle: TextStyle(
            color: Colors.black,
          )),
    );
  }

  Widget getEmailTextField() {
    if (widget.coachProfile != null) {
      if (widget.coachProfile!.emailVerified! == "1") {
        return IgnorePointer(child: getInsideEmail());
      } else {
        return getInsideEmail();
      }
    } else if (widget.playerProfile != null) {
      if (widget.playerProfile!.emailVerified! == "1") {
        return IgnorePointer(child: getInsideEmail());
      } else {
        return getInsideEmail();
      }
    } else {
      return getInsideEmail();
    }
  }

  Widget getInsidePublicURL() {
    return TextFormField(
      controller: publicURLController,
      decoration: InputDecoration(
        hintText: "Enter Public URL",
        labelText: "Public URL *",
        labelStyle: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget getPublicURLTextField() {
    if (Controller.memberType == 1) {
      if (widget.coachProfile != null) {
        if (widget.coachProfile!.urlStatus == "1") {
          return IgnorePointer(child: getInsidePublicURL());
        }
      }
    }
    return getInsidePublicURL();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Controller.onWillPop(context),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
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
                        child: Text(
                          "Personal Info",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: SizeConfig.height18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.height15,
                      ),
                      TextFormField(
                        controller: firstNameController,
                        maxLength: 25,
                        decoration: InputDecoration(
                          hintText: "Enter First Name",
                          labelText: "First Name *",
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          counterText: "",
                        ),
                      ),
                      TextFormField(
                        controller: lastNameController,
                        maxLength: 25,
                        decoration: InputDecoration(
                          hintText: "Enter Last Name",
                          labelText: "Last Name *",
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          counterText: "",
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Gender *",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: SizeConfig.width15,
                            ),
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Checkbox(
                              activeColor: Color(0xffF9C303),
                              value: maleCheckbox,
                              onChanged: (value) {
                                setState(() {
                                  maleCheckbox = !maleCheckbox;
                                  femaleCheckbox = false;
                                  otherCheckbox = false;
                                });
                              },
                            ),
                          ),
                          Text(
                            "Male",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.width12,
                            ),
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Checkbox(
                              activeColor: Color(0xffF9C303),
                              value: femaleCheckbox,
                              onChanged: (value) {
                                setState(() {
                                  femaleCheckbox = !femaleCheckbox;
                                  maleCheckbox = false;
                                  otherCheckbox = false;
                                });
                              },
                            ),
                          ),
                          Text(
                            "Female",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.width12,
                            ),
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Checkbox(
                              activeColor: Color(0xffF9C303),
                              value: otherCheckbox,
                              onChanged: (value) {
                                setState(() {
                                  otherCheckbox = !otherCheckbox;
                                  maleCheckbox = false;
                                  femaleCheckbox = false;
                                });
                              },
                            ),
                          ),
                          Text(
                            "Other",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.width12,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: SizeConfig.height10,
                        child: Divider(
                          thickness: 0.7,
                          color: Colors.black,
                        ),
                      ),
                      Controller.signUsingEmail
                          ? getPhoneTextField()
                          : getEmailTextField(),
                      Controller.memberType == 2
                          ? SizedBox(height: SizeConfig.height5)
                          : SizedBox.shrink(),
                      Controller.memberType == 2
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Date of Birth"),
                            )
                          : SizedBox.shrink(),
                      Controller.memberType == 2
                          ? GestureDetector(
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                    hintText: "Enter Date of Birth",
                                    labelText: dob,
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    )),
                              ),
                              onTap: () {
                                DatePicker.showDatePicker(
                                  context,
                                  showTitleActions: true,
                                  currentTime: DateTime.now(),
                                  onChanged: (date) {},
                                  onConfirm: (date) {
                                    setState(() {
                                      if (date.isAfter(DateTime.now())) {
                                        Controller.showSnackBar(
                                            "DoB cannot be in the future",
                                            context);
                                      } else {
                                        dob = date.toString().split(" ")[0];
                                      }
                                    });
                                  },
                                );
                              },
                            )
                          : SizedBox.shrink(),
                      TextFormField(
                        controller: zipCodeController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                          FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                        ],
                        decoration: InputDecoration(
                          hintText: "Enter ZIP Code",
                          labelText: "ZIP Code *",
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.height10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Time Zone *"),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: dropdownTimeZone,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          iconSize: SizeConfig.height24,
                          elevation: 16,
                          dropdownColor: Colors.white,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.height15,
                          ),
                          underline: Container(
                            height: SizeConfig.height1,
                            color: Colors.black,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownTimeZone = newValue!;
                            });
                          },
                          items: Controller.timeZoneValues
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      Controller.memberType == 1
                          ? getPublicURLTextField()
                          : SizedBox.shrink(),
                      Controller.memberType == 1
                          ? TextFormField(
                              controller: meetingLinkController,
                              decoration: InputDecoration(
                                hintText: "Enter Meeting Link",
                                labelText: "Meeting Link *",
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      SizedBox(
                        height: SizeConfig.height15,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          Controller.memberType == 1
                              ? "Coaching Experience"
                              : "Player Experience",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: SizeConfig.height18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.height15,
                      ),
                      TextFormField(
                        controller: clubOrgController,
                        decoration: InputDecoration(
                            hintText: "Enter Club/Orginization",
                            labelText: "Club/Orginization",
                            labelStyle: TextStyle(
                              color: Colors.black,
                            )),
                      ),
                      SizedBox(
                        height: SizeConfig.height10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Experience *"),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: dropdownExperience,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          iconSize: SizeConfig.height24,
                          elevation: 16,
                          dropdownColor: Colors.white,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.height15,
                          ),
                          underline: Container(
                            height: SizeConfig.height1,
                            color: Colors.black,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownExperience = newValue!;
                            });
                          },
                          items: Controller.experienceTexts
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.height10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Age Group *"),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: dropdownAgeGroup,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          iconSize: SizeConfig.height24,
                          elevation: 16,
                          dropdownColor: Colors.white,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.height15,
                          ),
                          underline: Container(
                            height: SizeConfig.height1,
                            color: Colors.black,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownAgeGroup = newValue!;
                            });
                          },
                          items: Controller.ageGroupTexts
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.height15,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Club Association",
                          style: TextStyle(
                              fontSize: SizeConfig.height18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.height10,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: dropdownClubAssociation,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          iconSize: SizeConfig.height24,
                          elevation: 16,
                          dropdownColor: Colors.white,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.height15,
                          ),
                          underline: Container(
                            height: SizeConfig.height1,
                            color: Colors.black,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownClubAssociation = newValue!;
                            });
                          },
                          items: Controller.clubNames
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.height15,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "About Me",
                          style: TextStyle(
                              fontSize: SizeConfig.height18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.height15,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.width25, vertical: 0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.height8)),
                          child: TextField(
                            controller: aboutMeController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: "Enter your details",
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.height25,
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
                                    builder: (context) =>
                                        Controller.memberType == 1
                                            ? CoachProfileScreen()
                                            : PlayerProfileScreen(),
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
          ),
        ),
      ),
    );
  }
}
