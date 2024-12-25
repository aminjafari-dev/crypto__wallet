// Flutter code to create onboarding pages similar to the provided screenshots
import 'package:flutter/material.dart';
import 'package:flutter_wallet/config/image_path.dart';
import 'package:flutter_wallet/screens/setup/setup_page.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

// List of pages data
  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Secure Your Wealth, Safeguard Your Future',
      'description':
          'Protect your money from inflation and the decreasing value of the rial. Store your assets in a reliable and secure digital wallet.',
      'image': AstraImagePath.welcome1, // Replace with your asset path
    },
    {
      'title': 'Welcome to Financial Freedom',
      'description':
          'Convert your savings into stable digital assets. Escape inflation and take control of your financial future with ease.',
      'image': AstraImagePath.welcome2,
    },
    {
      'title': 'Stability and Security in Your Hands',
      'description':
          'Preserve your wealth with confidence. Manage digital currencies that protect you from the uncertainties of traditional money.',
      'image': AstraImagePath.welcome3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) {
                final data = _onboardingData[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      data['image']!,
                      height: 300.0,
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      data['title']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        data['description']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _onboardingData.length,
              (index) => AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                height: 10.0,
                width: _currentPage == index ? 20.0 : 10.0,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle Get Started button press
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WalletSetupScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Center(
                child: Text(
                  'Get started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
