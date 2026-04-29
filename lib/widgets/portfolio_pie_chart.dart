import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/portfolio_model.dart';

class PortfolioPieChart extends StatelessWidget {
  final List<PortfolioItem> items;
  final Map<String, double> currentPrices;

  const PortfolioPieChart({
    super.key,
    required this.items,
    required this.currentPrices,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Text('No hay datos para mostrar');
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 260,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 45,
              sections: items.map((item) {
                final currentPrice =
                    currentPrices[item.cryptoId] ?? item.buyPrice;

                final value = item.amount * currentPrice;

                return PieChartSectionData(
                  value: value,
                  title: item.symbol.toUpperCase(),
                  radius: 80,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}