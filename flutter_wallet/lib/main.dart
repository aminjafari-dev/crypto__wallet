import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wallet/screens/wellcome/wellcome_page.dart';
import 'package:flutter_wallet/services/ethereum_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:provider/provider.dart';

// Main Entry Point
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => CurrencyConversionProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: OnboardingScreen(),
      ),
    );
  }
}

// Home Screen
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final ethereumService = EthereumService(
      "https://base-mainnet.g.alchemy.com/v2/kDPMGfNynLb-uJDyPm2qEclRiZ5IM40g");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crypto Wallet')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  final wallet = await WalletService().createWallet();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Wallet created successfully')),
                  );
                  print(wallet);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: Text('Create Wallet'),
            ),
            ElevatedButton(
              onPressed: () {
                ethereumService
                    .getBalance('0xd7a2bf19ee5989849eb088e6009c1331e2548239');
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ImportWalletScreen()),
                // );
              },
              child: Text('Import Wallet'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TransactionScreen()),
                );
              },
              child: Text('Transactions'),
            ),
          ],
        ),
      ),
    );
  }
}

// Create Wallet Screen
class CreateWalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Create Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Your Seed Phrase:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SelectableText(
                walletProvider.seedPhrase ?? 'No seed generated yet.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                walletProvider.generateSeedPhrase();
              },
              child: Text('Generate Seed Phrase'),
            ),
          ],
        ),
      ),
    );
  }
}

// Import Wallet Screen
class ImportWalletScreen extends StatelessWidget {
  final TextEditingController _seedPhraseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Import Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _seedPhraseController,
              decoration: InputDecoration(labelText: 'Seed Phrase'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                walletProvider.importWallet(_seedPhraseController.text);
              },
              child: Text('Import Wallet'),
            ),
          ],
        ),
      ),
    );
  }
}

// Transaction Screen
class TransactionScreen extends StatelessWidget {
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final conversionProvider = Provider.of<CurrencyConversionProvider>(context);
    final walletProvider = Provider.of<WalletProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: conversionProvider.selectedCurrency,
              items: ['USD', 'IRR'].map((currency) {
                return DropdownMenuItem(value: currency, child: Text(currency));
              }).toList(),
              onChanged: (value) {
                if (value != null) conversionProvider.setCurrency(value);
              },
            ),
            SizedBox(height: 10),
            Text(
                'Equivalent: ${conversionProvider.convertedAmount} ${conversionProvider.targetCurrency}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.qr_code),
                        title: Text('Show QR Code'),
                        onTap: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Text('QR Code Placeholder'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.copy),
                        title: Text('Copy Address'),
                        onTap: () {
                          Clipboard.setData(ClipboardData(
                              text: walletProvider.walletAddress));
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Text('Send'),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text('QR Code Placeholder'),
                  ),
                );
              },
              child: Text('Receive'),
            ),
          ],
        ),
      ),
    );
  }
}

// Wallet Provider
class WalletProvider extends ChangeNotifier {
  String? seedPhrase;
  String walletAddress = "0x123456789abcdef"; // Placeholder

  void generateSeedPhrase() {
    seedPhrase = 'sample-seed-phrase';
    notifyListeners();
  }

  void importWallet(String seed) {
    seedPhrase = seed;
    notifyListeners();
  }
}

// Currency Conversion Provider
class CurrencyConversionProvider extends ChangeNotifier {
  String selectedCurrency = 'USD';
  double convertedAmount = 0.0;
  String targetCurrency = 'IRR';

  void setCurrency(String currency) {
    selectedCurrency = currency;
    targetCurrency = (currency == 'USD') ? 'IRR' : 'USD';
    notifyListeners();
  }

  void convertAmount(double amount) {
    convertedAmount = (selectedCurrency == 'USD')
        ? amount * 42000
        : amount / 42000; // Placeholder conversion rate
    notifyListeners();
  }
}
