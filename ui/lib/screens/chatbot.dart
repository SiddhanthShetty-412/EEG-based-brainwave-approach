import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final uploadIdController = TextEditingController();
  final controller = TextEditingController();
  List<Map<String, String>> messages = [];
  bool sending = false;
  String? error;

  Future<void> sendMessage() async {
    final uploadId = uploadIdController.text.trim();
    final question = controller.text.trim();
    if (uploadId.isEmpty || question.isEmpty) {
      setState(() => error = 'Enter upload id and a question');
      return;
    }

    setState(() {
      sending = true;
      error = null;
      messages.add({'role': 'user', 'text': question});
      controller.clear();
    });

    try {
      final url = Uri.parse('http://localhost:8000/ml/chat/$uploadId/');
      final resp = await http.post(url, body: json.encode({'question': question}), headers: {'Content-Type': 'application/json'});
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body) as Map<String, dynamic>;
        final answer = data['answer']?.toString() ?? 'No answer';
        setState(() {
          messages.add({'role': 'bot', 'text': answer});
        });
      } else {
        setState(() => error = 'Server error: ${resp.statusCode}');
      }
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Chatbot")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: uploadIdController,
                    decoration: InputDecoration(labelText: 'Upload ID', hintText: 'Enter upload id for context'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 72,
                  child: ElevatedButton(onPressed: () {}, child: Text('Set')),
                ),
              ],
            ),
          ),
          if (error != null) Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text(error!, style: TextStyle(color: Colors.red))),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(12),
              children: messages.map((m) {
                final isUser = m['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(color: isUser ? Colors.blue[100] : Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                    child: Text(m['text'] ?? ''),
                  ),
                );
              }).toList(),
            ),
          ),
          Row(
            children: [
              Expanded(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(controller: controller, decoration: InputDecoration(hintText: 'Ask a question...')),
              )),
              IconButton(
                icon: sending ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Icon(Icons.send),
                onPressed: sending ? null : sendMessage,
              )
            ],
          )
        ],
      ),
    );
  }
}
