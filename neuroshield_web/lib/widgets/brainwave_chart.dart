import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BrainwaveChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 1),
              FlSpot(1, 3),
              FlSpot(2, 2),
              FlSpot(3, 4),
              FlSpot(4, 3),
            ],
            isCurved: true,
          )
        ],
      ),
    );
  }
}
