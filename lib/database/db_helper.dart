import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/favorite_model.dart';
import '../models/portfolio_model.dart';

class DBHelper {
  static Database? _database;

  //abre la base de datos o la crea
  static Future<Database> get database async {
    if (_database != null) return _database!;

    final path = join(await getDatabasesPath(), 'cryptoapp.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        //Tabla para guardar criptos favoritas
        await db.execute('''
          CREATE TABLE favorites(
            id TEXT PRIMARY KEY,
            name TEXT,
            symbol TEXT,
            image TEXT
          )
        ''');

        //Tabla para guardar compras del portafolio
        await db.execute('''
          CREATE TABLE portfolio(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cryptoId TEXT,
            name TEXT,
            symbol TEXT,
            amount REAL,
            buyPrice REAL
          )
        ''');
      },
    );

    return _database!;
  }

  //Guarda una cripto como favorita
  static Future<void> insertFavorite(Favorite favorite) async {
    final db = await database;
    await db.insert(
      'favorites',
      favorite.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Elimina una favorita por id
  static Future<void> deleteFavorite(String id) async {
    final db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  //Obtiene todas las favoritas guardadas
  static Future<List<Favorite>> getFavorites() async {
    final db = await database;
    final data = await db.query('favorites');
    return data.map((e) => Favorite.fromMap(e)).toList();
  }

  //Guarda una compra en el portafolio
  static Future<void> insertPortfolioItem(PortfolioItem item) async {
    final db = await database;
    await db.insert('portfolio', item.toMap());
  }

  //Elimina una compra del portafolio
  static Future<void> deletePortfolioItem(int id) async {
    final db = await database;
    await db.delete('portfolio', where: 'id = ?', whereArgs: [id]);
  }

  //Obtiene todas las compras guardadas
  static Future<List<PortfolioItem>> getPortfolio() async {
    final db = await database;
    final data = await db.query('portfolio');
    return data.map((e) => PortfolioItem.fromMap(e)).toList();
  }
}