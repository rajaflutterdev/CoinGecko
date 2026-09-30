import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../core/constant/string_varibles.dart';

class MarketChart extends StatelessWidget {
  final List<double> prices;

  const MarketChart({
    super.key,
    required this.prices,
  });

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty) {
      return  SizedBox(
        height: 250,
        child: Center(
          child: Text(noChartData),
        ),
      );
    }

    final spots = <FlSpot>[];

    for (int i = 0; i < prices.length; i++) {
      spots.add(
        FlSpot(
          i.toDouble(),
          prices[i],
        ),
      );
    }

    return SizedBox(
      height: 260,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(
            enabled: true,
          ),

          lineBarsData: [
            LineChartBarData(
              color:  Colors.green,
              spots: spots,
              isCurved: true,
              barWidth: 2,
              dotData: const FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.black38
              ),
            ),
          ],
        ),
      ),
    );
  }
}