class EventInterested {
  String eventID = "";
  String eventUserID = "";
  String eventUserName = "";
  String title = "";
  String interestedID = "";
  String ageGroup = "";
  String startDateTime = "";
  String banner = "";

  EventInterested.fromMapObject(Map<String, dynamic> map) {
    this.eventID = map['event_id'];
    this.eventUserID = map['event_user_id'];
    this.eventUserName = map['event_user_name'];
    this.title = map['event_title'];
    this.interestedID = map['interest_id'];
    this.ageGroup = map['age_group'];
    this.startDateTime = map['start_date_time'];
    this.banner = map['banner'];
  }
}
