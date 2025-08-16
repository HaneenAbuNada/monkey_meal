import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PrKeys { isLogin }

class SharedPrefController {
  SharedPrefController._();

  SharedPreferences? _sharedPreferences;
  static SharedPrefController? _instance;

  //=========================> Initialize SharedPreferenceController
  factory SharedPrefController() => _instance ??= SharedPrefController._();

  Future<void> initPreferences() async => _sharedPreferences = await SharedPreferences.getInstance();

  T? getValueFor<T>(String key) {
    if (_sharedPreferences == null) {
      throw Exception("SharedPreferences has not been initialized. Call initPreferences() first.");
    }
    if (_sharedPreferences!.containsKey(key)) {
      final value = _sharedPreferences!.get(key);
      if (value is T) {
        return value;
      } else {
        debugPrint("⚠️ Type mismatch for key '$key'. Stored: ${value.runtimeType}, Expected: $T");
      }
    }
    return null;
  }

  Future<bool> setBool({required String key, required bool value}) async =>
      await _sharedPreferences!.setBool(key, value);

  bool get isLoggedIn =>
      _sharedPreferences?.getBool(PrKeys.isLogin.name) ?? false;

  set isLoggedIn(bool value) {
    _sharedPreferences?.setBool(PrKeys.isLogin.name, value);
  }

  Future<bool> clear() async => await _sharedPreferences?.clear() ?? false;
}
