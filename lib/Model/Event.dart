class Event {

  String eventID = "";
  String eventUserID = "";
  String eventUserName = "";
  String title = "";
  String description = "";
  String banner = "";
  String ageGroup = "";
  String startDateTime = "";

  Event.fromMapObject(Map<String, dynamic> map) {
    this.eventID = map['event_id'];
    this.eventUserID = map['event_user_id'];
    this.eventUserName = map['event_user_name'];
    this.title = map['title'];
    this.description = map['description'];
    this.banner = map['banner'];
    this.ageGroup = map['age_group'];
    this.startDateTime = map['start_date_time'];
  }
}