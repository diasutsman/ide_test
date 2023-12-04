import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ide_test/models/login_model.dart';
import 'package:ide_test/services/shared_preferences_service.dart';

class IdeService {
  static const String baseUrl =
      "https://api-entrance-test.infraedukasi.com/api";
  static Future<void> login(String email, String password) async {
    const url = "$baseUrl/login";
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

    SharedPreferencesService.login(
      cliendId: loginModel.responseData.clientId,
      clientSecret: loginModel.responseData.clientSecret,
    );
  }
}
