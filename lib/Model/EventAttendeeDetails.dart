class EventAttendeeDetails {
  String eventUserID = "";
  String eventUserName = "";
  String eventUserType = "";
  String eventUserZIPCode = "";
  String? eventUserImage;

  EventAttendeeDetails.fromMapObject(Map<String, dynamic> map) {
    this.eventUserID = map['event_user_id'];
    this.eventUserName = map['event_user_name'];
    this.eventUserType = map['event_user_type'];
    this.eventUserZIPCode = map['event_user_zip_code'];
    this.eventUserImage = map['event_user_image'];
  }
}
