class ClubEvent {
  String id = "";
  String title = "";
  String ageGroup = "";
  String startDateTime = "";
  String status = "";
  String inquiryStatus = "";
  String description = "";
  int attendees = 0;
  int attendeesDetails = 0;
  String banner = "";

  ClubEvent.fromMapObject(Map<String, dynamic> map) {
    this.id = map['event_id'];
    this.title = map['title'];
    this.ageGroup = map['age_group'];
    this.startDateTime = map['start_date_time'];
    this.status = map['status'];
    this.inquiryStatus = map['inquiry_status'];
    this.description = map['description'];
    this.attendees = map['attendees'];
    this.attendeesDetails = map['attendees_details'];
    this.banner = map['banner'];
  }
}
