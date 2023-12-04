import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferences? _preferences;

  static const _loggedInKey = 'logged_in_key';
  static const _cliendIdKey = 'client_id_key';
  static const _cliendSecretKey = 'client_secret_key';

  static Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> login({
    required String cliendId,
    required String clientSecret,
  }) async {
    await _preferences?.setBool(_loggedInKey, true);
    await _preferences?.setString(_cliendIdKey, _cliendIdKey);
    await _preferences?.setString(_cliendSecretKey, clientSecret);
  }

  static Future<void> logout() async {
    await _preferences?.setBool(_loggedInKey, false);
    await _preferences?.remove(_cliendIdKey);
    await _preferences?.remove(_cliendSecretKey);
  }

  static String get clientId {
    return _preferences?.getString(_cliendIdKey) ?? '';
  }

  static String get clientSecret {
    return _preferences?.getString(_cliendSecretKey) ?? '';
  }

  static bool get isLoggedIn {
    return _preferences?.getBool(_loggedInKey) ?? false;
  }

  static Future<bool> clear() async {
    return await _preferences?.clear() ?? false;
  }
}
