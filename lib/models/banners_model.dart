class BannersModel {
  bool responseCode;
  String responseMessage;
  String responseSystemMessage;
  List<BannerData> responseData;

  BannersModel({
    required this.responseCode,
    required this.responseMessage,
    required this.responseSystemMessage,
    required this.responseData,
  });

  factory BannersModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> bannersData = json['responseData'] as List<dynamic>;
    List<BannerData> bannersList =
        bannersData.map((data) => BannerData.fromJson(data)).toList();

    return BannersModel(
      responseCode: json['responseCode'] as bool,
      responseMessage: json['responseMessage'] as String,
      responseSystemMessage: json['responseSystemMessage'] as String,
      responseData: bannersList,
    );
  }
}

class BannerData {
  String bannerName;
  String bannerImage;
  bool isActive;

  BannerData({
    required this.bannerName,
    required this.bannerImage,
    required this.isActive,
  });

  factory BannerData.fromJson(Map<String, dynamic> json) {
    return BannerData(
      bannerName: json['banner_name'] as String,
      bannerImage: json['banner_image'] as String,
      isActive: json['is_active'] as bool,
    );
  }
}