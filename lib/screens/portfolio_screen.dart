import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/portfolio_model.dart';
import '../widgets/portfolio_pie_chart.dart';
import '../widgets/price_line_chart.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  List<PortfolioItem> items = [];

  final nameController = TextEditingController();
  final symbolController = TextEditingController();
  final amountController = TextEditingController();
  final priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPortfolio();
  }

  //carga las compras guardadas en SQLite
  Future<void> loadPortfolio() async {
    final data = await DBHelper.getPortfolio();
    setState(() {
      items = data;
    });
  }

  //agrega una nueva compra al portafolio
  Future<void> addItem() async {
    final item = PortfolioItem(
      cryptoId: symbolController.text.toLowerCase(),
      name: nameController.text,
      symbol: symbolController.text,
      amount: double.parse(amountController.text),
      buyPrice: double.parse(priceController.text),
    );

    await DBHelper.insertPortfolioItem(item);

    nameController.clear();
    symbolController.clear();
    amountController.clear();
    priceController.clear();

    loadPortfolio();
  }

  //calcula el total invertido
  double get totalInvertido {
    double total = 0;
    for (var item in items) {
      total += item.amount * item.buyPrice;
    }
    return total;
  }

  //ventana para ingresar una compra
  void showAddDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Agregar compra'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: symbolController,
                decoration: const InputDecoration(labelText: 'Simbolo'),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cantidad'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Precio de compra'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                addItem();
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portafolio'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              title: const Text('Total invertido'),
              subtitle: Text('\$${totalInvertido.toStringAsFixed(2)}'),
              
            ),
          ),

          //Grafica de linea (datos de prueba)
          Padding(
            padding: const EdgeInsets.all(12),
            child: PriceLineChart(
              prices: [100, 120, 110, 150, 130, 170, 160], // datos fake
            ),
          ),

          //gráfica de torta del portafolio
          Padding(
            padding: const EdgeInsets.all(12),
            child: PortfolioPieChart(items: items),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, index) {
                final item = items[index];

                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('${item.amount} ${item.symbol.toUpperCase()}'),
                  trailing: Text(
                    '\$${(item.amount * item.buyPrice).toStringAsFixed(2)}',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}