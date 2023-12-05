class OauthTokenModel {
  String tokenType;
  int expiresIn;
  String accessToken;
  String refreshToken;

  OauthTokenModel({
    required this.tokenType,
    required this.expiresIn,
    required this.accessToken,
    required this.refreshToken,
  });

  factory OauthTokenModel.fromJson(Map<String, dynamic> json) {
    return OauthTokenModel(
      tokenType: json['token_type'] as String,
      expiresIn: json['expires_in'] as int,
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );
  }
}
