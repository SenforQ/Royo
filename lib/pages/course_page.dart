import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'workout_page.dart';
import '../utils/checkin_storage.dart';
import '../utils/workout_storage.dart';
import '../models/user_profile.dart';
import 'ai_chat_page.dart';
import 'exercise_activities_page.dart';
import 'figure_detail_page.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
  
  static _CoursePageState? of(BuildContext context) {
    return context.findAncestorStateOfType<_CoursePageState>();
  }
}

class _CoursePageState extends State<CoursePage> {
  List<String> _checkInDates = [];
  DateTime _selectedDate = DateTime.now();
  double _todayTotalMinutes = 0.0;
  List<UserProfile> _recommendedProfiles = [];

  @override
  void initState() {
    super.initState();
    _loadCheckInDates();
    _loadTodayTotalMinutes();
    _loadRecommendedProfiles();
  }

  Future<void> _loadRecommendedProfiles() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/NABI_Chat.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      final List<UserProfile> profiles = jsonList.map((json) => UserProfile.fromJson(json)).toList();
      
      if (mounted) {
        setState(() {
          // 倒序显示，取最后5个
          _recommendedProfiles = profiles.reversed.take(5).toList();
        });
      }
    } catch (e) {
      print('Error loading recommended profiles: $e');
    }
  }

  Future<void> _loadCheckInDates() async {
    final dates = await CheckInStorage.getCheckInDates();
    if (mounted) {
      setState(() {
        _checkInDates = dates;
      });
    }
  }

  Future<void> _loadTodayTotalMinutes() async {
    final minutes = await WorkoutStorage.getTodayTotalMinutes();
    if (mounted) {
      setState(() {
        _todayTotalMinutes = minutes;
      });
    }
  }

  List<DateTime> _getWeekDates() {
    final now = DateTime.now();
    // 计算本周的开始日期（周日）
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  String _formatDateString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _getDayAbbreviation(DateTime date) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    // DateTime.weekday: 1=Monday, 7=Sunday
    // 转换为 0=Sunday, 1=Monday, ..., 6=Saturday
    final weekdayIndex = date.weekday % 7;
    return days[weekdayIndex];
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isCheckedIn(DateTime date) {
    final dateString = _formatDateString(date);
    return _checkInDates.contains(dateString);
  }

  Future<void> _navigateToWorkout(DateTime date) async {
    // 只能点击今天进行打卡
    if (!_isToday(date)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can only check in for today'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // 如果今天已打卡，提示
    if (_isCheckedIn(date)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have already checked in today'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutPage(
          isCheckInMode: true,
          onCheckInComplete: (success) {
            if (success) {
              _loadCheckInDates();
            }
          },
        ),
      ),
    );

    // 刷新打卡记录和今天的总时长
    if (result != null) {
      await _loadCheckInDates();
      await _loadTodayTotalMinutes();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final weekDates = _getWeekDates();
    final today = DateTime.now();

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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // 今天锻炼时长总和
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF8B5CF6),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.fitness_center,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Today: ${_todayTotalMinutes.toStringAsFixed(0)} min',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Fitness Calendar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF8B5CF6),
                          const Color(0xFF6D4CFF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              const Text(
                                'FITNESS CALENDAR',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.red,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: weekDates.map((date) {
                                final isToday = _isToday(date);
                                final isCheckedIn = _isCheckedIn(date);
                                final dateString = _formatDateString(date);
                                
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () => _navigateToWorkout(date),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 2),
                                      decoration: BoxDecoration(
                                        color: isToday
                                            ? Colors.white
                                            : const Color(0xFF6B46C1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: isToday
                                            ? Border.all(color: Colors.grey.shade300, width: 1)
                                            : null,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _getDayAbbreviation(date),
                                            style: TextStyle(
                                              color: isToday ? Colors.black87 : Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            date.day.toString().padLeft(2, '0'),
                                            style: TextStyle(
                                              color: isToday ? Colors.black87 : Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (isCheckedIn)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: Text(
                                                '✅',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Banner Image
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AiChatPage(),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/img_profile_banner_record.webp',
                      width: MediaQuery.of(context).size.width - 40,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Exercise Duration Image
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ExerciseActivitiesPage(),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/img_profile_exercise_duartion.webp',
                          width: MediaQuery.of(context).size.width - 40,
                          fit: BoxFit.contain,
                        ),
                        Positioned(
                          left: 20,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Exercise activities',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Recommend Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Best exercise',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Recommend Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: _recommendedProfiles.asMap().entries.map((entry) {
                      final index = entry.key;
                      final profile = entry.value;
                      return _buildRecommendCard(profile, index);
                    }).toList(),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendCard(UserProfile profile, int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth - 40;
    
    // 为每个角色生成不同的活动数据
    final activityTypes = ["Brisk walking", "Running", "Cycling", "Swimming", "HIIT"];
    final activityType = activityTypes[index % activityTypes.length];
    final activityHours = 2 + (index % 3); // 2-4 hours
    
    // 根据索引生成不同的距离、时长和配速
    final baseDistance = 3.0 + (index * 0.5); // 3.0, 3.5, 4.0, 4.5, 5.0
    final distance = baseDistance;
    final baseDuration = 30 + (index * 5); // 30, 35, 40, 45, 50
    final duration = baseDuration;
    
    // 计算配速（分钟/公里）
    final paceMinutes = (duration / distance).round();
    final paceSeconds = ((duration / distance - paceMinutes) * 60).round();
    final pace = "${paceMinutes.toString().padLeft(2, '0')}:${paceSeconds.toString().padLeft(2, '0')}";
    
    final checkInDate = "2025/09/26";
    
    // 获取缩略图（使用 RoroShowThumbnailArray 的第一张）
    final thumbnailImage = profile.showThumbnailArray.isNotEmpty
        ? profile.showThumbnailArray[0]
        : (profile.showPhotoArray.isNotEmpty
            ? profile.showPhotoArray[0]
            : profile.userIcon);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
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
          // 顶部：头像和用户信息
          Row(
            children: [
              // 头像
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FigureDetailPage(profile: profile),
                    ),
                  );
                },
                child: Container(
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
              ),
              const SizedBox(width: 12),
              // 用户信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.nickName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${activityHours}hours $activityType',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.directions_walk,
                          color: Colors.black,
                          size: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.showMotto,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 中间：大图和指标
          SizedBox(
            height: 180, // 固定总高度
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 左侧大图（使用缩略图）
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      thumbnailImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // 右侧指标卡片
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: _buildMetricCard('${distance}km', 'Distance'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: _buildMetricCard('${duration}Mins', 'Duration'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: _buildMetricCard('$pace/km', 'Pace'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 底部：打卡状态
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFF8B5CF6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Checked in on $checkInDate',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String value, String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF6D4CFF).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
