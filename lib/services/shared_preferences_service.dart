import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferences? _preferences;

  static const loggedInKey = 'logged_in';
  static const clientIdKey = 'client_id';
  static const clientIdSecretKey = 'client_secret';
  static const clientSecretKey = 'client_secret';
  static const accessTokenKey = 'access_token';
  static const refreshTokenKey = 'refresh_token';

  static Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> login({
    required String cliendId,
    required String clientSecret,
  }) async {
    await _preferences?.setBool(loggedInKey, true);
    await _preferences?.setString(clientIdKey, cliendId);
    await _preferences?.setString(clientIdSecretKey, clientSecret);
  }

  static Future<void> setAccessToken(String accessToken) async {
    await _preferences?.setString(accessTokenKey, accessToken);
  }

  static String getAccessToken() {
    return _preferences?.getString(accessTokenKey) ?? '';
  }

  static Future<void> setRefreshToken(String refreshtoken) async {
    await _preferences?.setString(refreshTokenKey, refreshtoken);
  }

  static String getRefreshToken() {
    return _preferences?.getString(refreshTokenKey) ?? '';
  }

  static T? get<T>(String key) {
    if (T == String) {
      return _preferences?.getString(key) as T?;
    } else if (T == int) {
      return _preferences?.getInt(key) as T?;
    } else if (T == double) {
      return _preferences?.getDouble(key) as T?;
    } else if (T == bool) {
      return _preferences?.getBool(key) as T?;
    }

    return _preferences?.get(key) as T?;
  }

  static Future<bool> set(String key, dynamic value) async {
    if (_preferences != null) {
      return false;
    }

    if (value is String) {
      await _preferences?.setString(key, value) ?? false;
    } else if (value is int) {
      await _preferences?.setInt(key, value) ?? false;
    } else if (value is double) {
      await _preferences?.setDouble(key, value) ?? false;
    } else if (value is bool) {
      await _preferences?.setBool(key, value) ?? false;
    }

    return false;
  }

  static Future<void> logout() async {
    await _preferences?.setBool(loggedInKey, false);
    await _preferences?.remove(clientIdKey);
    await _preferences?.remove(clientIdSecretKey);
  }

  static String get clientId {
    return _preferences?.getString(clientIdKey) ?? '';
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
