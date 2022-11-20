class RequestedProfile {
  String firstName = "";
  String lastName = "";
  String userType = "";
  String aboutMe = "";
  String zipCode = "";
  String gender = "";
  String image = "";
  String? email;
  String? phoneNo;
  String? dob;
  String? meetingLink;

  RequestedProfile.fromMapObject(Map<String, dynamic> map) {
    this.firstName = map['f_name'];
    this.lastName = map['l_name'];
    this.userType = map['user_type'];
    this.aboutMe = map['about_me'];
    this.zipCode = map['zip_code'];
    this.gender = map['gender'];
    this.image = map['image'];
    this.email = map['email'];
    this.phoneNo = map['phone_no'];
    this.dob = map['dob'];
    this.meetingLink = map['meetinglink'];
  }
}
