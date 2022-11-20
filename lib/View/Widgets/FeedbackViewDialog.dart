import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/View/Model/SizeConfig.dart';

class FeedbackViewDialog extends StatefulWidget {
  const FeedbackViewDialog({Key? key}) : super(key: key);

  @override
  _FeedbackViewDialogState createState() => _FeedbackViewDialogState();
}

class _FeedbackViewDialogState extends State<FeedbackViewDialog> {
  Widget firstItem = SizedBox.shrink();
  Widget secondItem = SizedBox.shrink();
  bool isSecondAvailable = false;

  @override
  void initState() {
    super.initState();

    if (Controller.memberType == 1) {
      firstItem = getCoachFeedbackColumn();
      if (Controller.viewFeedbackList[3].length > 0) {
        secondItem = getPlayerFeedbackColumn();
        setState(() {
          isSecondAvailable = true;
        });
      }
    } else if (Controller.memberType == 2) {
      firstItem = getPlayerFeedbackColumn();
      if (Controller.viewFeedbackList[0].length > 0) {
        secondItem = getCoachFeedbackColumn();
        setState(() {
          isSecondAvailable = true;
        });
      }
    }
  }

  String getDeliveryText(String num) {
    if (num == "0") {
      return "Not Delivered";
    } else if (num == "1") {
      return "Delivered & it was Good";
    } else {
      return "Delivered but not Good";
    }
  }

  Widget getCoachFeedbackColumn() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Coach Feedback",
          style: TextStyle(
              color: Colors.black,
              fontSize: SizeConfig.width20,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: SizeConfig.height15,
        ),
        Text(
          "Delivery",
          style: TextStyle(
              color: Colors.black,
              fontSize: SizeConfig.width15,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: SizeConfig.height5,
        ),
        Text(
          getDeliveryText(Controller.viewFeedbackList[0]), // coach delivery
          style: TextStyle(color: Colors.black, fontSize: SizeConfig.width14),
        ),
        SizedBox(
          height: SizeConfig.height10,
        ),
        Text(
          "Rating",
          style: TextStyle(
              color: Colors.black,
              fontSize: SizeConfig.width15,
              fontWeight: FontWeight.bold),
        ),
        IgnorePointer(
          child: RatingBar.builder(
            itemSize: 20,
            initialRating: double.parse(Controller.viewFeedbackList[1]),
            // coach rating
            minRating: 1,
            direction: Axis.horizontal,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(
                horizontal: SizeConfig.width2, vertical: SizeConfig.height15),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.black,
            ),
            onRatingUpdate: (rating) {},
          ),
        ),
        Text(
          "Remarks",
          style: TextStyle(
              color: Colors.black,
              fontSize: SizeConfig.width15,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: SizeConfig.height5,
        ),
        Text(
          Controller.viewFeedbackList[2], // coach remarks
          style: TextStyle(color: Colors.black, fontSize: SizeConfig.width14),
        ),
      ],
    );
  }

  Widget getPlayerFeedbackColumn() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Player Feedback",
          style: TextStyle(
              color: Colors.black,
              fontSize: SizeConfig.width20,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: SizeConfig.height15,
        ),
        Text(
          "Delivery",
          style: TextStyle(
              color: Colors.black,
              fontSize: SizeConfig.width15,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: SizeConfig.height5,
        ),
        Text(
          getDeliveryText(Controller.viewFeedbackList[3]), // player delivery
          style: TextStyle(color: Colors.black, fontSize: SizeConfig.width14),
        ),
        SizedBox(
          height: SizeConfig.height10,
        ),
        Text(
          "Rating",
          style: TextStyle(
              color: Colors.black,
              fontSize: SizeConfig.width15,
              fontWeight: FontWeight.bold),
        ),
        IgnorePointer(
          child: RatingBar.builder(
            itemSize: 20,
            initialRating: double.parse(Controller.viewFeedbackList[4]),
            // player rating
            minRating: 1,
            direction: Axis.horizontal,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(
                horizontal: SizeConfig.width2, vertical: SizeConfig.height15),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.black,
            ),
            onRatingUpdate: (rating) {},
          ),
        ),
        Text(
          "Remarks",
          style: TextStyle(
              color: Colors.black,
              fontSize: SizeConfig.width15,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: SizeConfig.height5,
        ),
        Text(
          Controller.viewFeedbackList[5], // player remarks
          style: TextStyle(color: Colors.black, fontSize: SizeConfig.width14),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      contentPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.width20, vertical: SizeConfig.height20),
      backgroundColor: Color(0xffF9C303),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(SizeConfig.height25))),
      content: SingleChildScrollView(
        child: Container(
          width: SizeConfig.width390,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.height25),
            color: Color(0xffF9C303),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: Icon(
                      Icons.clear,
                      size: SizeConfig.height18,
                    ),
                    onTap: () => Navigator.of(context).pop(false),
                  )
                ],
              ),
              SizedBox(
                height: SizeConfig.height20,
              ),
              firstItem,
              isSecondAvailable
                  ? SizedBox(
                      height: SizeConfig.height40,
                    )
                  : SizedBox.shrink(),
              secondItem,
              SizedBox(
                height: SizeConfig.height20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
