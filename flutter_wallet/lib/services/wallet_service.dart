import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:flutter/services.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class WalletService {
  Map<String, String> createWallet() {
    // Generate a mnemonic
    String mnemonic = bip39.generateMnemonic();
    print("Mnemonic: $mnemonic");

    // Convert mnemonic to seed
    List<int> seed = bip39.mnemonicToSeed(mnemonic);

    // Create root node using BIP32
    final root = bip32.BIP32.fromSeed(Uint8List.fromList(seed));

    // Derive the Ethereum account using the MetaMask path: m/44'/60'/0'/0/0
    final child = root.derivePath("m/44'/60'/0'/0/0");

    // Extract private key
    final privateKey = child.privateKey;
    if (privateKey == null) {
      throw Exception("Failed to derive private key");
    }

    // Generate Ethereum address
    final ethPrivateKey =
        EthPrivateKey.fromHex(bytesToHex(privateKey, include0x: true));
    final address = ethPrivateKey.address.hex;

    print("Address: $address");
    return {
      'private_key': bytesToHex(privateKey, include0x: true),
      'address': address,
      'seed_phrase': mnemonic,
    };
  }
}
