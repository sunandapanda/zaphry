class TrainingProgram {
  String programID = "";
  String userID = "";
  String userName = "";
  int variants = 0;
  String title = "";
  String pdfFile = "";

  TrainingProgram.fromMapObject(Map<String, dynamic> map) {
    this.programID = map['program_id'];
    this.userID = map['user_id'];
    this.userName = map['user_name'];
    this.variants = int.parse(map['variants']);
    this.title = map['title'];
    this.pdfFile = map['pdf_file'];
  }
}
