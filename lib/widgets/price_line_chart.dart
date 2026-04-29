import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PriceLineChart extends StatelessWidget {
  final List<double> prices;

  const PriceLineChart({
    super.key,
    required this.prices,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              //convierte la lista de precios en puntos para la grafica
              spots: List.generate(
                prices.length,
                (index) => FlSpot(index.toDouble(), prices[index]),
              ),
              isCurved: true,
              barWidth: 3,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}