import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF6EEFF), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              "Mental Health Summary",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('No summary available', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text('Upload an EEG file to see metrics and recommendations.', style: TextStyle(color: Colors.grey[700])),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
