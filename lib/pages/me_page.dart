import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'privacy_policy_page.dart';
import 'user_agreement_page.dart';
import 'workout_page.dart';
import 'setting_editor_page.dart';
import 'about_us_page.dart';
import '../utils/workout_storage.dart';
import '../utils/user_storage.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  double _totalHours = 0.0;
  String _nickname = 'Royo';
  String? _avatarPath;
  File? _avatarFile;

  @override
  void initState() {
    super.initState();
    _loadTotalHours();
    _loadUserInfo();
  }

  Future<void> _loadTotalHours() async {
    final hours = await WorkoutStorage.getTotalHours();
    if (mounted) {
      setState(() {
        _totalHours = hours;
      });
    }
  }

  Future<void> _loadUserInfo() async {
    final nickname = await UserStorage.getNickname();
    final avatarPath = await UserStorage.getAvatarPath();
    
    setState(() {
      _nickname = nickname;
      _avatarPath = avatarPath;
    });
    
    if (avatarPath != null) {
      _loadAvatarFile(avatarPath);
    }
  }

  Future<void> _loadAvatarFile(String relativePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = path.join(directory.path, relativePath);
      final file = File(filePath);
      if (await file.exists()) {
        setState(() {
          _avatarFile = file;
        });
      }
    } catch (e) {
      print('Error loading avatar file: $e');
    }
  }

  Future<void> _navigateToWorkout() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WorkoutPage(),
      ),
    );
    
    if (result != null && mounted) {
      await _loadTotalHours();
    }
  }

  Future<void> _navigateToSetting() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingEditorPage(),
      ),
    );
    
    if (result == true && mounted) {
      await _loadUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/base_page_content_bg.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ME',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xFF8B5CF6),
                              width: 3,
                            ),
                            image: _avatarFile != null
                                ? DecorationImage(
                                    image: FileImage(_avatarFile!),
                                    fit: BoxFit.cover,
                                  )
                                : DecorationImage(
                                    image: AssetImage('assets/user_default_img.webp'),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFF8B5CF6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _nickname,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: _navigateToWorkout,
                      child: Container(
                        width: 208,
                        height: 113,
                        decoration: BoxDecoration(
                          color: Color(0xFF8B5CF6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                'assets/img_me_workout.webp',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.fitness_center,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Workout',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${_totalHours.toStringAsFixed(1)} hours',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: MediaQuery.of(context).padding.bottom + 120,
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        context: context,
                        icon: 'assets/icon_me_privacy_policy.webp',
                        title: 'Privacy Policy',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrivacyPolicyPage(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 12),
                      _buildMenuItem(
                        context: context,
                        icon: 'assets/icon_me_user_agreement.webp',
                        title: 'User Agreement',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserAgreementPage(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 12),
                      _buildMenuItem(
                        context: context,
                        icon: 'assets/icon_me_setting.webp',
                        title: 'Setting',
                        onTap: _navigateToSetting,
                      ),
                      SizedBox(height: 12),
                      _buildMenuItem(
                        context: context,
                        icon: 'assets/icon_me_about us.webp',
                        title: 'About us',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutUsPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(
              icon,
              width: 48,
              height: 48,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Image.asset(
              'assets/img_me_arrow.webp',
              width: 135,
              height: 34,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
