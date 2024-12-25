import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://192.168.20.2:5005';

  Future<Map<String, dynamic>> createWallet() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/create_wallet'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 4));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to create wallet: ${response.statusCode}');
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  Future<double> getBalance(String address) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_balance'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'address': address}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['balance'];
    }
    throw Exception('Failed to get balance');
  }

  Future<String> sendTokens(String privateKey, String toAddress, double amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/send_tokens'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'private_key': privateKey,
        'to_address': toAddress,
        'amount': amount,
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['transaction_hash'];
    }
    throw Exception('Failed to send tokens');
  }
}