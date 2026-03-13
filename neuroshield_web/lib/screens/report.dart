import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mental Health Report")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Focus Level: 75%", style: TextStyle(fontSize: 18)),
            Text("Stress Level: Moderate", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text("Recommendations", style: TextStyle(fontSize: 20)),
            Text("• Take regular breaks"),
            Text("• Meditation"),
            Text("• Sleep improvement"),
          ],
        ),
      ),
    );
  }
}
