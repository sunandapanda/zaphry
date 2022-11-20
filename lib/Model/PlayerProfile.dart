class PlayerProfile {
  String profileStatus = "";
  String firstName = "";
  String lastName = "";
  String dob = "";
  String aboutMe = "";
  String zipCode = "";
  String gender = "";
  String timeZoneID = "";
  String timeZone = "";
  String? image;
  String? email;
  String? phoneNo;
  String? emailVerified;
  String? phoneVerified;
  String? phonePrefix;

  String? club;

  String organization = "";
  String ageGroups = "";
  String experience = "";

  PlayerProfile.fromMapObject(Map<String, dynamic> map) {
    this.profileStatus = map['profile_status'];
    this.firstName = map['f_name'];
    this.lastName = map['l_name'];
    this.dob = map['dob'];
    this.aboutMe = map['about_me'];
    this.zipCode = map['zip_code'];
    this.gender = map['gender'];
    this.timeZoneID = map['timezone_id'];
    this.timeZone = map['time_zone'];
    this.image = map['image'];
    this.email = map['email'];
    this.phoneNo = map['phone_no'];
    this.emailVerified = map['email_verified'];
    this.phoneVerified = map['phone_no_verified'];
    this.phonePrefix = map['phone_prefix'];
    this.club = map['club'];
  }

  void addProfessionalProfile(Map<String, dynamic> map) {
    this.organization = map['org'];
    this.ageGroups = map['agegroups'];
    this.experience = map['experience'];
  }
}
