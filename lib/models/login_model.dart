class LoginModel {
  bool responseCode;
  String responseMessage;
  String responseSystemMessage;
  ResponseData responseData;

  LoginModel({
    required this.responseCode,
    required this.responseMessage,
    required this.responseSystemMessage,
    required this.responseData,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      responseCode: json['responseCode'] as bool,
      responseMessage: json['responseMessage'] as String,
      responseSystemMessage: json['responseSystemMessage'] as String,
      responseData:
          ResponseData.fromJson(json['responseData'] as Map<String, dynamic>),
    );
  }
}

class ResponseData {
  int id;
  String email;
  String name;
  String staticToken;
  bool isActive;
  String clientId;
  String clientSecret;

  ResponseData({
    required this.id,
    required this.email,
    required this.name,
    required this.staticToken,
    required this.isActive,
    required this.clientId,
    required this.clientSecret,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      staticToken: json['static_token'] as String,
      isActive: json['is_active'] as bool,
      clientId: json['client_id'] as String,
      clientSecret: json['client_secret'] as String,
    );
  }
}
