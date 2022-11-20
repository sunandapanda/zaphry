class ClubProfile {
  String profileStatus = "";
  String firstName = "";
  String lastName = "";
  String registrationNo = "";
  String contactPerson = "";
  String address = "";
  String? image;
  String? email;
  String? phoneNo;
  String? emailVerified;
  String? phoneVerified;
  String? phonePrefix;

  ClubProfile.fromMapObject(Map<String, dynamic> map) {
    this.profileStatus = map['profile_status'];
    this.firstName = map['f_name'];
    this.lastName = map['l_name'];
    this.registrationNo = map['reg_no'];
    this.contactPerson = map['contact_person'];
    this.address = map['address'];
    this.image = map['image'];
    this.email = map['email'];
    this.phoneNo = map['phone_no'];
    this.emailVerified = map['email_verified'];
    this.phoneVerified = map['phone_no_verified'];
    this.phonePrefix = map['phone_prefix'];
  }
}