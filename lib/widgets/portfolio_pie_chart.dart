import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/portfolio_model.dart';

class PortfolioPieChart extends StatelessWidget {
  final List<PortfolioItem> items;

  const PortfolioPieChart({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Text('No hay datos para mostrar');
    }

    return SizedBox(
      height: 220,
      child: PieChart(
        PieChartData(
          sections: items.map((item) {
            final value = item.amount * item.buyPrice;

            return PieChartSectionData(
              value: value,
              title: item.symbol.toUpperCase(),
              radius: 70,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}