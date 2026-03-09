import 'package:shared_preferences/shared_preferences.dart';
import 'package:ailixir/core/constants/app_constants.dart';

abstract class SharedPreferencesService {
  static late final SharedPreferences _instance;

  static Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }

  static Future<void> setBool({
    required String key,
    required bool value,
  }) async {
    await _instance.setBool(key, value);
  }

  static bool getBool({required String key, bool defaultValue = false}) {
    return _instance.getBool(key) ?? defaultValue;
  }

  static Future<void> setInt({required String key, required int value}) async {
    await _instance.setInt(key, value);
  }

  static int getInt({required String key, int defaultValue = 0}) {
    return _instance.getInt(key) ?? defaultValue;
  }

  static Future<void> setString({
    required String key,
    required String value,
  }) async {
    await _instance.setString(key, value);
  }

  static String? getString({required String key}) {
    return _instance.getString(key);
  }

  static Future<void> setStringList({
    required String key,
    required List<String> value,
  }) async {
    await _instance.setStringList(key, value);
  }

  static List<String> getStringList({required String key}) {
    return _instance.getStringList(key) ?? [];
  }

  static Future<void> deleteAllUserData() async {
    await _instance.remove(AppConstants.userIdKey);
    await _instance.remove(AppConstants.userNameKey);
    await _instance.remove(AppConstants.userEmailKey);
    await _instance.remove(AppConstants.userRoleKey);
    await _instance.remove(AppConstants.userImageKey);
  }
}
