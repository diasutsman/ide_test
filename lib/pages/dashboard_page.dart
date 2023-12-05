import 'package:flutter/material.dart';
import 'package:ide_test/models/banners_model.dart';
import 'package:ide_test/pages/add_banner_page.dart';
import 'package:ide_test/pages/login_page.dart';
import 'package:ide_test/services/ide_service.dart';
import 'package:ide_test/services/shared_preferences_service.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'add_banner') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddBannerPage()),
                );
              } else if (value == 'logout') {
                SharedPreferencesService.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'add_banner',
                  child: ListTile(
                    title: Text('Add Banner'),
                    leading: Icon(Icons.add),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: ListTile(
                    title: Text('Logout'),
                    leading: Icon(Icons.exit_to_app),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Expanded(
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
                        BannerData bannerData =
                            snapshot.data?[index] as BannerData;
                        return Card(
                          elevation: 8,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(bannerData.bannerImage),
                                Text(
                                  bannerData.bannerName,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                Text(
                                  bannerData.isActive ? "Aktif" : "Tidak Aktif",
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: snapshot.data?.length,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
