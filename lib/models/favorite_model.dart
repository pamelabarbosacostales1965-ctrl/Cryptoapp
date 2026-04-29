class Favorite {
  final String id;
  final String name;
  final String symbol;
  final String image;

  Favorite({
    required this.id,
    required this.name,
    required this.symbol,
    required this.image,
  });

  //convierte el objeto a mapa para guardar en SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'image': image,
    };
  }

  //convierte los datos de SQLite otra vez a objeto
  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id'],
      name: map['name'],
      symbol: map['symbol'],
      image: map['image'],
    );
  }
}