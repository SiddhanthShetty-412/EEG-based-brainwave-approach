import 'package:flutter/material.dart';
import 'screens/landing_page.dart';
import 'screens/login_page.dart';
import 'screens/dashboard.dart';
import 'screens/upload_eeg.dart';
import 'screens/visualization.dart';
import 'screens/chatbot.dart';
import 'screens/report.dart';

void main() {
  runApp(NeuroShieldApp());
}

class NeuroShieldApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NeuroShield",
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/login': (context) => LoginPage(),
        '/dashboard': (context) => Dashboard(),
        '/upload': (context) => UploadEEGPage(),
        '/visualization': (context) => VisualizationPage(),
        '/chatbot': (context) => ChatbotPage(),
        '/report': (context) => ReportPage(),
      },
    );
  }
}
