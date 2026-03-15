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
  runApp(const NeuroShieldApp());
}

class NeuroShieldApp extends StatelessWidget {
  const NeuroShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NeuroShield",
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C4AE3),
          brightness: Brightness.light,
        ),

        scaffoldBackgroundColor: const Color(0xFFF6F5FF),

        fontFamily: "Roboto",

        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
        ),

        cardTheme: CardThemeData(
          elevation: 6,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 4,
            padding: const EdgeInsets.symmetric(vertical: 14),
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: const Color(0xFF6C4AE3),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      initialRoute: '/',

      routes: {
        '/': (context) =>  LandingPage(),
        '/login': (context) =>  LoginPage(),
        '/register': (context) =>  RegisterPage(),
        '/dashboard': (context) =>  Dashboard(),
        '/upload': (context) =>  UploadEEGPage(),
        '/visualization': (context) =>  VisualizationPage(),
        '/chatbot': (context) =>  ChatbotPage(),
        '/report': (context) =>  ReportPage(),
      },

      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF7F3FF),
                Color(0xFFEFE9FF),
                Color(0xFFFFFFFF),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}