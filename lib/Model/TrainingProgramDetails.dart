import 'package:zaphry/Model/TrainingProgramVariant.dart';

class TrainingProgramDetails {
  String title = "";
  int noOfVariants = 0;
  List<TrainingProgramVariant> variants = [];

  TrainingProgramDetails.fromMapObject(Map<String, dynamic> map) {
    this.title = map['title'];
    this.noOfVariants = map['no_of_variants'];
    for (int c = 0; c < noOfVariants; c++) {
      this
          .variants
          .add(TrainingProgramVariant.fromMapObject(map['variants'][c]));
    }
  }
}
