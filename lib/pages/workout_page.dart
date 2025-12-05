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

  @override
  void initState() {
    super.initState();
    _loadTodayTotalMinutes();
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
    
    // 刷新今天的总时长
    await _loadTodayTotalMinutes();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isCheckInMode && minutes >= 30
              ? 'Check-in successful! Saved ${hours.toStringAsFixed(2)} hours'
              : 'Saved ${hours.toStringAsFixed(2)} hours'),
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.pop(context, hours);
    }
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
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
              // 左上角显示今天完成的时间
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
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
                    child: Text(
                      'Today: ${_todayTotalMinutes.toStringAsFixed(0)} min',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
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

