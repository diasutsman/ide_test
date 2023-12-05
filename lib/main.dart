import 'package:flutter/material.dart';
import 'package:ide_test/pages/dashboard_page.dart';
import 'package:ide_test/pages/login_page.dart';
import 'package:ide_test/services/shared_preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferencesService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IDE Examination',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: SharedPreferencesService.isLoggedIn
          ? DashboardPage()
          : const LoginPage(),
    );
  }
}
