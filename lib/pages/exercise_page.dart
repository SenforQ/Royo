import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/workout_storage.dart';
import '../utils/checkin_storage.dart';
import 'workout_page.dart';
import 'exercise_activities_page.dart';
import 'training_plan_page.dart';
import 'ai_chat_page.dart';
import 'figure_detail_page.dart';
import 'activity_page.dart';
import 'bmi_input_page.dart';
import '../models/user_profile.dart';
import '../utils/bmi_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  double _todayTotalMinutes = 0.0;
  double _dailyGoal = 30.0;
  Map<String, dynamic> _weeklyStats = {};
  Map<String, dynamic> _monthlyStats = {};
  List<Map<String, dynamic>> _recentWorkouts = [];
  List<UserProfile> _recommendedProfiles = [];
  int _steps = 0;
  double? _bmiValue;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadTodayTotalMinutes(),
      _loadDailyGoal(),
      _loadStats(),
      _loadRecentWorkouts(),
      _loadRecommendedProfiles(),
      _loadBMI(),
    ]);
  }

  Future<void> _loadBMI() async {
    final bmi = await BmiStorage.getCurrentBmi();
    if (mounted) {
      setState(() {
        _bmiValue = bmi;
      });
    }
  }

  Future<void> _loadTodayTotalMinutes() async {
    final minutes = await WorkoutStorage.getTodayTotalMinutes();
    if (mounted) {
      setState(() {
        _todayTotalMinutes = minutes;
        _steps = (_todayTotalMinutes * 120).toInt(); // 按今日锻炼时间映射步数
      });
    }
  }

  Future<void> _loadDailyGoal() async {
    final goal = await WorkoutStorage.getDailyGoal();
    if (mounted) {
      setState(() {
        _dailyGoal = goal;
      });
    }
  }

  Future<void> _loadStats() async {
    final weekly = await WorkoutStorage.getWeeklyStats();
    final monthly = await WorkoutStorage.getMonthlyStats();
    if (mounted) {
      setState(() {
        _weeklyStats = weekly;
        _monthlyStats = monthly;
      });
    }
  }

  Future<void> _loadRecentWorkouts() async {
    final workouts = await WorkoutStorage.getRecentWorkouts(7);
    if (mounted) {
      setState(() {
        _recentWorkouts = workouts;
      });
    }
  }

  Future<void> _loadRecommendedProfiles() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/NABI_Chat.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      final List<UserProfile> profiles = jsonList.map((json) => UserProfile.fromJson(json)).toList();
      
      if (mounted) {
        setState(() {
          _recommendedProfiles = profiles.take(3).toList();
        });
      }
    } catch (e) {
      print('Error loading recommended profiles: $e');
    }
  }

  Future<void> _navigateToBmiInput() async {
    final result = await Navigator.push<double?>(
      context,
      MaterialPageRoute(builder: (context) => const BmiInputPage()),
    );
    if (mounted && result != null && result > 0) {
      await _loadBMI();
    }
  }

  (String label, Color color, String subtitle) _getBmiStatus(double bmi) {
    if (bmi < 18.5) {
      return ('Low', const Color(0xFF1E88E5), 'BMI is low');
    } else if (bmi < 25) {
      return ('Normal', const Color(0xFF43A047), 'Your BMI is healthy');
    } else if (bmi < 30) {
      return ('Overweight', const Color(0xFFF9A825), 'BMI is above ideal');
    } else {
      return ('Obese', const Color(0xFFD32F2F), 'BMI is high');
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date).inDays;
      
      if (difference == 0) {
        return 'Today';
      } else if (difference == 1) {
        return 'Yesterday';
      } else if (difference < 7) {
        return '$difference days ago';
      } else {
        return '${date.month}/${date.day}';
      }
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final progress = _dailyGoal > 0 ? (_todayTotalMinutes / _dailyGoal).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/base_page_content_bg.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // 标题
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'EXERCISE',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                    ),
                const SizedBox(height: 20),
                // 今日进度卡片
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF8B5CF6).withOpacity(0.8),
                          const Color(0xFF6D4CFF).withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Today\'s Progress',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${_todayTotalMinutes.toStringAsFixed(0)} / ${_dailyGoal.toStringAsFixed(0)} min',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const WorkoutPage(),
                                  ),
                                ).then((_) => _loadData());
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.play_arrow,
                                      color: Color(0xFF8B5CF6),
                                      size: 20,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Start',
                                      style: TextStyle(
                                        color: Color(0xFF8B5CF6),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${(progress * 100).toStringAsFixed(0)}% Complete',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // BMI & Steps 卡片
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildHealthCard(
                          title: 'BMI',
                          subtitle: _bmiValue != null
                              ? _getBmiStatus(_bmiValue!).$3
                              : 'Tap to fill BMI',
                          value: _bmiValue != null ? _bmiValue!.toStringAsFixed(1) : '--',
                          badgeText: _bmiValue != null ? _getBmiStatus(_bmiValue!).$1 : 'Fill',
                          badgeColor: _bmiValue != null ? _getBmiStatus(_bmiValue!).$2 : const Color(0xFF7C4DFF),
                          gradientColors: const [
                            Color(0xFF7C4DFF),
                            Color(0xFF512DA8),
                          ],
                          imagePath: 'assets/img_bmi.webp',
                          onTap: _navigateToBmiInput,
                          showReference: _bmiValue != null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildHealthCard(
                          title: 'Steps',
                          subtitle: 'Based on workout time',
                          value: '$_steps',
                          badgeText: 'Standard',
                          badgeColor: const Color(0xFF1B5E20),
                          gradientColors: const [
                            Color(0xFF536DFE),
                            Color(0xFF283593),
                          ],
                          imagePath: 'assets/img_step.webp',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Calorie data card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildCalorieCard(),
                ),
                const SizedBox(height: 20),
                // 统计卡片
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'This Week',
                          '${(_weeklyStats['totalMinutes'] ?? 0.0).toStringAsFixed(0)} min',
                          Icons.calendar_today,
                          const Color(0xFF8B5CF6),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'This Month',
                          '${(_monthlyStats['totalMinutes'] ?? 0.0).toStringAsFixed(0)} min',
                          Icons.trending_up,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // 快速操作
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionButton(
                          'Record Exercise',
                          Icons.add_circle_outline,
                          Colors.green,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ExerciseActivitiesPage(),
                              ),
                            ).then((_) => _loadData());
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickActionButton(
                          'Training Plan',
                          Icons.fitness_center,
                          Colors.blue,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AiChatPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // 最近锻炼记录
                if (_recentWorkouts.any((w) => w['minutes'] > 0)) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Recent Workouts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: _recentWorkouts
                          .where((w) => w['minutes'] > 0)
                          .map((workout) => _buildWorkoutItem(workout))
                          .toList(),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                // 推荐教练
                if (_recommendedProfiles.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Recommended Coaches',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _recommendedProfiles.length,
                      itemBuilder: (context, index) {
                        final profile = _recommendedProfiles[index];
                        return _buildCoachCard(profile);
                      },
                    ),
                  ),
                ],
                SizedBox(height: MediaQuery.of(context).padding.bottom + 20 + 69),
                  ],
                ),
              ),
              // 右上角 start 按钮
              Positioned(
                top: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ActivityPage(),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/start.webp',
                    width: 33,
                    height: 33,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthCard({
    required String title,
    required String subtitle,
    required String value,
    required String badgeText,
    required Color badgeColor,
    required List<Color> gradientColors,
    required String imagePath,
    VoidCallback? onTap,
    bool showReference = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (showReference && title == 'BMI') ...[
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () async {
                      final uri = Uri.parse('https://www.cdc.gov/healthyweight/assessing/bmi/index.html');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.white.withOpacity(0.7),
                          size: 10,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Reference',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 9,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: Image.asset(
                imagePath,
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalorieCard() {
    final List<String> labels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final int todayIndex = DateTime.now().weekday % 7; // Mon=1 ->1, Sun=0
    final double calorieToday = (_steps * 0.04); // 简单按步数估算热量
    final List<double> values = List<double>.filled(7, 0);
    values[todayIndex] = (_steps / 12000).clamp(0.0, 1.0); // 以 12000 步为满刻度
    const double maxBarHeight = 110;
    const double minBarHeight = 10;
    const double labelHeight = 22;

    return Container(
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        image: const DecorationImage(
          image: AssetImage('assets/calorie_data_bg.webp'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/calorie_left_date.webp',
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Calorie data',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Weekly Data',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${calorieToday.toStringAsFixed(0)} Kcal',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(values.length, (index) {
                  final double barHeight = (maxBarHeight * values[index]).clamp(minBarHeight, maxBarHeight);
                  return Expanded(
                    child: SizedBox(
                      height: maxBarHeight + labelHeight + 6,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Positioned(
                            bottom: labelHeight + 6,
                            child: Container(
                              height: barHeight,
                              width: 18,
                              decoration: BoxDecoration(
                                color: index == todayIndex
                                    ? const Color(0xFFB388FF)
                                    : Colors.white.withOpacity(0.25 + values[index] * 0.4),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Text(
                              labels[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutItem(Map<String, dynamic> workout) {
    final date = workout['date'] as String;
    final minutes = workout['minutes'] as double;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.fitness_center,
              color: Color(0xFF8B5CF6),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(date),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${minutes.toStringAsFixed(0)} minutes',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${minutes.toStringAsFixed(0)} min',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachCard(UserProfile profile) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FigureDetailPage(profile: profile),
          ),
        );
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                image: DecorationImage(
                  image: AssetImage(profile.userIcon),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              profile.nickName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

