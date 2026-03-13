import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30),
            Text(
              "Mental Health Summary",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Card(
              child: ListTile(
                title: Text("Focus Level"),
                trailing: Text("78%"),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Stress Level"),
                trailing: Text("Moderate"),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Upload EEG"),
              onPressed: () {
                Navigator.pushNamed(context, '/upload');
              },
            ),
            ElevatedButton(
              child: Text("View Visualization"),
              onPressed: () {
                Navigator.pushNamed(context, '/visualization');
              },
            ),
            ElevatedButton(
              child: Text("Chatbot"),
              onPressed: () {
                Navigator.pushNamed(context, '/chatbot');
              },
            ),
            ElevatedButton(
              child: Text("Generate Report"),
              onPressed: () {
                Navigator.pushNamed(context, '/report');
              },
            )
          ],
        ),
      ),
    );
  }
}
