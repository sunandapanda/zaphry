import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zaphry/Controller/APICalls.dart';
import 'package:zaphry/Model/ClubEvent.dart';
import 'package:zaphry/Model/ClubEventDetails.dart';
import 'package:zaphry/Model/ClubProfile.dart';
import 'package:zaphry/Model/ClubRequest.dart';
import 'package:zaphry/Model/CoachPayment.dart';
import 'package:zaphry/Model/CoachProfile.dart';
import 'package:zaphry/Model/CoachSession.dart';
import 'package:zaphry/Model/Event.dart';
import 'package:zaphry/Model/EventAttendeeDetails.dart';
import 'package:zaphry/Model/EventInterested.dart';
import 'package:zaphry/Model/PlayerPayment.dart';
import 'package:zaphry/Model/PlayerProfile.dart';
import 'package:zaphry/Model/PlayerSession.dart';
import 'package:zaphry/Model/RequestedProfile.dart';
import 'package:zaphry/Model/SearchSession.dart';
import 'package:zaphry/Model/SharedPrefs.dart';
import 'package:zaphry/Model/SignInResponse.dart';
import 'package:zaphry/Model/TrainingPlan.dart';
import 'package:zaphry/Model/TrainingPlanVideo.dart';
import 'package:zaphry/Model/TrainingProgram.dart';
import 'package:zaphry/Model/TrainingProgramDetails.dart';
import 'package:zaphry/Model/Video.dart';
import 'package:zaphry/Model/VideoDetails.dart';
import 'package:zaphry/View/Screens/DashboardClubScreen.dart';
import 'package:zaphry/View/Screens/DashboardScreen.dart';
import 'package:zaphry/View/Screens/JoinAsScreen.dart';
import 'package:zaphry/View/Screens/RegistrationFormClubScreen.dart';
import 'package:zaphry/View/Screens/RegistrationFormScreen.dart';
import 'package:zaphry/View/Screens/SignInScreen.dart';
import 'package:zaphry/View/Widgets/ExitDialog.dart';

class Controller {
  static String firstTimeString = "FIRST_TIME";
  static String authKeyString = "AUTH_KEY";
  static String memberTypeString = "MEMBER_TYPE";
  static String profileStatusString = "PROFILE_STATUS";
  static String drawerNameString = "DRAWER_NAME";
  static String drawerEmailString = "DRAWER_EMAIL";
  static String drawerImageString = "DRAWER_IMAGE";
  static String signUsingTypeString = "SIGN_USING_TYPE";

  static int memberType = 1; //coach
  static String profileStatus = "0";
  static String? email;
  static String? phone;
  static bool signUsingEmail = false;
  static SignInResponse? signinResponse;
  static CoachProfile? coachProfile;
  static PlayerProfile? playerProfile;
  static ClubProfile? clubProfile;

  static String? publicURL;

  static List<CoachSession> coachDashboardAllSessions = [];
  static List<CoachSession> coachUpcomingSessions = [];
  static List<CoachSession> coachMyPastSessions = [];
  static List<CoachPayment> coachPendingPayments = [];
  static List<CoachPayment> coachSuccessfulPayments = [];
  static List<String> dropdownSessionTypes = ["Select"];
  static List<PlayerSession> playerDashboardAllSessions = [];
  static List<PlayerSession> playerUpcomingSessions = [];
  static List<PlayerSession> playerMyPastSessions = [];
  static List<PlayerPayment> playerPendingPayments = [];
  static List<PlayerPayment> playerSuccessfulPayments = [];

  static List<SearchSession> searchSessionList = [];

  static String? drawerName;
  static String? drawerEmail;
  static String? drawerImage;

  static List<String> viewFeedbackList = [];

  static String paymentLink = "";

  static List<String> timeZoneKeys = ["0"];
  static List<String> timeZoneValues = ["Select Time Zone"];
  static List<int> ageGroupValues = [-1];
  static List<String> ageGroupTexts = ["Select Age Group"];
  static List<int> experienceValues = [-1];
  static List<String> experienceTexts = ["Select Experience"];

  static List<String> countryIDs = [];
  static List<String> countryNames = [];
  static List<String> countryCodes = [];
  static List<String> countryNamesAndCodes = [];

  static List<String> clubIDs = ["0"];
  static List<String> clubNames = ["Select Club"];

  static List<String> videoCategoryIDs = [];
  static List<String> videoCategoryNames = [];

  static List<Video> clubVideos = [];
  static VideoDetails? videoDetails;

  static List<ClubRequest> clubRequests = [];

  static List<ClubEvent> clubEvents = [];
  static ClubEventDetails? clubEventDetails;

  static List<EventAttendeeDetails> eventAttendeesDetailsList = [];
  static RequestedProfile? requestedProfile;

  static List<TrainingProgram> trainingProgramsList = [];
  static TrainingProgramDetails? trainingProgramDetails;
  static String pdfLocalPath = "";

  static List<Video> userCoachVideos = [];
  static List<Video> userClubVideos = [];

  static List<TrainingPlan> trainingPlans = [];
  static List<TrainingPlanVideo> trainingPlanVideos = [];
  static List<TrainingPlanVideo> trainingPlanSelectedVideos = [];

  static List<Event> upcomingEvents = [];
  static List<EventInterested> interestedEvents = [];

  //If user is registering PIN for the first time save the state
  static void setFirstTime() {
    bool? first = SharedPrefs.prefs!.getBool(firstTimeString);
    if (first == null) {
      SharedPrefs.prefs!.setBool(firstTimeString, false);
    }
  }

  //The Splash Screen Function will check if the user has opened the app for the first time or not
  static bool isFirstTime() {
    bool? first = SharedPrefs.prefs!.getBool(firstTimeString);
    setFirstTime();
    if (first != null) {
      return first;
    } else {
      return true;
      // first time is null which means the user has opened the app for the first time
    }
  }

  static void saveMemberType(String mmbrT) {
    SharedPrefs.prefs!.setInt(memberTypeString, int.parse(mmbrT));
    memberType = int.parse(mmbrT);
  }

  static void getMemberType() {
    int? memberT = SharedPrefs.prefs!.getInt(memberTypeString);
    if (memberT != null) {
      memberType = memberT;
    } else {
      memberType = 1;
    }
  }

  static void saveSignUsingType(bool type) {
    SharedPrefs.prefs!.setBool(signUsingTypeString, type);
    signUsingEmail = type;
  }

  static void getSignUsingType() {
    bool? signT = SharedPrefs.prefs!.getBool(signUsingTypeString);
    if (signT != null) {
      signUsingEmail = signT;
    } else {
      signUsingEmail = true;
    }
  }

  static void saveAuthKey(String key) {
    SharedPrefs.prefs!.setString(authKeyString, key);
  }

  static String getAuthKey() {
    String? key = SharedPrefs.prefs!.getString(authKeyString);
    if (key != null) {
      return key;
    } else {
      return "";
    }
  }

  static void saveProfileStatus(String key) {
    profileStatus = key;
    SharedPrefs.prefs!.setInt(profileStatusString, int.parse(key));
  }

  static String getProfileStatus() {
    profileStatus = SharedPrefs.prefs!.getInt(profileStatusString).toString();
    if (profileStatus != null) {
      return profileStatus;
    } else {
      return "0";
    }
  }

  static void saveDrawerData(String? name, String? email, String? image) {
    if (name != null) {
      drawerName = name;
      SharedPrefs.prefs!.setString(drawerNameString, name);
    } else {
      drawerName = "not provided";
      SharedPrefs.prefs!.setString(drawerNameString, "not provided");
    }
    if (email != null) {
      drawerEmail = email;
      SharedPrefs.prefs!.setString(drawerEmailString, email);
    } else {
      drawerEmail = "not provided";
      SharedPrefs.prefs!.setString(drawerEmailString, "not provided");
    }
    if (image != null) {
      drawerImage = image;
      SharedPrefs.prefs!.setString(drawerImageString, image);
    } else {
      drawerImage = "";
      SharedPrefs.prefs!.setString(drawerImageString, "");
    }
  }

  static void getDrawerData() {
    drawerName = SharedPrefs.prefs!.getString(drawerNameString).toString();
    drawerEmail = SharedPrefs.prefs!.getString(drawerEmailString).toString();
    drawerImage = SharedPrefs.prefs!.getString(drawerImageString).toString();
  }

  static Future<bool> isLoggedIn() async {
    String response = await APICalls.checkSession();
    if (response == "Session is active") {
      getMemberType();
      getSignUsingType();
      getProfileStatus();
      getDrawerData();
      return true;
    }
    return false;
  }

  static Future<Widget> fromSplashToScreen() async {
    if (isFirstTime()) {
      return JoinAsScreen();
    } else {
      bool loginCheck = await isLoggedIn();
      if (loginCheck) {
        if (profileStatus == "1") {
          return memberType == 3 ? DashboardClubScreen() : DashboardScreen();
        } else {
          if (memberType == 3) {
            return RegistrationFormClubScreen();
          } else {
            // load profile drop downs
            if (timeZoneValues.length > 1) {
              return RegistrationFormScreen(callProfileAPI: true);
            } else {
              bool check = await callProfileDropdownsAndCountryCodesAPI();
              if (check) {
                return RegistrationFormScreen(callProfileAPI: true);
              } else {
                return SignInScreen();
              }
            }
          }
        }
      } else {
        return SignInScreen();
      }
    }
  }

  static void showSnackBar(String message, context) {
    /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Color(0xffF9C303)),
      ),
      backgroundColor: Colors.black,
      duration: Duration(seconds: 3),
    ));*/
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void resetAllForNewUser() {
    coachDashboardAllSessions = [];
    coachUpcomingSessions = [];
    coachMyPastSessions = [];
    coachPendingPayments = [];
    coachSuccessfulPayments = [];
    dropdownSessionTypes = ["Select"];

    memberType = 1; //coach
    profileStatus = "0";
    email = null;
    phone = null;
    signUsingEmail = false;
    signinResponse = null;
    coachProfile = null;
    playerProfile = null;
    clubProfile = null;

    publicURL = null;

    coachDashboardAllSessions = [];
    coachUpcomingSessions = [];
    coachMyPastSessions = [];
    coachPendingPayments = [];
    coachSuccessfulPayments = [];
    dropdownSessionTypes = ["Select"];
    playerDashboardAllSessions = [];
    playerUpcomingSessions = [];
    playerMyPastSessions = [];
    playerPendingPayments = [];
    playerSuccessfulPayments = [];

    searchSessionList = [];

    saveDrawerData(null, null, null);

    viewFeedbackList = [];

    paymentLink = "";

    timeZoneKeys = ["0"];
    timeZoneValues = ["Select Time Zone"];
    ageGroupValues = [-1];
    ageGroupTexts = ["Select Age Group"];
    experienceValues = [-1];
    experienceTexts = ["Select Experience"];

    countryIDs = [];
    countryNames = [];
    countryCodes = [];
    countryNamesAndCodes = [];

    clubIDs = [];
    clubNames = [];

    videoCategoryIDs = [];
    videoCategoryNames = [];

    clubVideos = [];
    videoDetails = null;

    clubRequests = [];

    clubEvents = [];
    clubEventDetails = null;

    eventAttendeesDetailsList = [];
    requestedProfile = null;

    trainingProgramsList = [];
    trainingProgramDetails = null;

    userCoachVideos = [];
    userClubVideos = [];

    trainingPlans = [];
    trainingPlanVideos = [];
    trainingPlanSelectedVideos = [];

    upcomingEvents = [];
    interestedEvents = [];
    // TODO: add new lists and stuff here
  }

  static Future<bool> checkInternetConnection() async {
    bool connectivityCheck = false;
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 20));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        connectivityCheck = true;
      }
    } on SocketException catch (_) {
      print('not connected');
      connectivityCheck = false;
    }

    return connectivityCheck;
  }

  static Future<bool> getStoragePermission() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      print("storage permission: ${status.isGranted}");
      return true;
    } else {
      status = await Permission.storage.request();
      print("storage permission: ${status.isGranted}");
      return status.isGranted;
    }
  }

  static Future<bool> downloadFile(String url, String name) async {
    bool checkPermission = await getStoragePermission();
    if (checkPermission) {
      EasyLoading.show();

      /*String fullPath = "";
      if (Platform.isAndroid) {
        fullPath =
            "/sdcard/download/" + url.split("/")[url.split("/").length - 1];
      } else {
        var tempDir = await getApplicationDocumentsDirectory();
        fullPath =
            tempDir.path + "/" + url.split("/")[url.split("/").length - 1];
      }*/

      String fullPath = "";
      if (Platform.isAndroid) {
        fullPath = "/sdcard/download/" + name + ".pdf";
      } else {
        var tempDir = await getApplicationDocumentsDirectory();
        fullPath = tempDir.path + "/" + name + ".pdf";
      }

      try {
        var dio = Dio();

        Response response = await dio.download(
          url,
          fullPath,
          onReceiveProgress: (count, total) {
            if (total != -1) {
              print("downloaded: " +
                  (count / total * 100).toStringAsFixed(0) +
                  "%");
            }
          },
          deleteOnError: true,
        );
        print("status: " + response.statusCode.toString());
        pdfLocalPath = fullPath;
        EasyLoading.dismiss();
        return true;
      } catch (err) {
        EasyLoading.dismiss();
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<bool> onWillPop(context) async {
    bool result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ExitDialog();
      },
    );
    if (result == true) {
      exit(0);
    } else {
      return false;
    }
  }

  // Only for Coach Dashboard
  static void getCoachDashboardAllSessions(Map<String, dynamic> map,
      {bool? clear}) {
    if (clear != null && clear) {
      coachDashboardAllSessions.clear();
    }
    int currentCount = map["all_current_count"];
    for (int c = 0; c < currentCount; c++) {
      coachDashboardAllSessions
          .add(CoachSession.fromMapObject(map["all_session_details"][c]));
    }
  }

  // For Coach Dashboard and My Sessions Screen
  static void getCoachUpcomingSessions(Map<String, dynamic> map,
      {bool? clear}) {
    if (clear != null && clear) {
      coachUpcomingSessions.clear();
    }
    int currentCount = map["upcoming_current_count"];
    for (int c = 0; c < currentCount; c++) {
      coachUpcomingSessions
          .add(CoachSession.fromMapObject(map["upcoming_session_details"][c]));
    }
  }

  // Only for Coach My Sessions Screen
  static void getCoachMyPastSessions(Map<String, dynamic> map, {bool? clear}) {
    if (clear != null && clear) {
      coachMyPastSessions.clear();
    }
    int currentCount = map["past_current_count"];
    for (int c = 0; c < currentCount; c++) {
      coachMyPastSessions
          .add(CoachSession.fromMapObject(map["past_session_details"][c]));
    }
  }

  // Only for Coach My Payments Screen
  static void getCoachPendingPayments(Map<String, dynamic> map, {bool? clear}) {
    if (clear != null && clear) {
      coachPendingPayments.clear();
    }
    int currentCount = map["upcoming_current_count"];
    for (int c = 0; c < currentCount; c++) {
      coachPendingPayments
          .add(CoachPayment.fromMapObject(map["upcoming_payment_details"][c]));
    }
  }

  // Only for Coach My Payments Screen
  static void getCoachSuccessfulPayments(Map<String, dynamic> map,
      {bool? clear}) {
    if (clear != null && clear) {
      coachSuccessfulPayments.clear();
    }
    int currentCount = map["past_current_count"];
    for (int c = 0; c < currentCount; c++) {
      coachSuccessfulPayments
          .add(CoachPayment.fromMapObject(map["past_payment_details"][c]));
    }
  }

  static void getDropdownSessionTypes(Map<String, dynamic> map) {
    dropdownSessionTypes.clear();
    dropdownSessionTypes.add("Select");
    int count = map['types'].length;
    for (int c = 1; c <= count; c++) {
      dropdownSessionTypes.add(map['types'][c.toString()]);
    }
  }

  // Only for Player Dashboard
  static void getPlayerDashboardAllSessions(Map<String, dynamic> map,
      {bool? clear}) {
    if (clear != null && clear) {
      playerDashboardAllSessions.clear();
    }
    int currentCount = map["all_current_count"];
    for (int c = 0; c < currentCount; c++) {
      playerDashboardAllSessions
          .add(PlayerSession.fromMapObject(map["all_session_details"][c]));
    }
  }

  // For Player Dashboard and My Trainings Screen
  static void getPlayerUpcomingSessions(Map<String, dynamic> map,
      {bool? clear}) {
    if (clear != null && clear) {
      playerUpcomingSessions.clear();
    }
    int currentCount = map["upcoming_current_count"];
    for (int c = 0; c < currentCount; c++) {
      playerUpcomingSessions
          .add(PlayerSession.fromMapObject(map["upcoming_session_details"][c]));
    }
  }

  // Only for Player My Trainings Screen
  static void getPlayerMyPastSessions(Map<String, dynamic> map, {bool? clear}) {
    if (clear != null && clear) {
      playerMyPastSessions.clear();
    }
    int currentCount = map["past_current_count"];
    for (int c = 0; c < currentCount; c++) {
      playerMyPastSessions
          .add(PlayerSession.fromMapObject(map["past_session_details"][c]));
    }
  }

  // Only for Player My Payments Screen
  static void getPlayerPendingPayments(Map<String, dynamic> map,
      {bool? clear}) {
    if (clear != null && clear) {
      playerPendingPayments.clear();
    }
    int currentCount = map["upcoming_current_count"];
    for (int c = 0; c < currentCount; c++) {
      playerPendingPayments
          .add(PlayerPayment.fromMapObject(map["upcoming_payment_details"][c]));
    }
  }

  // Only for Player My Payments Screen
  static void getPlayerSuccessfulPayments(Map<String, dynamic> map,
      {bool? clear}) {
    if (clear != null && clear) {
      playerSuccessfulPayments.clear();
    }
    int currentCount = map["past_current_count"];
    for (int c = 0; c < currentCount; c++) {
      playerSuccessfulPayments
          .add(PlayerPayment.fromMapObject(map["past_payment_details"][c]));
    }
  }

  static void getSearchSessionResults(Map<String, dynamic> map, {bool? clear}) {
    if (clear != null && clear) {
      searchSessionList.clear();
    }
    int currentCount = map["current_count"];
    for (int c = 0; c < currentCount; c++) {
      searchSessionList
          .add(SearchSession.fromMapObject(map["session_details"][c]));
    }
  }

  static void getFeedbackInList(Map<String, dynamic> map) {
    viewFeedbackList.clear();
    if (map['session_feedback']['coach_feedback'] == "1") {
      viewFeedbackList.add(map['session_feedback']['coach_delivery']);
      viewFeedbackList.add(map['session_feedback']['coach_rating']);
      viewFeedbackList.add(map['session_feedback']['coach_remarks']);
    } else {
      viewFeedbackList.add("");
      viewFeedbackList.add("");
      viewFeedbackList.add("");
    }
    if (map['session_feedback']['player_feedback'] == "1") {
      viewFeedbackList.add(map['session_feedback']['player_delivery']);
      viewFeedbackList.add(map['session_feedback']['player_rating']);
      viewFeedbackList.add(map['session_feedback']['player_remarks']);
    } else {
      viewFeedbackList.add("");
      viewFeedbackList.add("");
      viewFeedbackList.add("");
    }
  }

  static Future<bool> callProfileDropdownsAndCountryCodesAPI() async {
    EasyLoading.show();
    String response = await APICalls.getProfileDropdowns();
    EasyLoading.dismiss();
    if (response == "Successfully returned details") {
      EasyLoading.show();
      String response2 = await APICalls.getCountries();
      EasyLoading.dismiss();
      if (response2 == "Successfully returned details") {
        EasyLoading.show();
        String response3 = await APICalls.getClubs();
        EasyLoading.dismiss();
        if (response3 == "Successfully returned details") {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static void getProfileDropdowns(Map<String, dynamic> map) {
    timeZoneKeys.clear();
    timeZoneValues.clear();
    timeZoneKeys.add("0");
    timeZoneValues.add("Select Time Zone");
    timeZoneKeys.addAll(map['time_zones'].keys.toList());
    timeZoneValues.addAll(List<String>.from(map['time_zones'].values));

    ageGroupValues.clear();
    ageGroupTexts.clear();
    ageGroupValues.add(-1);
    ageGroupTexts.add("Select Age Group");
    for (int c = 0; c < map["age_groups"].length; c++) {
      ageGroupValues.add(map["age_groups"][c]["value"]);
      ageGroupTexts.add(map["age_groups"][c]["text"]);
    }

    experienceValues.clear();
    experienceTexts.clear();
    experienceValues.add(-1);
    experienceTexts.add("Select Experience");
    for (int c = 0; c < map["experience"].length; c++) {
      experienceValues.add(map["experience"][c]["value"]);
      experienceTexts.add(map["experience"][c]["text"]);
    }
  }

  static void getCountriesCodes(Map<String, dynamic> map) {
    countryIDs.clear();
    countryNames.clear();
    countryCodes.clear();
    countryNamesAndCodes.clear();
    for (int c = 0; c < map["countries"].length; c++) {
      if (!countryCodes.contains(map["countries"][c]["phone_code"])) {
        countryIDs.add(map["countries"][c]["id"]);
        countryNames.add(map["countries"][c]["name"]);
        countryCodes.add(map["countries"][c]["phone_code"]);
        countryNamesAndCodes.add(map["countries"][c]["phone_code"] +
            " " +
            map["countries"][c]["name"]);
      }
    }
    countryCodes.sort();
  }

  static void getClubsInfo(Map<String, dynamic> map) {
    clubIDs.clear();
    clubNames.clear();
    clubIDs.add("0");
    clubNames.add("Select Club");
    for (int c = 0; c < map["countries"].length; c++) {
      clubIDs.add(map["countries"][c]["id"]);
      clubNames.add(map["countries"][c]["name"]);
    }
  }

  static void getVideoCategories(Map<String, dynamic> map) {
    videoCategoryIDs.clear();
    videoCategoryNames.clear();
    for (int c = 0; c < map['categories'].length; c++) {
      videoCategoryIDs.add(map['categories'][c]['id']);
      videoCategoryNames.add(map['categories'][c]['name']);
    }
  }

  static void getClubVideos(Map<String, dynamic> map, {bool? clear}) {
    if (clear != null && clear) {
      clubVideos.clear();
    }
    int currentCount = map["club_current_count"];
    for (int c = 0; c < currentCount; c++) {
      clubVideos.add(Video.fromMapObject(map["club_videos_details"][c]));
    }
  }

  static void getClubRequests(Map<String, dynamic> map) {
    clubRequests.clear();
    int currentCount = map["requests"].length;
    for (int c = 0; c < currentCount; c++) {
      clubRequests.add(ClubRequest.fromMapObject(map["requests"][c]));
    }
  }

  static void getClubEvents(Map<String, dynamic> map, {bool? clear}) {
    if (clear != null && clear) {
      clubEvents.clear();
    }
    int currentCount = map["current_count"];
    for (int c = 0; c < currentCount; c++) {
      clubEvents.add(ClubEvent.fromMapObject(map["events_details"][c]));
    }
  }

  static void getEventAttendeesDetails(Map<String, dynamic> map,
      {bool? clear}) {
    if (clear != null && clear) {
      eventAttendeesDetailsList.clear();
    }
    int currentCount = map["current_count"];
    for (int c = 0; c < currentCount; c++) {
      eventAttendeesDetailsList.add(
          EventAttendeeDetails.fromMapObject(map["events_users_details"][c]));
    }
  }

  static void getTrainingPrograms(Map<String, dynamic> map, {bool? clear}) {
    if (clear != null && clear) {
      trainingProgramsList.clear();
    }
    int currentCount = map["current_count"];
    for (int c = 0; c < currentCount; c++) {
      trainingProgramsList
          .add(TrainingProgram.fromMapObject(map["training_programs"][c]));
    }
  }

  static void getPlayerCoachVideos(Map<String, dynamic> map, {bool? clear}) {
    if (clear != null && clear) {
      userCoachVideos.clear();
      userClubVideos.clear();
    }
    // coach videos
    int currentCount = map["coach_current_count"];
    for (int c = 0; c < currentCount; c++) {
      userCoachVideos.add(Video.fromMapObject(map["coach_videos_details"][c]));
    }
    // club videos
    currentCount = map["club_current_count"];
    for (int c = 0; c < currentCount; c++) {
      userClubVideos.add(Video.fromMapObject(map["club_videos_details"][c]));
    }
  }

  static void getTrainingPlans(Map<String, dynamic> map, {bool? clear}) {
    if (clear != null && clear) {
      trainingPlans.clear();
    }
    int currentCount = map["current_count"];
    for (int c = 0; c < currentCount; c++) {
      trainingPlans.add(TrainingPlan.fromMapObject(map["training_plans"][c]));
    }
  }

  static void getTrainingPlanVideos(Map<String, dynamic> map, {bool? clear}) {
    if (clear != null && clear) {
      trainingPlanVideos.clear();
    }
    int currentCount = map["current_count"];
    for (int c = 0; c < currentCount; c++) {
      trainingPlanVideos.add(TrainingPlanVideo.fromMapObject(map["videos"][c]));
    }
  }

  static void getEvents(Map<String, dynamic> map, {bool? clear}) {
    if (clear != null && clear) {
      upcomingEvents.clear();
    }
    int currentCount = map["current_count"];
    for (int c = 0; c < currentCount; c++) {
      Event temp = Event.fromMapObject(map["upcoming_events"][c]);
      int index = interestedEvents
          .indexWhere((element) => element.eventID == temp.eventID);
      if (index < 0) {
        upcomingEvents.add(temp);
      }
    }
  }

  static void getInterestedEvents(Map<String, dynamic> map, {bool? clear}) {
    if (clear != null && clear) {
      interestedEvents.clear();
    }
    int currentCount = map["current_count"];
    for (int c = 0; c < currentCount; c++) {
      interestedEvents.add(
          EventInterested.fromMapObject(map["events_interests_details"][c]));
    }
  }
}
