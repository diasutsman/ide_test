import 'package:flutter/material.dart';
import 'package:ide_test/models/banners_model.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({
    super.key,
    required this.bannerData,
  });

  final BannerData bannerData;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.white,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(bannerData.bannerImage),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bannerData.bannerName,
                  style: const TextStyle(fontSize: 24),
                ),
                Text(
                  bannerData.isActive ? "Aktif" : "Tidak Aktif",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
