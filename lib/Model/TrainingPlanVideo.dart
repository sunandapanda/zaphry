class TrainingPlanVideo {
  String id = "";
  String category = "";
  String userID = "";
  String title = "";
  String dateOfCreation = "";
  String image = "";
  String duration = "";

  TrainingPlanVideo.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.category = map['category'];
    this.userID = map['user_id'];
    this.title = map['title'];
    this.dateOfCreation = map['date_of_creation'];
    this.image = map['image'];
    this.duration = map['duration'];
  }
}
