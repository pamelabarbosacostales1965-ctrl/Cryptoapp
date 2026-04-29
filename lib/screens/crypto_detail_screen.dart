import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/db_helper.dart';
import '../models/favorite_model.dart';
import '../providers/crypto_provider.dart';

class CryptoDetailScreen extends ConsumerWidget {
  final String cryptoId;

  const CryptoDetailScreen({
    super.key,
    required this.cryptoId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cryptoAsync = ref.watch(cryptoDetailProvider(cryptoId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle'),
      ),
      body: cryptoAsync.when(
        data: (crypto) {
          final marketData = crypto['market_data'];
          final currentPrice = marketData['current_price']['usd'];
          final marketCap = marketData['market_cap']['usd'];
          final volume = marketData['total_volume']['usd'];
          final supply = marketData['circulating_supply'];
          final rank = crypto['market_cap_rank'];
          final priceChange =
              marketData['price_change_percentage_24h'] ?? 0.0;

          final description =
              crypto['description']['en'] ?? 'Sin descripción disponible.';

          final image = crypto['image']['large'];
          final name = crypto['name'];
          final symbol = crypto['symbol'].toString().toUpperCase();

          final bool isPositive = priceChange >= 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Hero(
                    tag: crypto['id'],
                    child: Image.network(
                      image,
                      height: 90,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Center(
                  child: Column(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        symbol,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _InfoRow(
                          title: 'Precio actual',
                          value: '\$$currentPrice',
                        ),
                        _InfoRow(
                          title: 'Cambio 24h',
                          value: '${priceChange.toStringAsFixed(2)}%',
                          valueColor: isPositive
                              ? Colors.greenAccent
                              : Colors.redAccent,
                        ),
                        _InfoRow(
                          title: 'Market Cap',
                          value: '\$$marketCap',
                        ),
                        _InfoRow(
                          title: 'Volumen 24h',
                          value: '\$$volume',
                        ),
                        _InfoRow(
                          title: 'Supply circulante',
                          value: supply != null
                              ? supply.toStringAsFixed(2)
                              : 'No disponible',
                        ),
                        _InfoRow(
                          title: 'Ranking global',
                          value: rank != null ? '#$rank' : 'No disponible',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.star),
                    label: const Text('Guardar en favoritos'),
                    onPressed: () async {
                      await DBHelper.insertFavorite(
                        Favorite(
                          id: crypto['id'],
                          name: name,
                          symbol: symbol,
                          image: image,
                        ),
                      );

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$name guardado en favoritos'),
                          ),
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Descripción',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  _cleanDescription(description),
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Error al cargar detalle:\n$error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  static String _cleanDescription(String htmlText) {
    return htmlText.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}