import 'package:shared_preferences/shared_preferences.dart';

const tokenName = 'MGN-Clinic-Secret-Token';
const userName = 'MGN-Clinic-User-Name';
const userCode = 'MGN-Clinic-User-Code';
const userTownship = 'MGN-Clinic-User-Township';
const showSignature = 'MGN-Clinic-User-showSignature';
const app = 'MGN-Clinic-app';

class Cache {
  static saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenName, token);
  }

  static saveUserName(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userName, username);
  }

  static saveUserCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userCode, code);
  }

  static saveUserTownship(String township) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userTownship, township);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? prefsToken = prefs.getString(tokenName);

    return prefsToken;
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String? prefsUserName = prefs.getString(userName);

    return prefsUserName;
  }

  static Future<String?> getUserCode() async {
    final prefs = await SharedPreferences.getInstance();
    String? prefsUserName = prefs.getString(userCode);

    return prefsUserName;
  }

  static Future<String?> getUserTownship() async {
    final prefs = await SharedPreferences.getInstance();
    String? prefsUserTownship = prefs.getString(userTownship);

    return prefsUserTownship;
  }

  static deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenName, '');
  }

  static deleteUserName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userName, '');
  }

  static deleteUserCode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userCode, '');
  }

  static deleteShowSignature() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(showSignature, '');
  }

  static deleteAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
