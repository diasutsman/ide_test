import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ide_test/models/login_model.dart';
import 'package:ide_test/models/oauth_token_model.dart';
import 'package:ide_test/services/shared_preferences_service.dart';

class IdeService {
  static const String baseUrl =
      "https://api-entrance-test.infraedukasi.com";

  static Future<void> login({
    required String email,
    required String password,
  }) async {
    const url = "$baseUrl/api/login";

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode != 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      return Future.error(responseJson['responseSystemMessage']);
    }

    Map<String, dynamic> responseJson = jsonDecode(response.body);

    final loginModel = LoginModel.fromJson(responseJson);

    await SharedPreferencesService.login(
      cliendId: loginModel.responseData.clientId,
      clientSecret: loginModel.responseData.clientSecret,
    );

    oauthToken(
      username: email,
      password: password,
      clientId: loginModel.responseData.clientId,
      clientSecret: loginModel.responseData.clientSecret,
    );
  }

  static Future<void> oauthToken({
    required String username,
    required String password,
    required String clientId,
    required String clientSecret,
    String grantType = "password",
    String scope = "*",
  }) async {
    const url = "$baseUrl/oauth/token";
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username": username,
        "password": password,
        "client_id": clientId,
        "client_secret": clientSecret,
        "grant_type": grantType,
        "scope": scope,
      }),
    );

    print(response.body);

    if (response.statusCode != 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      return Future.error(responseJson['message']);
    }

    Map<String, dynamic> responseJson = jsonDecode(response.body);

    final oauthTokenModel = OauthTokenModel.fromJson(responseJson);

    SharedPreferencesService.set(
      SharedPreferencesService.accessTokenKey,
      oauthTokenModel.accessToken,
    );

    SharedPreferencesService.set(
      SharedPreferencesService.refreshTokenKey,
      oauthTokenModel.refreshToken,
    );
  }
}
