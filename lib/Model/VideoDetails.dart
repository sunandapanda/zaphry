class VideoDetails {
  String id = "";
  String category = "";
  String userID = "";
  String title = "";
  String author = "";
  String description = "";
  String duration = "";
  String dateOfCreation = "";
  String videoLink = "";
  List<dynamic> imagesLinks = [];
  String status = ""; // 1 active, 2 inactive
  String recipients = ""; // 1 both, 2 player, 3 coach

  VideoDetails.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.category = map['category'];
    this.userID = map['user_id'];
    this.title = map['title'];
    this.author = map['author'];
    this.description = map['description'];
    this.duration = map['duration'];
    this.dateOfCreation = map['date_of_creation'];
    this.videoLink = map['video'];
    this.imagesLinks = map['images'];
    this.status = map['status'];
    this.recipients = map['recipients'];
  }
}
