class SearchSession {
  String id = "";
  String date = "";
  String startTime = "";
  String sessionType = "";
  String coachID = "";
  String coach = "";
  String rating = "";
  String price = "";
  bool booked = false;

  SearchSession.fromMapObject(Map<String, dynamic> map) {
    this.id = map["session_id"];
    this.date = map["date"];
    this.startTime = map["start_time"];
    this.sessionType = map["session_type"];
    this.coachID = map["coach_id"];
    this.coach = map["coach"];
    this.rating = map["rating"];
    this.price = map["price"];
  }
}
