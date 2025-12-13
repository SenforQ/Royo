import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;
  int _steps = 0;
  int _calories = 0;
  int _lastCalorieStep = 0; // 上一次计算卡路里时的步数
  final Random _random = Random();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) {
      _stopTimer();
    } else {
      setState(() {
        _isRunning = true;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _elapsedSeconds++;
          // 每秒步数增加1-2（随机）
          final stepIncrement = _random.nextInt(2) + 1; // 1-2
          _steps += stepIncrement;
          
          // 检查是否达到100的倍数
          final currentHundreds = _steps ~/ 100;
          final lastHundreds = _lastCalorieStep ~/ 100;
          
          if (currentHundreds > lastHundreds) {
            // 每100步增加3-5卡路里（随机）
            final calorieIncrement = _random.nextInt(3) + 3; // 3-5
            _calories += calorieIncrement;
            _lastCalorieStep = _steps;
          }
        });
      });
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
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
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    final double bottomHeight = 297 + bottomPadding + 120;

    return Scaffold(
      body: Stack(
        children: [
          // 背景图片 - 不受其他布局影响
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/training_content_bg.webp',
              width: screenSize.width,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
          // 标题 - 定位在 y: 75
          Positioned(
            top: 75,
            left: 20,
            right: 20,
            child: const Text(
              'Home Dumbbell Muscle-\nBuilding Training',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ),
          // 标签和星级评分 - 在底部背景图片上方
          Positioned(
            left: 20,
            right: 20,
            bottom: bottomHeight + 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标签
                Row(
                  children: [
                    _buildTag('Staying at home'),
                    const SizedBox(width: 8),
                    _buildTag('Beginner'),
                  ],
                ),
                const SizedBox(height: 16),
                // 星级评分
                Row(
                  children: [
                    ...List.generate(
                      5,
                      (index) => const Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '9.8',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 底部内容区域
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: bottomHeight,
            child: Stack(
              children: [
                // 底部背景图片
                Image.asset(
                  'assets/traning_bottom_bg.webp',
                  width: screenSize.width,
                  height: bottomHeight,
                  fit: BoxFit.fill,
                ),
                // 计时卡片 - 定位在底部图片内的 y: 30
                Positioned(
                  top: 30,
                  left: 20,
                  right: 20,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 启动按钮
                        GestureDetector(
                          onTap: _startTimer,
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
                        const SizedBox(width: 12),
                        // 计时器
                        Flexible(
                          child: Text(
                            _formatTime(_elapsedSeconds),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 数据卡片 - 定位在计时器卡片下方20的位置
                Positioned(
                  top: 162, // 30 (计时器top) + 112 (计时器高度: 20*2 padding + 72 按钮高度) + 20 (间距)
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
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
  }) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            width: 36,
            height: 36,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                unit,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 16,
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

