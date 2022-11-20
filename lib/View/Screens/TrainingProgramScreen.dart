import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Screens/PDFViewerScreen.dart';
import 'package:zaphry/View/Widgets/LoadMoreButton.dart';
import 'package:zaphry/View/Widgets/mydrawer.dart';
import 'package:zaphry/View/Widgets/navbarwhite.dart';

import 'TrainingProgramDetailsScreen.dart';

class TrainingProgramScreen extends StatefulWidget {
  const TrainingProgramScreen({Key? key}) : super(key: key);

  @override
  _TrainingProgramScreenState createState() => _TrainingProgramScreenState();
}

class _TrainingProgramScreenState extends State<TrainingProgramScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int trainingProgramsPageNo = 1;

  @override
  void initState() {
    super.initState();
    getTrainingPrograms();
  }

  void getTrainingPrograms() async {
    EasyLoading.show();
    String response = "";
    if (Controller.memberType == 3) {
      response = await APICalls.getClubTrainingPrograms(
          trainingProgramsPageNo.toString(), "10");
    } else {
      response = await APICalls.getPlayerCoachTrainingPrograms(
          trainingProgramsPageNo.toString(), "10");
    }
    EasyLoading.dismiss();
    if (response == "Successfully Retrieved Training Programs") {
      trainingProgramsPageNo += 1;
      setState(() {});
    } else {
      Controller.showSnackBar(
          "Unable to process request at the moment", context);
    }
  }

  Widget trainingProgramItem(int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.height20),
        color: Color(0xffF9C303),
      ),
      child: ListTile(
        title: Text(Controller.trainingProgramsList[index].title),
        subtitle: Text(
            "Variants: ${Controller.trainingProgramsList[index].variants}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () async {
                EasyLoading.show();
                PDFDocument doc = await PDFDocument.fromURL(
                    Controller.trainingProgramsList[index].pdfFile);
                EasyLoading.dismiss();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDFViewerScreen(doc),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.download_rounded),
              onPressed: () async {
                bool check = await Controller.downloadFile(
                    Controller.trainingProgramsList[index].pdfFile,
                    Controller.trainingProgramsList[index].title);
                if (check) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "File Downloaded",
                      style: TextStyle(color: Color(0xffF9C303)),
                    ),
                    backgroundColor: Colors.black,
                    duration: Duration(seconds: 10),
                    action: SnackBarAction(
                      label: "View",
                      textColor: Color(0xffF9C303),
                      onPressed: () async {
                        EasyLoading.show();
                        File file = File(Controller.pdfLocalPath);
                        PDFDocument doc = await PDFDocument.fromFile(file);
                        EasyLoading.dismiss();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PDFViewerScreen(doc),
                          ),
                        );
                      },
                    ),
                  ));
                } else {
                  Controller.showSnackBar("File download failed", context);
                }
              },
            ),
          ],
        ),
        onTap: () async {
          EasyLoading.show();
          String response = await APICalls.getClubTrainingProgramDetails(
              Controller.trainingProgramsList[index].programID);
          EasyLoading.dismiss();
          if (response == "Successfully Retrieved Training Program Details") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrainingProgramDetailsScreen(),
              ),
            );
          } else {
            Controller.showSnackBar(response, context);
          }
        },
      ),
    );
  }

  Widget getTrainingsListView() {
    return ListView.separated(
      itemCount: Controller.trainingProgramsList.length + 1,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: SizeConfig.height10,
        );
      },
      itemBuilder: (context, index) {
        if (Controller.trainingProgramsList.length == 0) {
          return Center(
            child: Text("No programs found"),
          );
        } else {
          if (Controller.trainingProgramsList.length == index) {
            return Align(
              child: LoadMoreButton(() => getTrainingPrograms()),
            );
          } else {
            return trainingProgramItem(index);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Controller.onWillPop(context),
      child: SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            endDrawer: Mydrawer(),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('lib/Assets/images/booktraing.png'),
                    fit: BoxFit.cover),
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            SizeConfig.width25,
                            SizeConfig.height40,
                            SizeConfig.width25,
                            SizeConfig.height30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset(
                              "lib/Assets/images/zaphry.png",
                              width: SizeConfig.width25,
                            ),
                            Text(
                              "Training Programs",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: SizeConfig.height20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              child: IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  _scaffoldKey.currentState!.openEndDrawer();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.width30),
                        height: SizeConfig.height480,
                        width: double.infinity,
                        child: getTrainingsListView(),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    left: 0,
                    bottom: 0,
                    child: MynavWhite(
                      colorType: 1,
                      currIndex: 3,
                      scaffoldKey: _scaffoldKey,
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
