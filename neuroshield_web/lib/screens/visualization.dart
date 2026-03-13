import 'package:flutter/material.dart';
import '../widgets/brainwave_chart.dart';

class VisualizationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("EEG Visualization")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Brainwave Signal",
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 20),
            Expanded(
              child: BrainwaveChart(),
            )
          ],
        ),
      ),
    );
  }
}
