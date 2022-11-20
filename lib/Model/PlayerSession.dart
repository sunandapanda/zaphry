class PlayerSession {
  String id = "";
  String date = "";
  String startTime = "";
  String sessionType = "";
  String coach = "";
  String status = "";
  String price = "";
  String action = "";
  var haveLink;
  String link = "";
  String timeToGo = "";
  var coachFeedback;
  var playerFeedback;

  PlayerSession.fromMapObject(Map<String, dynamic> map) {
    this.id = map['session_id'];
    this.date = map['date'];
    this.startTime = map['start_time'];
    this.sessionType = map['session_type'];
    this.coach = map['coach'];
    this.status = map['status'];
    if (map['price'] != null) {
      this.price = map['price'];
    } else if (map['session_price'] != null) {
      this.price = map['session_price'];
    }
    if (map['action'] != null) {
      this.action = map['action'];
    }
    if (map['have_link'] != null) {
      this.haveLink = map['have_link'];
    }
    if (map['link'] != null) {
      this.link = map['link'];
    }
    if (map['time_to_go'] != null) {
      this.timeToGo = map['time_to_go'];
    }
    if (map['coach_feedback'] != null) {
      this.coachFeedback = map['coach_feedback'];
    }
    if (map['player_feedback'] != null) {
      this.playerFeedback = map['player_feedback'];
    }
  }
}
