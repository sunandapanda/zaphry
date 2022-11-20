class ClubEventDetails {
  String eventUserID = "";
  String eventUserName = "";
  String title = "";
  String description = "";
  String banner = "";
  String ageGroup = "";
  String startDateTime = "";
  String? video;
  String inquiryStatus = "";
  List<dynamic>? attachments;

  ClubEventDetails.fromMapObject(Map<String, dynamic> map) {
    this.eventUserID = map['event_user_id'];
    this.eventUserName = map['event_user_name'];
    this.title = map['title'];
    this.description = map['description'];
    this.banner = map['banner'];
    this.ageGroup = map['age_group'];
    this.startDateTime = map['start_date_time'];
    if (map['video'] != null) {
      this.video = map['video'];
    }
    this.inquiryStatus = map['inquiry_status'];
    if (map['attachments'].length > 0) {
      this.attachments = map['attachments'].values.toList();
    }
  }
}
