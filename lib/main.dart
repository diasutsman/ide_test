import 'package:flutter/material.dart';
import 'package:ide_test/pages/dashboard_page.dart';
import 'package:ide_test/pages/login_page.dart';
import 'package:ide_test/services/shared_preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferencesService.initialize();
  runApp(const BannerApp());
}

class BannerApp extends StatelessWidget {
  const BannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IDE Examination',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 102, 177, 122),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: SharedPreferencesService.isLoggedIn
          ? const DashboardPage()
          : const LoginPage(),
    );
  }
}
