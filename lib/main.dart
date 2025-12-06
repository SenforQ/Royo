import 'package:flutter/material.dart';
import 'pages/course_page.dart';
import 'pages/activity_page.dart';
import 'pages/me_page.dart';
import 'pages/welcome_page.dart';
import 'utils/agreement_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nabi-',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1C191D),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToWelcome();
  }

  Future<void> _navigateToWelcome() async {
    // 延迟一小段时间以确保界面加载完成
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const WelcomePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const CoursePage(),
    const ActivityPage(),
    const MePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Container(
                  height: 79,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTabItem(
                        index: 0,
                        normalImage: 'assets/btn_tab_course_pre.webp',
                        selectedImage: 'assets/btn_tab_course_nor.webp',
                      ),
                      _buildTabItem(
                        index: 1,
                        normalImage: 'assets/btn_tab_activity_pre.webp',
                        selectedImage: 'assets/btn_tab_activity_nor.webp',
                      ),
                      _buildTabItem(
                        index: 2,
                        normalImage: 'assets/btn_tab_me_pre.webp',
                        selectedImage: 'assets/btn_tab_me_nor.webp',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required String normalImage,
    required String selectedImage,
  }) {
    final bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: SizedBox(
        width: 79,
        height: 79,
        child: Image.asset(
          isSelected ? selectedImage : normalImage,
          width: 79,
          height: 79,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
