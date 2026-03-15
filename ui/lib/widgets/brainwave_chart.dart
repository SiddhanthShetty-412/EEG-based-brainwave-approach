import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BrainwaveChart extends StatelessWidget {
  final List<FlSpot> spots;

  BrainwaveChart({this.spots = const []});

  @override
  Widget build(BuildContext context) {
    if (spots.isEmpty) {
      return Center(
        child: Text(
          'No EEG data available. Upload an EEG file to visualize.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[700]),
        ),
      );
    }

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Theme.of(context).primaryColor,
            barWidth: 2,
          )
        ],
        titlesData: FlTitlesData(show: false),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
