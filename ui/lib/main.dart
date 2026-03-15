import 'package:flutter/material.dart';
import 'screens/landing_page.dart';
import 'screens/login_page.dart';
import 'screens/dashboard.dart';
import 'screens/upload_eeg.dart';
import 'screens/visualization.dart';
import 'screens/chatbot.dart';
import 'screens/report.dart';
import 'screens/register_page.dart';

void main() {
  runApp(NeuroShieldApp());
}

class NeuroShieldApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NeuroShield",
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: Color(0xFF6C4AE3),
        scaffoldBackgroundColor: Color(0xFFF7F3FF),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: Color(0xFF6C4AE3),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/dashboard': (context) => Dashboard(),
        '/upload': (context) => UploadEEGPage(),
        '/visualization': (context) => VisualizationPage(),
        '/chatbot': (context) => ChatbotPage(),
        '/report': (context) => ReportPage(),
      },
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF7F3FF), Color(0xFFFFFFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: child ?? SizedBox.shrink(),
        );
      },
      // No global builder: keep default Overlay/Navigator provided by MaterialApp
    );
  }
}
