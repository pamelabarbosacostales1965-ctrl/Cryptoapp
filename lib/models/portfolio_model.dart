class PortfolioItem {
  final int? id;
  final String cryptoId;
  final String name;
  final String symbol;
  final double amount;
  final double buyPrice;

  PortfolioItem({
    this.id,
    required this.cryptoId,
    required this.name,
    required this.symbol,
    required this.amount,
    required this.buyPrice,
  });

  //convierte la compra a mapa para SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cryptoId': cryptoId,
      'name': name,
      'symbol': symbol,
      'amount': amount,
      'buyPrice': buyPrice,
    };
  }

  //convierte el mapa de SQLite a PortfolioItem
  factory PortfolioItem.fromMap(Map<String, dynamic> map) {
    return PortfolioItem(
      id: map['id'],
      cryptoId: map['cryptoId'],
      name: map['name'],
      symbol: map['symbol'],
      amount: map['amount'],
      buyPrice: map['buyPrice'],
    );
  }
}