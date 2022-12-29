import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _preference;

  static Future<void> setPrefsInstance() async {
    _preference ??= await SharedPreferences.getInstance();
  }

  static Future<void> setUid(String uid) async {
    await _preference!.setString('uid', uid);
  }

  static String? fetchUid() {
    if (_preference != null) {
      return _preference!.getString('uid');
    } else {
      return null;
    }
  }

  static Future<void> deletePref(String myUid) async {
    final prefs = _preference!;
    prefs.clear();
  }
}
