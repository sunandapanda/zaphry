import 'package:shared_preferences/shared_preferences.dart';

// A class to handle shared Preferences
class SharedPrefs {
  static SharedPreferences? _prefs;

  static SharedPreferences? get prefs => _prefs;

  //This function should be called at the main function of the app (main.dart)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
}
