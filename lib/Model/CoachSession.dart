class CoachSession {
  String id = "";
  String date = "";
  String startTime = "";
  String sessionType = "";
  String status = "";
  String price = "";
  String action = "";
  String bookedBy = "";
  var coachFeedback;
  var playerFeedback;
  var haveLink;
  String timeToGo = "";
  String link = "";

  CoachSession.fromMapObject(Map<String, dynamic> map) {
    this.id = map['session_id'];
    this.date = map['date'];
    this.startTime = map['start_time'];
    this.sessionType = map['session_type'];
    this.status = map['status'];
    if (map['price'] != null) {
      this.price = map['price'];
    }
    if (map['action'] != null) {
      this.action = map['action'];
    }
    if (map['booked_by'] != null) {
      this.bookedBy = map['booked_by'];
    }
    if (map['coach_feedback'] != null) {
      this.coachFeedback = map['coach_feedback'];
    }
    if (map['player_feedback'] != null) {
      this.playerFeedback = map['player_feedback'];
    }
    if (map['have_link'] != null) {
      this.haveLink = map['have_link'];
    }
    if (map['time_to_go'] != null) {
      this.timeToGo = map['time_to_go'];
    }
    if (map['link'] != null) {
      this.link = map['link'];
    }
  }
}
