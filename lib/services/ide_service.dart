import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:ide_test/models/banners_model.dart';
import 'package:ide_test/models/login_model.dart';
import 'package:ide_test/models/oauth_token_model.dart';
import 'package:ide_test/services/shared_preferences_service.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';

class IdeService {
  static const String baseUrl = "https://api-entrance-test.infraedukasi.com";

  static String _encodeMap(Map data) {
    return data.keys.map((key) => "$key=${data[key]}").join("&");
  }

  static Map<String, String> getHeaders({
    required String path,
    required String verb,
    dynamic body = '',
  }) {
    final accessToken = SharedPreferencesService.get<String>(
      SharedPreferencesService.accessTokenKey,
    ).toString();

    final clientId = SharedPreferencesService.get<String>(
      SharedPreferencesService.clientIdKey,
    ).toString();

    final clientSecret = SharedPreferencesService.get<String>(
      SharedPreferencesService.clientSecretKey,
    ).toString();

    final timestamp = DateTime.now().toUtc().toIso8601String();

    final signature = generateSignature(
      token: 'Bearer $accessToken',
      timestamp: timestamp,
      userSecret: clientSecret,
      path: path,
      verb: verb,
      body: body,
    );

    return <String, String>{
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $accessToken',
      'IDE-Timestamp': timestamp,
      'Client-ID': clientId,
      'IDE-Signature': signature,
    };
  }

  static String generateSignature({
    required String path,
    required String verb,
    dynamic body,
    required String token,
    required String timestamp,
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
      headers: {
        'Content-Type': 'application/json',
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
      headers: {
        'Content-Type': 'application/json',
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

    if (response.statusCode != 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      return Future.error(responseJson['message']);
    }

    Map<String, dynamic> responseJson = jsonDecode(response.body);

    final oauthTokenModel = OauthTokenModel.fromJson(responseJson);

    await SharedPreferencesService.setAccessToken(oauthTokenModel.accessToken);

    await SharedPreferencesService.setRefreshToken(
      oauthTokenModel.refreshToken,
    );
  }

  static Future<List<BannerData>> listBanner() async {
    const path = '/list-banner';
    const url = "$baseUrl/api$path";
    const verb = 'GET';

    final response = await http.get(
      Uri.parse(url),
      headers: getHeaders(path: path, verb: verb),
    );

    if (response.statusCode != 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      return Future.error(responseJson['responseSystemMessage']);
    }

    Map<String, dynamic> responseJson = jsonDecode(response.body);

    final bannerModel = BannersModel.fromJson(responseJson);

    return bannerModel.responseData;
  }

  static Future<void> addBanner({
    required String bannerName,
    required String bannerPath,
  }) async {
    const path = '/add-banner';
    const url = "$baseUrl/api$path";
    const verb = 'POST';

    final headers = getHeaders(
      path: path,
      verb: verb,
      //TODO: Find a way to get request body that being sent by `MultipartRequest` class
      body: '',
    );

    final request = http.MultipartRequest(verb, Uri.parse(url));

    request.headers.addAll(headers);
    request.fields['banner_name'] = bannerName;
    request.files.add(
      await http.MultipartFile.fromPath(
        'banner_image',
        bannerPath,
        filename: basename(bannerPath),
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    final response = await http.Response.fromStream(await request.send());

    final responseString = response.body;

    if (response.statusCode != 200) {
      Map<String, dynamic> responseJson = jsonDecode(responseString);
      return Future.error(
        responseJson['responseSystemMessage'] != ''
            ? responseJson['responseSystemMessage']
            : responseJson['responseMessage'],
      );
    }
  }
}
