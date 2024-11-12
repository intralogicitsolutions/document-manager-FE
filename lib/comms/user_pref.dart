import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {

  static String ISNT_FIRST_LAUNCH = 'isnt_first_launch';
  static String APP_THEME = 'APP_THEME';
  static String APP_THEME_LIGHT = 'APP_THEME_LIGHT';
  static String APP_THEME_DARK = 'APP_THEME_DARK';
  static String DATA_COLLECTION_ACCEPTED = 'DATA_COLLECTION_ACCEPTED';

  static String INSTALL_ID = 'INSTALL_ID';

  static Future<bool> write(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value);
  }

  static Future<String?> read(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString(key);
    return action;
  }

  static Future<void> delete(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}