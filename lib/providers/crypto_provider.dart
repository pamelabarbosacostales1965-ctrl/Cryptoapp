import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/crypto_service.dart';

final cryptoServiceProvider = Provider<CryptoService>((ref) {
  return CryptoService();
});

final cryptoListProvider = FutureProvider<List<dynamic>>((ref) async {
  final service = ref.watch(cryptoServiceProvider);
  return service.getTopCryptos();
});

final cryptoDetailProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, id) async {
  final service = ref.watch(cryptoServiceProvider);
  return service.getCryptoDetail(id);
});