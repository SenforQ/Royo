import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import '../models/user_profile.dart';
import 'video_page.dart';
import 'training_plan_page.dart';
import 'report_page.dart';
import '../utils/block_storage.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});
  
  static _ActivityPageState? of(BuildContext context) {
    return context.findAncestorStateOfType<_ActivityPageState>();
  }

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  List<UserProfile> _profiles = [];

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }
  
  // 公共方法用于刷新数据
  void refreshData() {
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/NABI_Chat.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      final List<UserProfile> allProfiles = jsonList.map((json) => UserProfile.fromJson(json)).toList();
      
      // 过滤被拉黑、屏蔽和举报的用户
      final blockedList = await BlockStorage.getBlockedList();
      final mutedList = await BlockStorage.getMutedList();
      final reportedList = await BlockStorage.getReportedList();
      final filteredProfiles = allProfiles.where((profile) {
        return !blockedList.contains(profile.nickName) && 
               !mutedList.contains(profile.nickName) &&
               !reportedList.contains(profile.nickName);
      }).toList();
      
      if (mounted) {
        setState(() {
          _profiles = filteredProfiles;
        });
      }
    } catch (e) {
      print('Error loading profiles: $e');
    }
  }

  void _showActionSheet(BuildContext context, UserProfile profile) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          'Options',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportPage(userName: profile.nickName),
                ),
              );
              // 如果举报成功，重新获取数据并过滤
              if (result == true) {
                // 返回根视图
                Navigator.of(context).popUntil((route) => route.isFirst);
                // 延迟刷新，确保页面已返回
                await Future.delayed(const Duration(milliseconds: 100));
                if (mounted) {
                  await _loadProfiles();
                }
              }
            },
            child: const Text(
              'Report',
              style: TextStyle(color: Colors.red),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              await BlockStorage.addBlocked(profile.nickName);
              // 返回根视图
              Navigator.of(context).popUntil((route) => route.isFirst);
              // 延迟刷新，确保页面已返回
              await Future.delayed(const Duration(milliseconds: 100));
              if (mounted) {
                await _loadProfiles();
              }
            },
            child: const Text('Block'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              await BlockStorage.addMuted(profile.nickName);
              // 返回根视图
              Navigator.of(context).popUntil((route) => route.isFirst);
              // 延迟刷新，确保页面已返回
              await Future.delayed(const Duration(milliseconds: 100));
              if (mounted) {
                await _loadProfiles();
              }
            },
            child: const Text('Mute'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
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
                const SizedBox(height: 66),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'FITNESS ARTICLE',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_profiles.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _profiles.length >= 5 ? 5 : _profiles.length,
                      itemBuilder: (context, index) {
                        final reversedIndex = _profiles.length - 1 - index;
                        final profile = _profiles[reversedIndex];
                        return Padding(
                          padding: EdgeInsets.only(
                            left: index == 0 ? 20 : 8,
                            right: index == (_profiles.length >= 5 ? 4 : _profiles.length - 1) ? 20 : 8,
                          ),
                          child: _buildArticleCard(profile, reversedIndex),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 40),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'EVENT HUB',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildEventList(),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 120),
              ],
            ),
              ),
              // 左上角返回按钮
              Positioned(
                top: 20,
                left: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
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
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleCard(UserProfile profile, int index) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to article detail
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(profile.showPhotoArray.isNotEmpty 
                ? profile.showPhotoArray[0] 
                : profile.userIcon),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 12,
              left: 12,
              child: GestureDetector(
                onTap: () => _showActionSheet(context, profile),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  profile.showMotto,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Image.asset(
                'assets/icon_activity_enter.webp',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  if (profile.showVideoArray.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPage(
                          videoPath: profile.showVideoArray[0],
                          nickname: profile.nickName,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList() {
    if (_profiles.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final cellWidth = screenWidth - 40;
        final cellHeight = cellWidth * 0.8;

        final reversedProfiles = _profiles.reversed.toList();
        
        return Column(
          children: List.generate(reversedProfiles.length, (index) {
            final profile = reversedProfiles[index];
            final isEven = (index + 1) % 2 == 0;
            final bgImage = isEven 
                ? 'assets/img_activity_one_two.webp' 
                : 'assets/img_activity_one_bg.webp';
            
            final isJoined = index % 3 == 0;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrainingPlanPage(profile: profile),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                width: cellWidth,
                height: cellHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(bgImage),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
            clipBehavior: Clip.none,
            children: [
             
              Positioned(
                top: 48,
                left: 5,
                right: 5,
                bottom: 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    profile.showPhotoArray.length > 1
                        ? profile.showPhotoArray[1] 
                        : (profile.showPhotoArray.isNotEmpty 
                            ? profile.showPhotoArray[0] 
                            : profile.userIcon),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

               Positioned(
                top:60,
                left: 12,
                child: GestureDetector(
                  onTap: () => _showActionSheet(context, profile),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.showMotto,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        profile.showBackground,
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
              ),

            ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
