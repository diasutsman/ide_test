import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:ide_test/models/login_model.dart';
import 'package:ide_test/models/oauth_token_model.dart';
import 'package:ide_test/services/shared_preferences_service.dart';
import 'package:crypto/crypto.dart';

class IdeService {
  static const String baseUrl = "https://api-entrance-test.infraedukasi.com";

  static String _encodeMap(Map data) {
    return data.keys.map((key) => "$key=${data[key]}").join("&");
  }

  static String generateSignature({
    required String path,
    required String verb,
    required String token,
    required String timestamp,
    required String body,
    required String userSecret,
  }) {
    String base64Key = base64Encode(utf8.encode(userSecret));
    String message = _encodeMap({
      'path': path,
      'verb': verb.toUpperCase(),
      'token': token,
      'timestamp': timestamp,
      'body': body,
    });

    print("Payload: $message");

    List<int> messageBytes = utf8.encode(message);
    List<int> key = base64.decode(base64Key);
    Hmac hmac = Hmac(sha256, key);
    Digest digest = hmac.convert(messageBytes);

    String base64Mac = base64.encode(digest.bytes);
    return base64Mac;
  }

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

    await oauthToken(
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

    print('accessToken: ${oauthTokenModel.accessToken}');
    print('refreshToken: ${oauthTokenModel.refreshToken}');

    await SharedPreferencesService.setAccessToken(oauthTokenModel.accessToken);

    await SharedPreferencesService.setRefreshToken(
      oauthTokenModel.refreshToken,
    );

    // ! for testingc
    // final accessTokenC = SharedPreferencesService.get<String>(
    //   SharedPreferencesService.accessTokenKey,
    // );

    // final clientIdC = SharedPreferencesService.get<String>(
    //   SharedPreferencesService.clientIdKey,
    // );

    // final clientSecretC = SharedPreferencesService.get<String>(
    //   SharedPreferencesService.clientSecretKey,
    // );

    // print("oauthToken");
    // print('accessToken $accessTokenC');
    // print('clientId $clientIdC');
    // print('clientSecret $clientSecretC');
  }

  static Future<void> listBanner() async {
    const url = "$baseUrl/api/list-banner";
    print("listBanner");
    print("url: $url");
    final accessToken = SharedPreferencesService.get<String>(
      SharedPreferencesService.accessTokenKey,
    ).toString();

    final clientId = SharedPreferencesService.get<String>(
      SharedPreferencesService.clientIdKey,
    ).toString();

    final refreshToken = SharedPreferencesService.get<String>(
      SharedPreferencesService.refreshTokenKey,
    ).toString();

    final clientSecret = SharedPreferencesService.get<String>(
      SharedPreferencesService.clientSecretKey,
    ).toString();

    final timestamp = DateTime.now().toUtc().toIso8601String();

    print('accessToken: $accessToken');
    print('clientId: $clientId');
    print('clientSecret: $clientSecret');
    print('refreshToken: $refreshToken');

    final signature = generateSignature(
      path: '/list-banner',
      verb: 'GET',
      token: 'Bearer $accessToken',
      timestamp: timestamp,
      body: '',
      userSecret: clientSecret,
    );

    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
      'IDE-Timestamp': timestamp,
      'Client-ID': clientId,
      'IDE-Signature': signature,
    };

    print("headers: ${headers['IDE-Timestamp']}");

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print("response: ${response.body}");

    if (response.statusCode != 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      return Future.error(responseJson['message']);
    }
  }
}
