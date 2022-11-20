import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';
import 'package:zaphry/View/Screens/PDFViewerScreen.dart';
import 'package:zaphry/View/Screens/TrainingPlanVideosSelectionScreen.dart';
import 'package:zaphry/View/Widgets/DeleteDialog.dart';
import 'package:zaphry/View/Widgets/LoadMoreButton.dart';
import 'package:zaphry/View/Widgets/mydrawer.dart';
import 'package:zaphry/View/Widgets/navbarwhite.dart';

class TrainingPlanScreen extends StatefulWidget {
  const TrainingPlanScreen({Key? key}) : super(key: key);

  @override
  _TrainingPlanScreenState createState() => _TrainingPlanScreenState();
}

class _TrainingPlanScreenState extends State<TrainingPlanScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int trainingPlansPageNo = 1;

  @override
  void initState() {
    super.initState();
    getTrainingPlans();
  }

  void getTrainingPlans() async {
    EasyLoading.show();
    String response =
        await APICalls.getTrainingPlans(trainingPlansPageNo.toString(), "10");
    EasyLoading.dismiss();
    if (response == "Successfully Retrieved Training Plans") {
      trainingPlansPageNo += 1;
      setState(() {});
    } else {
      Controller.showSnackBar(
          "Unable to process request at the moment", context);
    }
  }

  Widget trainingPlanItem(int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.height20),
        color: Color(0xffF9C303),
      ),
      child: ListTile(
        title: Text(Controller.trainingPlans[index].planName),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () async {
                EasyLoading.show();
                PDFDocument doc = await PDFDocument.fromURL(
                    Controller.trainingPlans[index].pdfFile);
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
                    Controller.trainingPlans[index].pdfFile,
                    Controller.trainingPlans[index].planName);
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
            IconButton(
              icon: Icon(Icons.print),
              onPressed: () async {
                http.Response response = await http
                    .get(Uri.parse(Controller.trainingPlans[index].pdfFile));
                var pdfData = response.bodyBytes;
                await Printing.layoutPdf(
                    onLayout: (PdfPageFormat format) async => pdfData);
              },
            ),
          ],
        ),
        onLongPress: () async {
          bool result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return DeleteDialog();
            },
          );
          if (result) {
            EasyLoading.show();
            String response = await APICalls.deleteTrainingPlan(
                Controller.trainingPlans[index].id);
            EasyLoading.dismiss();
            if (response == "Successfully Deleted Training Plan") {
              setState(() {
                Controller.trainingPlans.removeAt(index);
              });
            }
            Controller.showSnackBar(response, context);
          }
        },
      ),
    );
  }

  Widget getTrainingsListView() {
    return ListView.separated(
      itemCount: Controller.trainingPlans.length + 1,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: SizeConfig.height10,
        );
      },
      itemBuilder: (context, index) {
        if (Controller.trainingPlans.length == 0) {
          return Center(
            child: Text("No plans found"),
          );
        } else {
          if (Controller.trainingPlans.length == index) {
            return Align(
              child: LoadMoreButton(() => getTrainingPlans()),
            );
          } else {
            return trainingPlanItem(index);
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
          bottomNavigationBar: MynavWhite(
            colorType: 1,
            currIndex: 3,
            scaffoldKey: _scaffoldKey,
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('lib/Assets/images/booktraing.png'),
                  fit: BoxFit.cover),
            ),
            child: Column(
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
                        "Training Plans",
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
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.width30),
                  height: SizeConfig.height480,
                  width: double.infinity,
                  child: getTrainingsListView(),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            foregroundColor: Color(0xffF9C303),
            backgroundColor: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrainingPlanVideosSelectionScreen(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
