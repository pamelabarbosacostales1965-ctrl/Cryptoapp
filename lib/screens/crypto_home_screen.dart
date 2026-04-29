import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/crypto_provider.dart';
import 'crypto_detail_screen.dart';
import 'favorites_screen.dart';
import 'portfolio_screen.dart';

class CryptoHomeScreen extends ConsumerStatefulWidget {
  const CryptoHomeScreen({super.key});

  @override
  ConsumerState<CryptoHomeScreen> createState() => _CryptoHomeScreenState();
}

class _CryptoHomeScreenState extends ConsumerState<CryptoHomeScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final cryptoAsync = ref.watch(cryptoListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CryptoApp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoritesScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.pie_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PortfolioScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar criptomoneda...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          Expanded(
            child: cryptoAsync.when(
              data: (cryptos) {
                final filteredCryptos = cryptos.where((crypto) {
                  final name = crypto['name'].toString().toLowerCase();
                  final symbol = crypto['symbol'].toString().toLowerCase();

                  return name.contains(searchQuery) ||
                      symbol.contains(searchQuery);
                }).toList();

                if (filteredCryptos.isEmpty) {
                  return const Center(
                    child: Text('No se encontraron criptomonedas'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(cryptoListProvider);
                  },
                  child: ListView.builder(
                    itemCount: filteredCryptos.length,
                    itemBuilder: (context, index) {
                      final crypto = filteredCryptos[index];

                      final priceChange =
                          crypto['price_change_percentage_24h'] ?? 0.0;

                      final bool isPositive = priceChange >= 0;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: Hero(
                            tag: crypto['id'],
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(crypto['image']),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          title: Text(
                            crypto['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            crypto['symbol'].toString().toUpperCase(),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${crypto['current_price']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${priceChange.toStringAsFixed(2)}%',
                                style: TextStyle(
                                  color: isPositive
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CryptoDetailScreen(
                                  cryptoId: crypto['id'],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
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
                    'Error al cargar criptomonedas:\n$error',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}