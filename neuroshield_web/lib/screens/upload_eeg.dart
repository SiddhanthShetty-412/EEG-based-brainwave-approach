import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadEEGPage extends StatefulWidget {
  @override
  _UploadEEGPageState createState() => _UploadEEGPageState();
}

class _UploadEEGPageState extends State<UploadEEGPage> {
  String fileName = "No file selected";

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
      });
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
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
