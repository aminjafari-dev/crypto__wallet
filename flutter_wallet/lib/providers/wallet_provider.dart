import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class WalletProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  String? address;
  String? privateKey;
  String? seedPhrase;
  double balance = 0;

  Future<void> createWallet() async {
    try {
      final wallet = await _apiService.createWallet();
      address = wallet['address'];
      privateKey = wallet['private_key'];
      seedPhrase = wallet['seed_phrase'];
      notifyListeners();
    } catch (e) {
      print('Error creating wallet: $e');
      rethrow;
    }
  }

  Future<void> updateBalance() async {
    if (address != null) {
      try {
        balance = await _apiService.getBalance(address!);
        notifyListeners();
      } catch (e) {
        print('Error getting balance: $e');
        rethrow;
      }
    }
  }

  Future<String> sendTokens(String toAddress, double amount) async {
    if (privateKey == null) throw Exception('No wallet created');
    return await _apiService.sendTokens(privateKey!, toAddress, amount);
  }
}