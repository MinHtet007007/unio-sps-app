import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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

  static Future<void> saveLastSyncedTime() async {
    final prefs = await SharedPreferences.getInstance();

    // Get the current time in UTC
    final nowUtc = DateTime.now().toUtc();

    // Convert to Bangkok timezone (UTC+7)
    final bangkokTime = nowUtc.add(Duration(hours: 7));

    // Format as ISO8601 string
    final formattedBangkokTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(bangkokTime);

    // Save to SharedPreferences
    await prefs.setString(lastSyncedTimeKey, formattedBangkokTime);
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

  static Future<String> getLastSyncedTimeInBangkok() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSynced = prefs.getString(lastSyncedTimeKey);

    DateTime dateTime;

    if (lastSynced == null) {
      return "";
    } else {
      try {
        dateTime = DateTime.parse(lastSynced);
      } catch (e) {
        dateTime =
            DateTime.fromMillisecondsSinceEpoch(0); // Handle invalid format
      }
    }

    // Convert UTC to Bangkok time (UTC+7)
    final bangkokTime = dateTime.toUtc().add(Duration(hours: 6, minutes: 30));

    // Format for displaying
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(bangkokTime);
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
