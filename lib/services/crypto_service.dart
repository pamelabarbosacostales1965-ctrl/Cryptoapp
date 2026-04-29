import 'dart:convert';
import 'package:http/http.dart' as http;

class CryptoService {
  final String baseUrl = 'https://api.coingecko.com/api/v3';

  Future<List<dynamic>> getTopCryptos() async {
    final url = Uri.parse(
      '$baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=false',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar criptomonedas');
    }
  }

  Future<Map<String, dynamic>> getCryptoDetail(String id) async {
    final url = Uri.parse('$baseUrl/coins/$id');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar detalle de la cripto');
    }
  }

  Future<Map<String, double>> getCurrentPricesByIds(List<String> ids) async {
    if (ids.isEmpty) return {};

    final idsParam = ids.toSet().join(',');

    final url = Uri.parse(
      '$baseUrl/simple/price?ids=$idsParam&vs_currencies=usd',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      return data.map((key, value) {
        return MapEntry(
          key,
          (value['usd'] as num).toDouble(),
        );
      });
    } else {
      throw Exception('Error al obtener precios actuales');
    }
  }
}