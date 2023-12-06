import 'package:flutter/material.dart';
import 'package:ide_test/models/banners_model.dart';
import 'package:ide_test/pages/add_banner_page.dart';
import 'package:ide_test/pages/login_page.dart';
import 'package:ide_test/services/ide_service.dart';
import 'package:ide_test/services/shared_preferences_service.dart';
import 'package:ide_test/widgets/banner_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banners'),
        actions: [
          IconButton(
            onPressed: () {
              SharedPreferencesService.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Row(
          children: [Icon(Icons.add), Text("Add Banner")],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBannerPage()),
          );
        },
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: IdeService.listBanner(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
        
            if (snapshot.hasError) {
              return const Center(
                child: Text("Terjadi Error"),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                BannerData bannerData = snapshot.data?[index] as BannerData;
                return BannerWidget(bannerData: bannerData);
              },
              itemCount: snapshot.data?.length,
            );
          },
        ),
      ),
    );
  }
}
