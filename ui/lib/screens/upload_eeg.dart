import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UploadEEGPage extends StatefulWidget {
  @override
  _UploadEEGPageState createState() => _UploadEEGPageState();
}

class _UploadEEGPageState extends State<UploadEEGPage> {
  String fileName = "No file selected";
  PlatformFile? pickedFile;

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        pickedFile = result.files.single;
        fileName = pickedFile?.name ?? "No file selected";
      });
    }
  }

  Future<void> uploadFile() async {
    if (pickedFile == null) return;

    final uri = Uri.parse('http://localhost:8000/api/upload/');
    final request = http.MultipartRequest('POST', uri);

    if (pickedFile!.bytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes('edf_file', pickedFile!.bytes!, filename: pickedFile!.name),
      );
    } else if (pickedFile!.path != null) {
      request.files.add(await http.MultipartFile.fromPath('edf_file', pickedFile!.path!));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not read selected file.')));
      return;
    }

    try {
      final streamed = await request.send();
      final resp = await http.Response.fromStream(streamed);

      if (resp.statusCode == 200) {
        final body = json.decode(resp.body);
        final result = body['result'];
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Analysis complete'),
            content: Text('Prediction: ${result['label']}\nProbability: ${result['probability']}'),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
          ),
        );
      } else {
        final body = resp.body.isNotEmpty ? json.decode(resp.body) : null;
        final err = body != null && body['error'] != null ? body['error'] : resp.reasonPhrase;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $err')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload EEG Data")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(fileName),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Select File"),
              onPressed: pickFile,
            ),
            ElevatedButton(
              child: Text("Analyze"),
              onPressed: uploadFile,
            )
          ],
        ),
      ),
    );
  }
}
