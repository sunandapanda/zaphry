class TrainingPlan {
  String id = "";
  String planName = "";
  String status = "";
  String pdfFile = "";

  TrainingPlan.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.planName = map['plan_name'];
    this.status = map['status'];
    this.pdfFile = map['pdf_file'];
  }
}
