import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:zaphry/Controller/Controller.dart';
import 'package:zaphry/Model/ClubEventDetails.dart';
import 'package:zaphry/Model/ClubProfile.dart';
import 'package:zaphry/Model/CoachProfile.dart';
import 'package:zaphry/Model/PlayerProfile.dart';
import 'package:zaphry/Model/RequestedProfile.dart';
import 'package:zaphry/Model/SignInResponse.dart';
import 'package:zaphry/Model/TrainingProgramDetails.dart';
import 'package:zaphry/Model/VideoDetails.dart';

class APICalls {
  static String baseUrl =
      "https://www.zaphry.com/demo/mobile_api.php"; //"http://zaphry.logic-valley.com/mobile_api.php";
  static String apiKey = "EX3hAgMaIMjtRDhOoodZXSF8anBDUR";

  static String authKey = "";

  static Future<String> signUpEmail(String email, String password) async {
    print("Signing Up with Email");
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'signup_email',
          'email': email,
          'password': password,
          'user_type': Controller.memberType.toString()
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> signUpPhone(String phone, String password) async {
    // removing the initial "+"
    phone = phone.substring(1);
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'signup_phone',
          'phone_no': phone,
          'password': password,
          'user_type': Controller.memberType.toString()
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> signInEmail(String email, String password) async {
    print("Signing In with Email");
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'signin_email',
          'email': email,
          'password': password,
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            Controller.signinResponse = SignInResponse.fromMapObject(result);

            authKey = Controller.signinResponse!.authKey;
            Controller.saveAuthKey(authKey);
            Controller.saveMemberType(Controller.signinResponse!.userType);
          }

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> signInPhone(String phone, String password) async {
    print("Signing In with Phone");
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'signin_phone',
          'phone_no': phone,
          'password': password,
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            Controller.signinResponse = SignInResponse.fromMapObject(result);

            authKey = Controller.signinResponse!.authKey;
            Controller.saveAuthKey(authKey);
            Controller.saveMemberType(Controller.signinResponse!.userType);
          }

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> verifyEmail(String verificationCode) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'verify_email',
          'email': Controller.email,
          'verification_code': verificationCode,
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            Controller.signinResponse = SignInResponse.fromMapObject(result);

            authKey = Controller.signinResponse!.authKey;
            Controller.saveAuthKey(authKey);
            Controller.saveMemberType(Controller.signinResponse!.userType);
          }

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> sendCodeAgainEmail() async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'send_code_again_email',
          'email': Controller.email,
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> sendCodeAgainPhone() async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'send_code_again_phone',
          'phone_no': Controller.phone,
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> verifyPhone(String verificationCode) async {
    Controller.phone = Controller.phone!.substring(1);
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'verify_phone',
          'phone_no': Controller.phone,
          'verification_code': verificationCode,
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            Controller.signinResponse = SignInResponse.fromMapObject(result);

            authKey = Controller.signinResponse!.authKey;
            Controller.saveAuthKey(authKey);
            Controller.saveMemberType(Controller.signinResponse!.userType);
          }

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> logout() async {
    print("authKey: " + authKey);
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'close',
          'auth_key': authKey,
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            Controller.resetAllForNewUser();
          }

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> checkSession() async {
    authKey = Controller.getAuthKey();
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url,
            body: {'key': apiKey, 'action': 'check', 'auth_key': authKey});

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> profile({bool? forURL}) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url,
            body: {'key': apiKey, 'action': 'profile', 'auth_key': authKey});

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print(result);

          if (result["responseCode"] == "201") {
            if (forURL != null) {
              if (forURL) {
                Controller.publicURL =
                    result["profile_details"]["personal_profile"]['public_url'];
              }
            } else {
              if (Controller.memberType == 1) {
                Controller.coachProfile = CoachProfile.fromMapObject(
                    result["profile_details"]["personal_profile"]);
                Controller.coachProfile!.addProfessionalProfile(
                    result["profile_details"]["professional_profile"]);
              } else if (Controller.memberType == 2) {
                Controller.playerProfile = PlayerProfile.fromMapObject(
                    result["profile_details"]["personal_profile"]);
                Controller.playerProfile!.addProfessionalProfile(
                    result["profile_details"]["professional_profile"]);
              } else if (Controller.memberType == 3) {
                Controller.clubProfile = ClubProfile.fromMapObject(
                    result["profile_details"]["personal_profile"]);
              }
            }
          }

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> editProfile(
      {String? firstName,
      String? lastName,
      String? picture,
      bool? sendImage,
      String? gender,
      String? aboutMe,
      String? zipCode,
      String? timeZone,
      String? org,
      String? ageGroup,
      String? experience,
      String? publicURL,
      String? meetingLink,
      String? dob,
      String? regNo,
      String? contactPerson,
      String? address}) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      Map<String, dynamic> requestBody = {};

      if (Controller.memberType == 1) {
        requestBody = {
          'key': apiKey,
          'auth_key': authKey,
          'action': 'edit_profile',
          'fname': firstName!,
          'lname': lastName!,
          'gender': gender!,
          'aboutme': aboutMe!,
          'zipcode': zipCode!,
          'time_zone': timeZone!,
          'org': org!,
          'agegroups': ageGroup!,
          'experience': experience!,
          'public_url': publicURL!,
          'meetinglink': meetingLink!
        };
      } else if (Controller.memberType == 2) {
        requestBody = {
          'key': apiKey,
          'auth_key': authKey,
          'action': 'edit_profile',
          'fname': firstName!,
          'lname': lastName!,
          'gender': gender!,
          'aboutme': aboutMe!,
          'zipcode': zipCode!,
          'time_zone': timeZone!,
          'org': org!,
          'agegroups': ageGroup!,
          'experience': experience!,
          'dob': dob!,
        };
      } else if (Controller.memberType == 3) {
        requestBody = {
          'key': apiKey,
          'auth_key': authKey,
          'action': 'edit_profile',
          'fname': firstName!,
          'lname': " ",
          'reg_no': regNo!,
          'contact_person': contactPerson!,
          'address': address!
        };
      }

      try {
        var dio = Dio();
        var formData = FormData.fromMap(requestBody);
        if (sendImage != null) {
          if (sendImage) {
            formData.files.add(MapEntry(
                "coachpicture", await MultipartFile.fromFile(picture!)));
          }
        }
        var response = await dio.post(baseUrl, data: formData);

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.data != null) {
          Map<String, dynamic> result = jsonDecode(response.data);

          if (result["responseCode"] == "201") {
            if (Controller.memberType == 3) {
              if (result['updated_profile_details']['image'] != null) {
                Controller.clubProfile!.image =
                    result['updated_profile_details']['image'];
              }
            }
          }

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> editAssociatedEmail(String email) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'edit_associated_email',
          'auth_key': authKey,
          'email': email
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> editAssociatedPhone(String phone, String prefix) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'edit_associated_phone_no',
          'auth_key': authKey,
          'phone_no': phone,
          'phone_prefix': prefix
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> verifyAssociatedEmail(String email, String code) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'verify_associated_email',
          'auth_key': authKey,
          'email': email,
          'verification_code': code
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> verifyAssociatedPhone(String phone, String code) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'verify_associated_phone',
          'auth_key': authKey,
          'phone_no': phone,
          'verification_code': code
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> sendCodeAgainAssociatedEmail(String email) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'send_code_again_associated_email',
          'auth_key': authKey,
          'email': email
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> sendCodeAgainAssociatedPhone(String phone) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'send_code_again_associated_phone',
          'auth_key': authKey,
          'phone_no': phone
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> createSession(
      {required String dateTime,
      required String sessionType,
      required String price,
      required String description,
      required String recursionType,
      String? duration,
      String? sunday,
      String? monday,
      String? tuesday,
      String? wednesday,
      String? thursday,
      String? friday,
      String? saturday}) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      Map<String, String> requestBody = {};

      if (recursionType == "1") {
        requestBody = {
          'key': apiKey,
          'action': 'create_session',
          'auth_key': authKey,
          'date_time': dateTime,
          'session_type': sessionType,
          'price': price,
          'description': description,
          'recursion_type': recursionType
        };
      } else if (recursionType == "2") {
        requestBody = {
          'key': apiKey,
          'action': 'create_session',
          'auth_key': authKey,
          'date_time': dateTime,
          'session_type': sessionType,
          'price': price,
          'description': description,
          'recursion_type': recursionType,
          'duration': duration!,
          'sunday': sunday!,
          'monday': monday!,
          'tuesday': tuesday!,
          'wednesday': wednesday!,
          'thursday': thursday!,
          'friday': friday!,
          'saturday': saturday!,
        };
      }

      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: requestBody);

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> bookSession(
      String sessionID, String sessionType) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'book_session',
          'auth_key': authKey,
          'session_id': sessionID,
          'session_type': sessionType
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> payNow(String sessions) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'pay_now',
          'auth_key': authKey,
          'slots': sessions
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            Controller.paymentLink = result['payment_link'];
          }

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> sessionCheck() async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'session_check',
          'auth_key': authKey
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {}

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> coachDashboard(
      String listing, String pageNo, String limit) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'coach_dashboard',
          'auth_key': authKey,
          'listing': listing,
          'limit': limit,
          'page_no': pageNo,
          'order': "desc"
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            if (listing == "all") {
              if (pageNo == "1") {
                Controller.getCoachDashboardAllSessions(result, clear: true);
              } else {
                Controller.getCoachDashboardAllSessions(result);
              }
            } else {
              if (pageNo == "1") {
                Controller.getCoachUpcomingSessions(result, clear: true);
              } else {
                Controller.getCoachUpcomingSessions(result);
              }
            }
          }

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> coachMySessions(
      String listing, String pageNo, String limit) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'coach_my_sessions',
          'auth_key': authKey,
          'listing': listing,
          'limit': limit,
          'page_no': pageNo
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            if (listing == "past") {
              if (pageNo == "1") {
                Controller.getCoachMyPastSessions(result, clear: true);
              } else {
                Controller.getCoachMyPastSessions(result);
              }
            } else {
              if (pageNo == "1") {
                Controller.getCoachUpcomingSessions(result, clear: true);
              } else {
                Controller.getCoachUpcomingSessions(result);
              }
            }
          }

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> coachMyPayments(
      String listing, String pageNo, String limit) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'coach_my_payments',
          'auth_key': authKey,
          'listing': listing,
          'limit': limit,
          'page_no': pageNo
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            if (listing == "past") {
              if (pageNo == "1") {
                Controller.getCoachSuccessfulPayments(result, clear: true);
              } else {
                Controller.getCoachSuccessfulPayments(result);
              }
            } else {
              if (pageNo == "1") {
                Controller.getCoachPendingPayments(result, clear: true);
              } else {
                Controller.getCoachPendingPayments(result);
              }
            }
          }

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> playerDashboard(
      String listing, String pageNo, String limit) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'player_dashboard',
          'auth_key': authKey,
          'listing': listing,
          'limit': limit,
          'page_no': pageNo
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            if (listing == "all") {
              if (pageNo == "1") {
                Controller.getPlayerDashboardAllSessions(result, clear: true);
              } else {
                Controller.getPlayerDashboardAllSessions(result);
              }
            } else {
              if (pageNo == "1") {
                Controller.getPlayerUpcomingSessions(result, clear: true);
              } else {
                Controller.getPlayerUpcomingSessions(result);
              }
            }
          }

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> playerMyTrainings(
      String listing, String pageNo, String limit) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'player_my_trainings',
          'auth_key': authKey,
          'listing': listing,
          'limit': limit,
          'page_no': pageNo
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            if (listing == "past") {
              if (pageNo == "1") {
                Controller.getPlayerMyPastSessions(result, clear: true);
              } else {
                Controller.getPlayerMyPastSessions(result);
              }
            } else {
              if (pageNo == "1") {
                Controller.getPlayerUpcomingSessions(result, clear: true);
              } else {
                Controller.getPlayerUpcomingSessions(result);
              }
            }
          }

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> playerMyPayments(
      String listing, String pageNo, String limit) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'player_my_payments',
          'auth_key': authKey,
          'listing': listing,
          'limit': limit,
          'page_no': pageNo
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            if (listing == "past") {
              if (pageNo == "1") {
                Controller.getPlayerSuccessfulPayments(result, clear: true);
              } else {
                Controller.getPlayerSuccessfulPayments(result);
              }
            } else {
              if (pageNo == "1") {
                Controller.getPlayerPendingPayments(result, clear: true);
              } else {
                Controller.getPlayerPendingPayments(result);
              }
            }
          }

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> coachSessionDelete(String sessionID) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'coach_session_delete',
          'auth_key': authKey,
          'session_id': sessionID
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> coachSessionCancel(
      String sessionID, String reason) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'coach_session_cancel',
          'auth_key': authKey,
          'session_id': sessionID,
          'reason': reason
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> playerSessionCancel(
      String sessionID, String reason) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'player_session_cancel',
          'auth_key': authKey,
          'session_id': sessionID,
          'reason': reason
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> coachSessionFeedback(
      String sessionID, String delivery, String rating, String remarks) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'coach_session_feedback',
          'auth_key': authKey,
          'session_id': sessionID,
          'delivery': delivery,
          'rating': rating,
          'coach_remarks': remarks
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> playerSessionFeedback(
      String sessionID, String delivery, String rating, String remarks) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'player_session_feedback',
          'auth_key': authKey,
          'session_id': sessionID,
          'delivery': delivery,
          'rating': rating,
          'player_remarks': remarks
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> coachViewFeedback(String sessionID) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'coach_view_feedback',
          'auth_key': authKey,
          'session_id': sessionID
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            Controller.getFeedbackInList(result);
          }

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> playerViewFeedback(String sessionID) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'player_view_feedback',
          'auth_key': authKey,
          'session_id': sessionID
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            Controller.getFeedbackInList(result);
          }

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> search(
      String startDate, String endDate, String limit, String pageNo) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'search',
          'start': startDate,
          'end': endDate,
          'limit': limit,
          'page_no': pageNo
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            if (pageNo == "1") {
              Controller.getSearchSessionResults(result, clear: true);
            } else {
              Controller.getSearchSessionResults(result);
            }
          }

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> getProfileDropdowns() async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url,
            body: {'key': apiKey, 'action': 'get_profile_dropdowns'});

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            Controller.getProfileDropdowns(result);
          }

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> getCountries() async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http
            .post(url, body: {'key': apiKey, 'action': 'get_countries'});

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            Controller.getCountriesCodes(result);
          }

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> getSessionTypes() async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http
            .post(url, body: {'key': apiKey, 'action': 'get_session_types'});

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            Controller.getDropdownSessionTypes(result);
          }

          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> getClubs() async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response =
            await http.post(url, body: {'key': apiKey, 'action': 'get_clubs'});

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            Controller.getClubsInfo(result);
          }

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> clubAssociation(String clubID) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'club_association',
          'auth_key': authKey,
          'club': clubID
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> changePassword(
      String oldPass, String newPass, String newPassConfirm) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'change_password',
          'auth_key': authKey,
          'old_password': oldPass,
          'new_password': newPass,
          'confirm_password': newPassConfirm
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> forgotPasswordEmail(String email) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'forgot_password_email',
          'email': email
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> forgotPasswordPhone(String phone) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'forgot_password_phone',
          'phone_no': phone
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> forgotPasswordPhoneVerify(
      String phone, String code, String newPass, String confirmPass) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'forgot_password_phone_verify',
          'phone_no': phone,
          'reset_verification_code': code,
          'new_password': newPass,
          'confirm_password': confirmPass
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> getCategories() async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http
            .post(url, body: {'key': apiKey, 'action': 'get_categories'});

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            Controller.getVideoCategories(result);
          }

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> getClubVideos(
      String categoryID, String pageNo, String limit) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'club_videos',
          'auth_key': authKey,
          'category': categoryID,
          'page_no': pageNo,
          'limit': limit
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print(result);

          if (result["responseCode"] == "201") {
            if (pageNo == "1") {
              Controller.getClubVideos(result, clear: true);
            } else {
              Controller.getClubVideos(result);
            }
          }

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> getVideoDetails(String videoID) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'video_details',
          'auth_key': authKey,
          'video_id': videoID
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print(result);

          if (result["responseCode"] == "201") {
            Controller.videoDetails =
                VideoDetails.fromMapObject(result['video_details']);
          }

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> deleteVideo(String videoID) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'video_delete',
          'auth_key': authKey,
          'video_id': videoID
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> addVideo(
      {required String title,
      required String description,
      required String category,
      required String recipients,
      required String status,
      required String duration,
      required List<String> images,
      required String video,
      required String printTitle,
      required String printDescription,
      required String printImage}) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        /*List<MultipartFile> multipartImages = [];
        for (int c = 0; c < images.length; c++) {
          multipartImages.add(MultipartFile.fromFileSync(images[c]));
        }*/

        Map<String, dynamic> requestBody = {
          'key': apiKey,
          'action': 'video_add',
          'auth_key': authKey,
          'title': title, //
          'description': description, //
          'category': category,
          'recipients': recipients,
          'status': status,
          'duration': duration,
          'video': await MultipartFile.fromFile(video),
          'image': [
            for (var file in images)
              {await MultipartFile.fromFile(file)}.toList()
          ]
        };

        var dio = Dio();
        var formData = FormData.fromMap(requestBody);

        var response = await dio.post(
          baseUrl,
          data: formData,
          /*onSendProgress: (int sent, int total) {
          print('$sent $total');
        },*/
        );

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.data != null) {
          Map<String, dynamic> result = jsonDecode(response.data);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> editVideo(
      {required String videoID,
      required String title,
      required String description,
      required String category,
      required String recipients,
      required String status,
      required String duration}) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        Map<String, dynamic> requestBody = {
          'key': apiKey,
          'action': 'video_edit',
          'auth_key': authKey,
          'video_id': videoID,
          'title': title,
          'description': description,
          'category': category,
          'recipients': recipients,
          'status': status,
          'duration': duration,
        };

        var dio = Dio();
        var formData = FormData.fromMap(requestBody);

        var response = await dio.post(baseUrl, data: formData);

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.data != null) {
          Map<String, dynamic> result = jsonDecode(response.data);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> getClubRequests() async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'club_association_requests',
          'auth_key': authKey
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            Controller.getClubRequests(result);
          }

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> clubRequestAction(String userID, String action) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'club_association_requests_action',
          'auth_key': authKey,
          'user_id': userID,
          'approval': action
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> clubEvents(String pageNo, String limit) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'club_events',
          'auth_key': authKey,
          'page_no': pageNo,
          'limit': limit
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            if (pageNo == "1") {
              Controller.getClubEvents(result, clear: true);
            } else {
              Controller.getClubEvents(result);
            }
          }

          print("events");
          print(result);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> getEventDetails(String eventID) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'event_details',
          'event_id': eventID
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            Controller.clubEventDetails =
                ClubEventDetails.fromMapObject(result['event_details']);
          }

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> getAttendeesDetails(
      String eventID, String pageNo, String limit) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'club_event_attendees_details',
          'auth_key': authKey,
          'event_id': eventID,
          'page_no': pageNo,
          'limit': limit
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            if (pageNo == "1") {
              Controller.getEventAttendeesDetails(result, clear: true);
            } else {
              Controller.getEventAttendeesDetails(result);
            }
          }

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> requestProfile(String userID) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'requested_profile',
          'auth_key': authKey,
          'user_id': userID
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            Controller.requestedProfile =
                RequestedProfile.fromMapObject(result['profile_details']);
          }

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> deleteEvent(String eventID) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'club_delete_event',
          'auth_key': authKey,
          'event_id': eventID
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> addEvent(
      {required String title,
      required String description,
      required String ageGroups,
      required String startDateTime,
      required String inquiring,
      required String image,
      required String video,
      required List<String> attachments,
      required bool sendVideo,
      required bool sendAttachments}) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        Map<String, dynamic> requestBody = {
          'key': apiKey,
          'action': 'club_add_event',
          'auth_key': authKey,
          'title': title,
          'description': description,
          'age_groups': ageGroups,
          'start_date_time': startDateTime,
          'inquiring': inquiring,
          'image': await MultipartFile.fromFile(image),
          'attachment': [
            for (var file in attachments)
              {await MultipartFile.fromFile(file)}.toList()
          ]
        };

        var dio = Dio();
        var formData = FormData.fromMap(requestBody);

        if (sendVideo) {
          formData.files
              .add(MapEntry("video", await MultipartFile.fromFile(video)));
        }

        var response = await dio.post(baseUrl, data: formData);

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.data != null) {
          Map<String, dynamic> result = jsonDecode(response.data);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> editEvent(
      {required String eventID,
      required String title,
      required String description,
      required String ageGroups,
      required String startDateTime,
      required String inquiring,
      required String image,
      required String video,
      required bool sendVideo,
      required bool sendImage}) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        Map<String, dynamic> requestBody = {
          'key': apiKey,
          'action': 'club_edit_event',
          'auth_key': authKey,
          'event_id': eventID,
          'title': title,
          'description': description,
          'age_groups': ageGroups,
          'start_date_time': startDateTime,
          'inquiring': inquiring,
        };

        var dio = Dio();
        var formData = FormData.fromMap(requestBody);

        if (sendImage) {
          formData.files
              .add(MapEntry("image", await MultipartFile.fromFile(image)));
        }

        if (sendVideo) {
          formData.files
              .add(MapEntry("video", await MultipartFile.fromFile(video)));
        }

        var response = await dio.post(baseUrl, data: formData);

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.data != null) {
          Map<String, dynamic> result = jsonDecode(response.data);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> getClubTrainingPrograms(
      String pageNo, String limit) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'club_training_programs',
          'auth_key': authKey,
          'page_no': pageNo,
          'limit': limit
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            Controller.getTrainingPrograms(result, clear: pageNo == "1");
          }

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> getClubTrainingProgramDetails(String programID) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'club_training_program_view',
          'auth_key': authKey,
          'program_id': programID
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            Controller.trainingProgramDetails =
                TrainingProgramDetails.fromMapObject(
                    result['training_program_details']);
          }

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> getPlayerVideos(
      String categoryID, String pageNo, String limit) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'player_videos',
          'auth_key': authKey,
          'category': categoryID,
          'page_no': pageNo,
          'limit': limit,
          'listing': "both"
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print(result);

          if (result["responseCode"] == "201") {
            if (pageNo == "1") {
              Controller.getPlayerCoachVideos(result, clear: true);
            } else {
              Controller.getPlayerCoachVideos(result);
            }
          }

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> getPlayerCoachTrainingPrograms(
      String pageNo, String limit) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'coach_player_training_programs',
          'auth_key': authKey,
          'page_no': pageNo,
          'limit': limit
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            Controller.getTrainingPrograms(result, clear: pageNo == "1");
          }

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> getCoachVideos(
      String categoryID, String pageNo, String limit) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'coach_videos',
          'auth_key': authKey,
          'category': categoryID,
          'page_no': pageNo,
          'limit': limit,
          'listing': "both"
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print(result);

          if (result["responseCode"] == "201") {
            if (pageNo == "1") {
              Controller.getPlayerCoachVideos(result, clear: true);
            } else {
              Controller.getPlayerCoachVideos(result);
            }
          }

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> getTrainingPlans(String pageNo, String limit) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'coach_training_plans',
          'auth_key': authKey,
          'page_no': pageNo,
          'limit': limit
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            if (pageNo == "1") {
              Controller.getTrainingPlans(result, clear: true);
            } else {
              Controller.getTrainingPlans(result);
            }
          }

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> deleteTrainingPlan(String planID) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'delete_training_plan',
          'auth_key': authKey,
          'plan_id': planID
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> getTrainingPlanVideos(
      String categoryID, String pageNo, String limit) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'coach_training_plan_videos',
          'auth_key': authKey,
          'category': categoryID,
          'page_no': pageNo,
          'limit': limit
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print(result);

          if (result["responseCode"] == "201") {
            if (pageNo == "1") {
              Controller.getTrainingPlanVideos(result, clear: true);
            } else {
              Controller.getTrainingPlanVideos(result);
            }
          }

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> createTrainingPlan(
      String title, String videoIDs) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'create_training_plan',
          'auth_key': authKey,
          'title': title,
          'video_ids': videoIDs
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> getEvents(String pageNo, String limit) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'upcoming_events',
          'page_no': pageNo,
          'limit': limit
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            if (pageNo == "1") {
              Controller.getEvents(result, clear: true);
            } else {
              Controller.getEvents(result);
            }
          }

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> getInterestedEvents(String pageNo, String limit) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'user_event_interests',
          'auth_key': authKey,
          'page_no': pageNo,
          'limit': limit
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result["responseCode"] == "201") {
            if (pageNo == "1") {
              Controller.getInterestedEvents(result, clear: true);
            } else {
              Controller.getInterestedEvents(result);
            }
          }

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> eventInterest(String eventID, String interest) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'event_interest',
          'auth_key': authKey,
          'event_id': eventID,
          'interest': interest
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

  static Future<String> sendInquiry(String eventID, String inquiry) async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'event_inquiry',
          'auth_key': authKey,
          'event_id': eventID,
          'inquiry': inquiry
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }

/*static Future<String> template() async {
    bool connection = await Controller.checkInternetConnection();
    if (connection) {
      try {
        var url = Uri.parse(baseUrl);
        var response = await http.post(url, body: {
          'key': apiKey,
          'action': 'signup_email',
          'auth_key': authKey,
          'password': '123456',
          'user_type': "2"
        });

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> result = jsonDecode(response.body);

          print('Response code: ${result["responseCode"]}');
          print('Response state: ${result["responseState"]}');
          print('Response text: ${result["responseText"]}');

          return result["responseText"];
        } else {
          return "Unable to process request at the moment";
        }
      } catch (e) {
        print("error: $e");
        return "Unable to process request at the moment";
      }
    } else {
      return "No Internet Connection";
    }
  }*/

}
