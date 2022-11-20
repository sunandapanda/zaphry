class TrainingProgramVariant {
  String id = "";
  String title = "";
  String description = "";
  String duration = "";
  String startDateTime = "";
  String? attachment;

  TrainingProgramVariant.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.description = map['description'];
    this.duration = map['duration'];
    this.startDateTime = map['start_date_time'];
    if (map['attachment'] != null) {
      this.attachment = map['attachment'];
    }
  }
}
