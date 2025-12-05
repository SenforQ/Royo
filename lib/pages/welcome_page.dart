import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/agreement_storage.dart';
import 'roro_terms_page.dart';
import 'roro_privacy_page.dart';
import '../main.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _isAgreed = false;

  Future<void> _enterApp() async {
    if (_isAgreed) {
      await AgreementStorage.setAgreed(true);
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/welcome_bg_content.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Enter App Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isAgreed ? _enterApp : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isAgreed
                          ? const Color(0xFF383838)
                          : Colors.black.withOpacity(0.7),
                      disabledBackgroundColor: Colors.black.withOpacity(0.7),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: _isAgreed
                              ? Colors.transparent
                              : Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      'Enter App',
                      style: TextStyle(
                        color: _isAgreed
                            ? Colors.white
                            : Colors.white.withOpacity(0.9),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Agreement Text
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: bottomPadding + 48,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isAgreed = !_isAgreed;
                        });
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(right: 8, top: 2),
                        decoration: BoxDecoration(
                          color: _isAgreed
                              ? const Color(0xFF8B5CF6)
                              : Colors.transparent,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: _isAgreed
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              )
                            : null,
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          children: [
                            const TextSpan(
                              text: 'I have read and agree ',
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const RoroTermsPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Terms of Service',
                                  style: TextStyle(
                                    color: Color(0xFF8B5CF6),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                            const TextSpan(
                              text: ' and\n',
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const RoroPrivacyPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                    color: Color(0xFF8B5CF6),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

