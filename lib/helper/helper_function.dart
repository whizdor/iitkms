import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userSubSystemKey = "USERSYSTEMKEY";
  static String userLevelKey = "USERLEVELKEY";

  // saving the data to Shared Preferences
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  static Future<bool> saveUserSubSystemSF(String subsystem) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userSubSystemKey, subsystem);
  }

  static Future<bool> saveUserLevelSF(String level) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userLevelKey, level);
  }

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  static Future<String?> getUserSubSystemFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userSubSystemKey);
  }

  static Future<String?> getUserLevelFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userLevelKey);
  }
}
