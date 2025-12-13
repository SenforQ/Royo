import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/coin_service.dart';
import 'wallet_page.dart';

class WorkoutPage extends StatefulWidget {
  final bool isCheckInMode;
  final Function(bool)? onCheckInComplete;
  final UserProfile? profile;

  const WorkoutPage({
    super.key,
    this.isCheckInMode = false,
    this.onCheckInComplete,
    this.profile,
  });

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;
  int _steps = 0;
  int _calories = 0;
  int _lastCalorieStep = 0;
  final Random _random = Random();
  bool _isInitializing = true; // Whether initializing (deducting coins)

  @override
  void initState() {
    super.initState();
    // Deduct 5 Coins every time entering the page
    _initializeAndDeductCoins();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initializeAndDeductCoins() async {
    setState(() {
      _isInitializing = true;
    });

    // Deduct 5 Coins
    final success = await CoinService.deductCoins(5);
    if (!mounted) return;

    if (!success) {
      final current = await CoinService.getCurrentCoins();
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFF1C191D),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Coins Not Enough',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Recording time requires 5 Coins.\nCurrent balance: $current Coins.',
            style: const TextStyle(color: Colors.white70, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Return to previous page
              },
              child: const Text('Later', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close dialog and page first
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const WalletPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF420372),
                foregroundColor: Colors.white,
              ),
              child: const Text('Top Up'),
            ),
          ],
        ),
      );
      return;
    }

    if (mounted) {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  void _toggleTimer() {
    if (_isInitializing) return; // Operation not allowed during initialization

    if (_isRunning) {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
      return;
    }

    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsedSeconds++;
        final stepInc = _random.nextInt(2) + 1; // 1-2
        _steps += stepInc;

        final currentHundreds = _steps ~/ 100;
        final lastHundreds = _lastCalorieStep ~/ 100;
        if (currentHundreds > lastHundreds) {
          final calorieInc = _random.nextInt(3) + 3; // 3-5
          _calories += calorieInc;
          _lastCalorieStep = _steps;
        }
      });
    });
  }


  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double topPadding = MediaQuery.of(context).padding.top;
    final double bottomHeight = 297 + MediaQuery.of(context).padding.bottom;
    const double timerTop = 24;
    const double timerHeight = 104; // 72 btn + 32 padding
    const double statTop = timerTop + timerHeight + 16; // 144

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/training_content_bg.webp',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          // Back button
          Positioned(
            top: topPadding + 16,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Title
          const Positioned(
            top: 155,
            left: 20,
            right: 20,
            child: Text(
              'Workout Session',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ),
          // Tags and rating
          Positioned(
            left: 20,
            right: 20,
            bottom: bottomHeight + 16,
            child: Row(
              children: [
                _buildTag('Indoor'),
                const SizedBox(width: 8),
                _buildTag('Custom'),
                const SizedBox(width: 12),
                ...List.generate(
                  5,
                  (index) => const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  '9.8',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          // Bottom area
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: bottomHeight,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/traning_bottom_bg.webp',
                    fit: BoxFit.fill,
                  ),
                ),
                // Timer card
                Positioned(
                  top: timerTop,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF9C27B0),
                          Color(0xFF7B1FA2),
                          Color(0xFF6A1B9A),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _toggleTimer,
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.35),
                                width: 4,
                              ),
                            ),
                            child: Icon(
                              _isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                        Text(
                          _formatTime(_elapsedSeconds),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Data cards
                Positioned(
                  top: statTop,
                  left: 20,
                  right: 20,
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          bgColor: const Color(0xFFF06292),
                          imagePath: 'assets/img_calories.webp',
                          title: 'Calories',
                          value: '$_calories',
                          unit: 'Kcal',
                          height: 125,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          bgColor: const Color(0xFFEC407A),
                          imagePath: 'assets/img_exercise.webp',
                          title: 'Exercise',
                          value: '${(_steps / 1000).toStringAsFixed(1)}',
                          unit: 'Km',
                          height: 125,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required Color bgColor,
    required String imagePath,
    required String title,
    required String value,
    required String unit,
    double height = 150,
  }) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            width: 30,
            height: 30,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

