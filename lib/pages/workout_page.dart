import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/workout_storage.dart';
import '../utils/checkin_storage.dart';
import '../models/user_profile.dart';
import 'figure_detail_page.dart';

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
  int _seconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;
  double _todayTotalMinutes = 0.0;
  double _dailyGoal = 30.0;
  Map<String, dynamic> _weeklyStats = {};
  Map<String, dynamic> _monthlyStats = {};
  String? _selectedWorkoutType;

  @override
  void initState() {
    super.initState();
    _loadTodayTotalMinutes();
    _loadDailyGoal();
    _loadStats();
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadTodayTotalMinutes() async {
    final minutes = await WorkoutStorage.getTodayTotalMinutes();
    if (mounted) {
      setState(() {
        _todayTotalMinutes = minutes;
      });
    }
  }

  void _startTimer() {
    if (_isRunning) return;
    
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _pauseTimer() {
    if (!_isRunning) return;
    
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = true;
    });
  }

  void _resumeTimer() {
    if (_isRunning) return;
    
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _seconds = 0;
      _selectedWorkoutType = null;
    });
  }

  Future<void> _saveWorkout() async {
    if (_seconds == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No workout time to save'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final hours = _seconds / 3600.0;
    final minutes = _seconds / 60.0;
    
    // 如果是打卡模式，需要锻炼至少30分钟
    if (widget.isCheckInMode && minutes < 30) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Need at least 30 minutes for check-in. Current: ${minutes.toStringAsFixed(0)} minutes'),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    await WorkoutStorage.addHours(hours);
    
    // 如果是打卡模式且达到30分钟，记录打卡
    if (widget.isCheckInMode && minutes >= 30) {
      final today = CheckInStorage.getTodayDateString();
      await CheckInStorage.addCheckInDate(today);
      if (widget.onCheckInComplete != null) {
        widget.onCheckInComplete!(true);
      }
    }
    
    // 刷新今天的总时长和统计
    await _loadTodayTotalMinutes();
    await _loadStats();
    
    if (mounted) {
      final workoutTypeText = _selectedWorkoutType != null ? ' ($_selectedWorkoutType)' : '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isCheckInMode && minutes >= 30
              ? 'Check-in successful! Saved ${hours.toStringAsFixed(2)} hours$workoutTypeText'
              : 'Saved ${hours.toStringAsFixed(2)} hours$workoutTypeText'),
          duration: const Duration(seconds: 2),
        ),
      );
      // 重置选中的锻炼类型
      setState(() {
        _selectedWorkoutType = null;
      });
      Navigator.pop(context, hours);
    }
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Widget _buildQuickStartButton(String label, IconData icon, Color color) {
    final isSelected = _selectedWorkoutType == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedWorkoutType = label;
        });
        _startTimer();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? color.withOpacity(0.3) 
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.white.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? color : Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGoalDialog() {
    final goalController = TextEditingController(text: _dailyGoal.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C191D),
        title: const Text(
          'Set Daily Goal',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: goalController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Minutes',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF8B5CF6)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              final goal = double.tryParse(goalController.text);
              if (goal != null && goal > 0) {
                await WorkoutStorage.setDailyGoal(goal);
                await _loadDailyGoal();
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Daily goal set to ${goal.toStringAsFixed(0)} minutes'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
            child: const Text('Save', style: TextStyle(color: Color(0xFF8B5CF6))),
          ),
        ],
      ),
    );
  }

  void _showStatsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C191D),
        title: const Text(
          'Workout Statistics',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 本周统计
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF8B5CF6),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'This Week',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildStatRow(
                      'Total Time',
                      '${(_weeklyStats['totalMinutes'] ?? 0.0).toStringAsFixed(0)} min',
                    ),
                    _buildStatRow(
                      'Workout Days',
                      '${_weeklyStats['workoutDays'] ?? 0} days',
                    ),
                    _buildStatRow(
                      'Average',
                      '${(_weeklyStats['averageMinutes'] ?? 0.0).toStringAsFixed(0)} min/day',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // 本月统计
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'This Month',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildStatRow(
                      'Total Time',
                      '${(_monthlyStats['totalMinutes'] ?? 0.0).toStringAsFixed(0)} min',
                    ),
                    _buildStatRow(
                      'Workout Days',
                      '${_monthlyStats['workoutDays'] ?? 0} days',
                    ),
                    _buildStatRow(
                      'Average',
                      '${(_monthlyStats['averageMinutes'] ?? 0.0).toStringAsFixed(0)} min/day',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Color(0xFF8B5CF6))),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: widget.profile != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FigureDetailPage(profile: widget.profile!),
                        ),
                      );
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                        image: DecorationImage(
                          image: AssetImage(widget.profile!.userIcon),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('Workout'),
                ],
              )
            : const Text('Workout'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_isRunning || _isPaused) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Workout in Progress'),
                  content: const Text('Do you want to save your workout time?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Discard'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await _saveWorkout();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 顶部信息栏
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 今天完成的时间
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF8B5CF6),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today: ${_todayTotalMinutes.toStringAsFixed(0)} min',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // 目标进度条
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: _dailyGoal > 0 ? (_todayTotalMinutes / _dailyGoal).clamp(0.0, 1.0) : 0.0,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                                minHeight: 4,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Goal: ${_dailyGoal.toStringAsFixed(0)} min',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 统计按钮
                    IconButton(
                      icon: const Icon(Icons.bar_chart, color: Colors.white),
                      onPressed: _showStatsDialog,
                      tooltip: 'Statistics',
                    ),
                    // 设置目标按钮
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: _showGoalDialog,
                      tooltip: 'Set Goal',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // 快速开始预设锻炼类型
              if (!_isRunning && !_isPaused && _seconds == 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick Start',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildQuickStartButton('Running', Icons.directions_run, Colors.blue),
                            const SizedBox(width: 12),
                            _buildQuickStartButton('Strength', Icons.fitness_center, Colors.orange),
                            const SizedBox(width: 12),
                            _buildQuickStartButton('Yoga', Icons.self_improvement, Colors.purple),
                            const SizedBox(width: 12),
                            _buildQuickStartButton('Cycling', Icons.directions_bike, Colors.green),
                            const SizedBox(width: 12),
                            _buildQuickStartButton('Custom', Icons.timer, Colors.grey),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _formatTime(_seconds),
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_isRunning && !_isPaused)
                    ElevatedButton(
                      onPressed: _startTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Start',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if (_isRunning)
                    ElevatedButton(
                      onPressed: _pauseTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Pause',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if (_isPaused) ...[
                    ElevatedButton(
                      onPressed: _resumeTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Resume',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _stopTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Stop',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 40),
              if (_seconds > 0 && (!_isRunning && !_isPaused))
                ElevatedButton(
                  onPressed: _saveWorkout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Save Workout',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

