import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final idController = TextEditingController();
  Map<String, dynamic>? report;
  String? error;
  bool loading = false;

  Future<void> fetchReport() async {
    final id = idController.text.trim();
    if (id.isEmpty) {
      setState(() => error = 'Please enter an upload id');
      return;
    }

    setState(() {
      loading = true;
      error = null;
      report = null;
    });

    try {
      final url = Uri.parse('http://localhost:8000/ml/report/$id/');
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        setState(() {
          report = json.decode(resp.body) as Map<String, dynamic>;
        });
      } else {
        setState(() {
          error = 'Server returned ${resp.statusCode}';
        });
      }
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mental Health Report")),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFF3E8FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: idController,
                    decoration: InputDecoration(labelText: 'Upload ID', hintText: 'Enter upload id'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 12),
                SizedBox(
                  width: 80,
                  child: ElevatedButton(
                    onPressed: loading ? null : fetchReport,
                    child: loading ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : Text('Load'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (error != null) ...[
              Text(error!, style: TextStyle(color: Colors.red)),
            ] else if (report == null) ...[
              Text('No report loaded', style: TextStyle(fontSize: 18)),
              SizedBox(height: 12),
              Text('Enter an upload id and press Load to fetch a report.', style: TextStyle(color: Colors.grey[700])),
            ] else ...[
              Text('File', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(report!['file_name'] ?? 'Unknown'),
              SizedBox(height: 12),
              Text('Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text(report!['status'] ?? 'N/A'),
              SizedBox(height: 12),
              Text('Prediction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text(report!['predicted_label']?.toString() ?? 'N/A'),
              if (report!['probability'] != null) Text('Probability: ${report!['probability']}'),
              SizedBox(height: 12),
              Text('Feature Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              if (report!['features_summary'] is Map)
                ...((report!['features_summary'] as Map).entries.map((e) => Text('• ${e.key}: ${e.value}')))
              else
                Text(report!['features_summary']?.toString() ?? ''),
            ]
          ],
        ),
      ),
    );
  }
}
