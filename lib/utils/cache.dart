import 'package:shared_preferences/shared_preferences.dart';

class cache {
  static late SharedPreferences SharedPreference;
  static init() async {
    SharedPreference = await SharedPreferences.getInstance();
  }

  static Future<bool> add_data(key, value) async {
    return await SharedPreference.setBool(key, value);
  }

  static dynamic? get_data(key) {
    return SharedPreference.get(key);
  }

  static Future<bool> save_data(String key, dynamic value) async {
    if (value is String) return await SharedPreference.setString(key, value);
    if (value is int) return await SharedPreference.setInt(key, value);
    if (value is bool) return await SharedPreference.setBool(key, value);
    return await SharedPreference.setDouble(key, value);
  }

  static Future<bool> remove_data(key) async {
    return await SharedPreference.remove(key);
  }
}
