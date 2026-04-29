import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/favorite_model.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Favorite> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  //carga las criptos favoritas guardadas en SQLite
  Future<void> loadFavorites() async {
    final data = await DBHelper.getFavorites();
    setState(() {
      favorites = data;
    });
  }

  //elimina una cripto favorita
  Future<void> deleteFavorite(String id) async {
    await DBHelper.deleteFavorite(id);
    loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text('No tienes criptos favoritas todavia'),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final crypto = favorites[index];

                return Dismissible(
                  key: Key(crypto.id),
                  direction: DismissDirection.endToStart,

                  // Fondo rojo cuando se desliza para borrar
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),

                  onDismissed: (_) {
                    deleteFavorite(crypto.id);
                  },

                  child: ListTile(
                    leading: Image.network(
                      crypto.image,
                      width: 35,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.currency_bitcoin);
                      },
                    ),
                    title: Text(crypto.name),
                    subtitle: Text(crypto.symbol.toUpperCase()),
                    trailing: const Icon(Icons.star, color: Colors.amber),
                  ),
                );
              },
            ),
    );
  }
}
