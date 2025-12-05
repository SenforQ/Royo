import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import '../models/user_profile.dart';
import 'video_page.dart';
import 'figure_chat_page.dart';
import 'figure_call_page.dart';
import 'report_page.dart';
import '../utils/block_storage.dart';
import 'activity_page.dart';

class FigureDetailPage extends StatefulWidget {
  final UserProfile profile;

  const FigureDetailPage({
    super.key,
    required this.profile,
  });

  @override
  State<FigureDetailPage> createState() => _FigureDetailPageState();
}

class _FigureDetailPageState extends State<FigureDetailPage> {
  int _selectedPhotoIndex = 0;
  final PageController _photoPageController = PageController();

  @override
  void dispose() {
    _photoPageController.dispose();
    super.dispose();
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
              // 如果举报成功，返回根视图并刷新
              if (result == true) {
                Navigator.of(context).popUntil((route) => route.isFirst);
                Future.delayed(const Duration(milliseconds: 100), () {
                  final activityState = ActivityPage.of(context);
                  if (activityState != null && activityState.mounted) {
                    activityState.refreshData();
                  }
                });
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
              // 返回根视图并刷新
              Navigator.of(context).popUntil((route) => route.isFirst);
              Future.delayed(const Duration(milliseconds: 100), () {
                final activityState = ActivityPage.of(context);
                if (activityState != null && activityState.mounted) {
                  activityState.refreshData();
                }
              });
            },
            child: const Text('Block'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              await BlockStorage.addMuted(profile.nickName);
              // 返回根视图并刷新
              Navigator.of(context).popUntil((route) => route.isFirst);
              Future.delayed(const Duration(milliseconds: 100), () {
                final activityState = ActivityPage.of(context);
                if (activityState != null && activityState.mounted) {
                  activityState.refreshData();
                }
              });
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
    final profile = widget.profile;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          profile.nickName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          IconButton(
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 22,
              ),
            ),
            onPressed: () => _showActionSheet(context, profile),
          ),
        ],
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // 头像和基本信息
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FigureChatPage(profile: profile),
                            ),
                          );
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                            image: DecorationImage(
                              image: AssetImage(profile.userIcon),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.nickName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              profile.showMotto,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _buildStatItem(
                                  Icons.people_outline,
                                  '${profile.showFollowNum}',
                                  'Followers',
                                ),
                                const SizedBox(width: 20),
                                _buildStatItem(
                                  Icons.favorite_outline,
                                  '${profile.showLike}',
                                  'Likes',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // 操作按钮
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FigureChatPage(profile: profile),
                              ),
                            );
                          },
                          icon: const Icon(Icons.message, size: 20),
                          label: const Text('Message'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5CF6),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FigureCallPage(profile: profile),
                              ),
                            );
                          },
                          icon: const Icon(Icons.videocam, size: 20),
                          label: const Text('Call'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // 背景介绍
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'About',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          profile.showBackground,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // 照片展示
                if (profile.showPhotoArray.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      'Photos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: _photoPageController,
                      itemCount: profile.showPhotoArray.length,
                      onPageChanged: (index) {
                        setState(() {
                          _selectedPhotoIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              profile.showPhotoArray[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 照片指示器
                  if (profile.showPhotoArray.length > 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        profile.showPhotoArray.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _selectedPhotoIndex == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                ],
                // 视频展示
                if (profile.showVideoArray.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      'Videos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: profile.showVideoArray.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPage(
                                  videoPath: profile.showVideoArray[index],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 160,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: AssetImage(
                                  index < profile.showThumbnailArray.length
                                      ? profile.showThumbnailArray[index]
                                      : profile.userIcon,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.black.withOpacity(0.3),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.play_circle_filled,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
                SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

