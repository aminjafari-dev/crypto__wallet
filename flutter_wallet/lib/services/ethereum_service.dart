import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart'; // Required for web3dart

class EthereumService {
  late Web3Client _web3Client;

  // Constructor to initialize the Web3Client
  EthereumService(String rpcUrl) {
    _web3Client = Web3Client(rpcUrl, Client());
  }

  /// Get the Ether balance of a given address
  Future<BigInt> getBalance(String address) async {
    try {
      final ethAddress = EthereumAddress.fromHex(address);
      final balance = await _web3Client.getBalance(ethAddress);
      print("Debug: Balance for $address is ${balance.getValueInUnit(EtherUnit.ether)} ETH");
      return balance.getInWei; // Returns balance in Wei
    } catch (e) {
      print("Debug: Error fetching balance for $address - $e");
      throw Exception("Failed to fetch balance: $e");
    }
  }

  /// Send Ether from one wallet to another
  Future<String> sendTokens({
    required String privateKey,
    required String toAddress,
    required double amount,
  }) async {
    try {
      // Create credentials from the private key
      final credentials = EthPrivateKey.fromHex(privateKey);
      final fromAddress = await credentials.extractAddress();

      // Create the recipient address
      final recipient = EthereumAddress.fromHex(toAddress);

      // Get the current gas price
      final gasPrice = await _web3Client.getGasPrice();

      // Send the transaction
      final txHash = await _web3Client.sendTransaction(
        credentials,
        Transaction(
          from: fromAddress,
          to: recipient,
          value: EtherAmount.fromUnitAndValue(EtherUnit.ether, amount),
          gasPrice: gasPrice,
          maxGas: 21000, // Standard gas limit for Ether transfers
        ),
        chainId: null, // Specify chainId if you're not using the default (e.g., mainnet is 1)
      );

      print("Debug: Transaction sent. Hash: $txHash");
      return txHash;
    } catch (e) {
      print("Debug: Error sending tokens - $e");
      throw Exception("Failed to send tokens: $e");
    }
  }
}
