import 'package:flutter/material.dart';

import '../database/db_helper.dart';
import '../models/portfolio_model.dart';
import '../services/crypto_service.dart';
import '../widgets/portfolio_pie_chart.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  List<PortfolioItem> items = [];
  Map<String, double> currentPrices = {};

  bool isLoading = true;
  String? errorMessage;

  final cryptoIdController = TextEditingController();
  final nameController = TextEditingController();
  final symbolController = TextEditingController();
  final amountController = TextEditingController();
  final priceController = TextEditingController();

  final CryptoService cryptoService = CryptoService();

  @override
  void initState() {
    super.initState();
    loadPortfolio();
  }

  @override
  void dispose() {
    cryptoIdController.dispose();
    nameController.dispose();
    symbolController.dispose();
    amountController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> loadPortfolio() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final data = await DBHelper.getPortfolio();

      final ids = data
          .map((item) => item.cryptoId.toLowerCase().trim())
          .where((id) => id.isNotEmpty)
          .toList();

      final prices = await cryptoService.getCurrentPricesByIds(ids);

      setState(() {
        items = data;
        currentPrices = prices;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error al cargar precios reales: $e';
        isLoading = false;
      });
    }
  }

  Future<void> addItem() async {
    final cryptoId = cryptoIdController.text.trim().toLowerCase();
    final name = nameController.text.trim();
    final symbol = symbolController.text.trim().toUpperCase();
    final amount = double.tryParse(amountController.text.trim());
    final buyPrice = double.tryParse(priceController.text.trim());

    if (cryptoId.isEmpty ||
        name.isEmpty ||
        symbol.isEmpty ||
        amount == null ||
        buyPrice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa todos los campos correctamente'),
        ),
      );
      return;
    }

    final item = PortfolioItem(
      cryptoId: cryptoId,
      name: name,
      symbol: symbol,
      amount: amount,
      buyPrice: buyPrice,
    );

    await DBHelper.insertPortfolioItem(item);

    cryptoIdController.clear();
    nameController.clear();
    symbolController.clear();
    amountController.clear();
    priceController.clear();

    await loadPortfolio();
  }

  Future<void> deleteItem(int id) async {
    await DBHelper.deletePortfolioItem(id);
    await loadPortfolio();
  }

  Future<void> confirmDeleteItem(PortfolioItem item) async {
    if (item.id == null) return;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Eliminar registro'),
          content: Text(
            '¿Seguro que quieres eliminar ${item.name} del portafolio?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await deleteItem(item.id!);
    }
  }

  double get totalInvertido {
    return items.fold(0, (total, item) {
      return total + (item.amount * item.buyPrice);
    });
  }

  double get valorActual {
    return items.fold(0, (total, item) {
      final currentPrice = currentPrices[item.cryptoId] ?? item.buyPrice;
      return total + (item.amount * currentPrice);
    });
  }

  double get gananciaPerdida {
    return valorActual - totalInvertido;
  }

  void showAddDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Agregar compra'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: cryptoIdController,
                  decoration: const InputDecoration(
                    labelText: 'ID CoinGecko',
                    hintText: 'bitcoin, ethereum, solana',
                  ),
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Bitcoin',
                  ),
                ),
                TextField(
                  controller: symbolController,
                  decoration: const InputDecoration(
                    labelText: 'Símbolo',
                    hintText: 'BTC',
                  ),
                ),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad',
                    hintText: '0.5',
                  ),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Precio de compra',
                    hintText: '30000',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await addItem();

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  String formatMoney(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final isProfit = gananciaPerdida >= 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Portafolio'),
        actions: [
          IconButton(
            onPressed: loadPortfolio,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : items.isEmpty
                  ? const Center(
                      child: Text('No hay compras registradas'),
                    )
                  : RefreshIndicator(
                      onRefresh: loadPortfolio,
                      child: ListView(
                        padding: const EdgeInsets.all(12),
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Total invertido'),
                                  Text(
                                    formatMoney(totalInvertido),
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text('Valor actual con API'),
                                  Text(
                                    formatMoney(valorActual),
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text('Ganancia / pérdida'),
                                  Text(
                                    formatMoney(gananciaPerdida),
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: isProfit
                                          ? Colors.greenAccent
                                          : Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          PortfolioPieChart(
                            items: items,
                            currentPrices: currentPrices,
                          ),
                          const SizedBox(height: 16),
                          ...items.map((item) {
                            final currentPrice =
                                currentPrices[item.cryptoId] ?? item.buyPrice;

                            final invested = item.amount * item.buyPrice;
                            final currentValue = item.amount * currentPrice;
                            final profitLoss = currentValue - invested;
                            final profit = profitLoss >= 0;

                            return Card(
                              child: ListTile(
                                title: Text(item.name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item.amount} ${item.symbol.toUpperCase()}',
                                    ),
                                    Text(
                                      'Compra: ${formatMoney(item.buyPrice)}',
                                    ),
                                    Text(
                                      'Actual API: ${formatMoney(currentPrice)}',
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          formatMoney(currentValue),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          formatMoney(profitLoss),
                                          style: TextStyle(
                                            color: profit
                                                ? Colors.greenAccent
                                                : Colors.redAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: () {
                                        confirmDeleteItem(item);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
    );
  }
}