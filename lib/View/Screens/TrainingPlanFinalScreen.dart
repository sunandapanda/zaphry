import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:reorderables/reorderables.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/Model/TrainingPlanVideo.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Screens/TrainingPlanScreen.dart';

class TrainingPlanFinalScreen extends StatefulWidget {
  const TrainingPlanFinalScreen({Key? key}) : super(key: key);

  @override
  _TrainingPlanFinalScreenState createState() =>
      _TrainingPlanFinalScreenState();
}

class _TrainingPlanFinalScreenState extends State<TrainingPlanFinalScreen> {
  TextEditingController planTitleController = TextEditingController();

  String getIDs() {
    String str = "";
    for (int c = 0; c < Controller.trainingPlanSelectedVideos.length; c++) {
      str += Controller.trainingPlanSelectedVideos[c].id + ",";
    }
    str = str.substring(0, str.length - 1);
    return str;
  }

  void saveOnPressed() async {
    if (planTitleController.value.text.length > 0) {
      if (Controller.trainingPlanSelectedVideos.length > 0) {
        EasyLoading.show();
        String videoIDs = getIDs();
        String response = await APICalls.createTrainingPlan(
            planTitleController.value.text.trim(), videoIDs);
        Controller.showSnackBar(response, context);
        if (response == "Successfully Created Training Plan") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TrainingPlanScreen(),
            ),
          );
        }
        EasyLoading.dismiss();
      } else {
        Controller.showSnackBar("Please select at least one video", context);
      }
    } else {
      Controller.showSnackBar("Please enter a title for plan", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            SizeConfig.width15, SizeConfig.height55, SizeConfig.width15, 0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.width20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(),
                  Text(
                    "Video Selection",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.height20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.transparent,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.height10),
            TextField(
              controller: planTitleController,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(SizeConfig.height10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(SizeConfig.height10),
                ),
                labelStyle: TextStyle(color: Theme.of(context).disabledColor),
                hintText: "Enter Plan Title",
                labelText: "Plan Title",
              ),
            ),
            SizedBox(height: SizeConfig.height10),
            Container(
              height: SizeConfig.height400,
              child: ReorderableColumn(
                children: Controller.trainingPlanSelectedVideos.map((video) {
                  return Container(
                    key: Key(video.id),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black),
                      ),
                    ),
                    child: ListTile(
                      leading: Container(
                        height: SizeConfig.height40,
                        width: SizeConfig.width40,
                        child: Image.network(video.image, fit: BoxFit.cover),
                      ),
                      title: Text(video.title),
                      subtitle: Text(video.category),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(video.duration),
                          SizedBox(width: SizeConfig.width10),
                          GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffF9C303)),
                              ),
                              child: Icon(Icons.clear),
                            ),
                            onTap: () {
                              setState(() {
                                Controller.trainingPlanSelectedVideos
                                    .removeWhere(
                                        (element) => element.id == video.id);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    TrainingPlanVideo item = Controller
                        .trainingPlanSelectedVideos
                        .removeAt(oldIndex);
                    Controller.trainingPlanSelectedVideos
                        .insert(newIndex, item);
                  });
                },
              ),
            ),
            SizedBox(height: SizeConfig.height20),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: SizeConfig.width110,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Add Video",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.height25),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                    ),
                  ),
                  Container(
                    width: SizeConfig.width110,
                    child: ElevatedButton(
                      onPressed: () {
                        saveOnPressed();
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.height25),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
