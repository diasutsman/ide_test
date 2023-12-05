import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferences? _preferences;

  static const loggedInKey = 'logged_in_key';
  static const cliendIdKey = 'client_id_key';
  static const clientIdSecretKey = 'client_secret_key';
  static const cliendSecretKey = 'client_secret_key';
  static const accessTokenKey = 'access_token_key';
  static const refreshTokenKey = 'refresh_token_key';

  static Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> login({
    required String cliendId,
    required String clientSecret,
  }) async {
    await _preferences?.setBool(loggedInKey, true);
    await _preferences?.setString(cliendIdKey, cliendIdKey);
    await _preferences?.setString(clientIdSecretKey, clientSecret);
  }

  static T get<T>(String key) {
    return _preferences?.get(key) as T;
  }

  static Future<bool> set(String key, dynamic value) async {
    if (_preferences != null) {
      return false;
    }

    if (value is String) {
      return await _preferences?.setString(key, value) ?? false;
    } else if (value is int) {
      return await _preferences?.setInt(key, value) ?? false;
    } else if (value is double) {
      return await _preferences?.setDouble(key, value) ?? false;
    } else if (value is bool) {
      return await _preferences?.setBool(key, value) ?? false;
    }

    return false;
  }

  static Future<void> logout() async {
    await _preferences?.setBool(loggedInKey, false);
    await _preferences?.remove(cliendIdKey);
    await _preferences?.remove(clientIdSecretKey);
  }

  static String get clientId {
    return _preferences?.getString(cliendIdKey) ?? '';
  }

  static String get clientSecret {
    return _preferences?.getString(clientIdSecretKey) ?? '';
  }

  static bool get isLoggedIn {
    return _preferences?.getBool(loggedInKey) ?? false;
  }

  static Future<bool> clear() async {
    return await _preferences?.clear() ?? false;
  }
}
