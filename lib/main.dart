import 'package:flutter/material.dart';
import 'screens/favorites_screen.dart';
import 'screens/portfolio_screen.dart';
import 'database/db_helper.dart';
import 'models/favorite_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CryptoApp',

      //tema sencillo oscuro como app de criptos
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),

      home: const HomeScreen(),
    );
  }
}

//Pantalla principal
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  //datos de prueba para guardar una favorita
  Future<void> addFavoriteTest() async {
    //Esto se agregará después cuando se conecte con la API del integrante 1
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CryptoApp'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //Boton para ir a favoritos
            Card(
              child: ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Favoritos'),
                subtitle: const Text('Ver criptomonedas guardadas'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FavoritesScreen(),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 12),

            //Boton para ir al portafolio
            Card(
              child: ListTile(
                leading: const Icon(Icons.pie_chart),
                title: const Text('Portafolio'),
                subtitle: const Text('Registrar compras y ver gráfica'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PortfolioScreen(),
                    ),
                  );
                },
              ),
            ),
            
            ElevatedButton(
                onPressed: () async {
                  await DBHelper.insertFavorite(
                    Favorite(
                      id: 'bitcoin',
                      name: 'Bitcoin',
                      symbol: 'btc',
                      image: 'https://assets.coingecko.com/coins/images/1/large/bitcoin.png',
                    ),
                  );
                },
                child: const Text('Agregar BTC (test)'),
              ),
          ],
        ),
      ),
    );
  }
}