import 'package:shared_preferences/shared_preferences.dart';

const tokenName = 'SPS-FY24-Secret-Token';
const userName = 'SPS-FY24-User-Name';
const userProject = 'SPS-FY24-User-Project';
const userTownship = 'SPS-FY24-User-Township';
const showSignature = 'SPS-FY24-User-showSignature';
const app = 'SPS-FY24-app';
const String lastSyncedTimeKey = 'last_synced_time';

class Cache {
  static saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenName, token);
  }

  // Save the current time as the last synced time
  static Future<void> saveLastSyncedTime() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().toIso8601String();
    await prefs.setString(lastSyncedTimeKey, now);
  }

  static saveUserName(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userName, username);
  }

  static saveUserProject(String project) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userProject, project);
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

    // Retrieve the last synced time
  static Future<DateTime?> getLastSyncedTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSynced = prefs.getString(lastSyncedTimeKey);
    if (lastSynced == null) return null;
    return DateTime.parse(lastSynced);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String? prefsUserName = prefs.getString(userName);

    return prefsUserName;
  }

  static Future<String?> getUserProject() async {
    final prefs = await SharedPreferences.getInstance();
    String? prefsUserName = prefs.getString(userProject);

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

  static deleteUserProject() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userProject, '');
  }

  static deleteShowSignature() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(showSignature, '');
  }

  static deleteLastSyncedTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(lastSyncedTimeKey, '');
  }

  static deleteAll() async {
    deleteToken();
    deleteUserName();
    deleteUserProject();
    deleteShowSignature();
    deleteLastSyncedTime();
  }
}
