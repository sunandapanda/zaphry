import 'package:zaphry/Controller/Controller.dart';

class SignInResponse {
  String authKey = "";
  String uniqueID = "";
  String userType = "";
  String? email;
  String? phoneNo;
  String userID = "";
  String profileStatus = "";
  String? firstName;
  String? lastName;
  String? imagePath;

  SignInResponse.fromMapObject(Map<String, dynamic> map) {
    this.authKey = map['auth_key'];
    this.uniqueID = map['unique_id'];
    this.userType = map['user_type'];
    if (map['email'] != null) {
      this.email = map['email'];
    }
    if (map['phone_no'] != null) {
      this.phoneNo = map['phone_no'];
    }
    this.userID = map['user_id'];
    this.profileStatus = map['profile_status'];
    this.firstName = map['first_name'];
    this.lastName = map['last_name'];
    this.imagePath = map['coachpic'];

    if (imagePath != null) {
      if (imagePath!.endsWith("images/")) {
        imagePath = null;
      }
    }

    Controller.saveProfileStatus(this.profileStatus);
    Controller.saveDrawerData(firstName, email, imagePath);
  }
}
