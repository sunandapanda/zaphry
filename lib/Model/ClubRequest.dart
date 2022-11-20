class ClubRequest {
  String userID = "";
  String userName = "";
  String userType = "";
  String? email;
  String? phoneNo;

  ClubRequest.fromMapObject(Map<String, dynamic> map) {
    this.userID = map['user_id'];
    this.userName = map['user_name'];
    this.userType = map['user_type'];
    if (map['email'] != null) {
      this.email = map['email'];
    }
    if (map['phone_no'] != null) {
      this.phoneNo = map['phone_no'];
    }
  }
}
