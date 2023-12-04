import 'package:flutter/material.dart';
import 'package:ide_test/pages/add_banner_page.dart';
import 'package:ide_test/pages/login_page.dart';

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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
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
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                children: [
                  Text('Data 1'),
                  Text('Data 2'),
                  Text('Data 3'),
                  Text('Data 4'),
                  Text('Data 5'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
