import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user_profile.dart';
import 'figure_detail_page.dart';

class TrainingPlanPage extends StatelessWidget {
  final UserProfile profile;

  const TrainingPlanPage({
    super.key,
    required this.profile,
  });

  List<Map<String, String>> _parseWeeks(String planText) {
    // 解析 "Week X: Description" 格式
    final List<Map<String, String>> weekList = [];
    final regex = RegExp(r'Week (\d+):\s*(.+?)(?=Week \d+:|$)');
    final matches = regex.allMatches(planText);
    
    for (final match in matches) {
      if (match.groupCount >= 2) {
        weekList.add({
          'week': match.group(1) ?? '',
          'content': match.group(2)?.trim() ?? '',
        });
      }
    }
    
    // 如果没有匹配到，尝试简单分割
    if (weekList.isEmpty) {
      final parts = planText.split(RegExp(r'Week \d+:'));
      for (int i = 1; i < parts.length; i++) {
        final content = parts[i].trim();
        if (content.isNotEmpty) {
          weekList.add({
            'week': i.toString(),
            'content': content,
          });
        }
      }
    }
    
    return weekList;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final workoutPlan = profile.showWorkoutPlan1Month;
    
    if (workoutPlan == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Training Plan'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const Center(
          child: Text('No training plan available'),
        ),
      );
    }

    final weeks = _parseWeeks(workoutPlan.plan);
    final photos = profile.showPhotoArray;

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
        title: const Text(
          'Article Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
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
                // Author Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
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
                          width: 50,
                          height: 50,
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Article Author',
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile.nickName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Article Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    profile.showMotto,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Content with weeks and photos
                ...weeks.asMap().entries.expand((entry) {
                  final weekIndex = entry.key;
                  final weekData = entry.value;
                  final weekContent = weekData['content'] ?? '';
                  final photoIndex = weekIndex < photos.length 
                      ? weekIndex 
                      : weekIndex % photos.length;
                  
                  final List<Widget> widgets = [];
                  
                  // Week content section
                  widgets.add(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Step ${weekIndex + 1}: Week ${weekData['week']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Photo
                        if (photoIndex < photos.length)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                photos[photoIndex],
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        // Week content as bullet points
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: weekContent.split('.').where((s) => s.trim().isNotEmpty).map((point) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '• ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        point.trim(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  );
                  
                  // Add photo between weeks (except after last week)
                  if (weekIndex < weeks.length - 1) {
                    final nextPhotoIndex = (weekIndex + 1) < photos.length 
                        ? (weekIndex + 1) 
                        : (weekIndex + 1) % photos.length;
                    if (nextPhotoIndex < photos.length) {
                      widgets.add(
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              photos[nextPhotoIndex],
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }
                  }
                  
                  return widgets;
                }).toList(),
                // Insight section
                if (workoutPlan.insight.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Training Insight',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            workoutPlan.insight,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                SizedBox(height: MediaQuery.of(context).padding.bottom + 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

