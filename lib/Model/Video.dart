class Video {
  String id = "";
  String title = "";
  String categoryID = "";
  String categoryName = "";
  String status = "";
  String author = "";
  String description = "";
  String duration = "";
  String? image;
  String dateOfCreation = "";

  String? userID;
  String? userName;

  Video.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.categoryID = map['category_id'];
    this.categoryName = map['category_name'];
    this.status = map['status'];
    this.author = map['author'];
    this.description = map['description'];
    this.duration = map['duration'];
    this.image = map['image'];
    this.dateOfCreation = map['date_of_creation'];

    this.userID = map['user_id'];
    this.userName = map['user_name'];
  }
}
