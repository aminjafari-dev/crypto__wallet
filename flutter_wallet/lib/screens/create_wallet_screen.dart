import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';

class CreateWalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Wallet')),
      body: Center(
        child: Consumer<WalletProvider>(
          builder: (context, wallet, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await wallet.createWallet();
                    await wallet.updateBalance();
                  },
                  child: Text('Create New Wallet'),
                ),
                if (wallet.address != null) ...[
                  Text('Address: ${wallet.address}'),
                  Text('Balance: ${wallet.balance} ETH'),
                  Text('Seed Phrase: ${wallet.seedPhrase}'),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}