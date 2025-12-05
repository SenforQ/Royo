import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ExerciseActivitiesPage extends StatefulWidget {
  const ExerciseActivitiesPage({super.key});

  @override
  State<ExerciseActivitiesPage> createState() => _ExerciseActivitiesPageState();
}

class _ExerciseActivitiesPageState extends State<ExerciseActivitiesPage> {
  final ImagePicker _picker = ImagePicker();
  File? _workoutPhoto;
  final TextEditingController _exerciseTypeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _paceController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;
  int _selectedDay = DateTime.now().day;

  @override
  void initState() {
    super.initState();
    _updateSelectedDate();
  }

  void _updateSelectedDate() {
    _selectedDate = DateTime(_selectedYear, _selectedMonth, _selectedDay);
  }

  @override
  void dispose() {
    _exerciseTypeController.dispose();
    _durationController.dispose();
    _paceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _workoutPhoto = File(image.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _selectYear() async {
    final int? picked = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Year'),
          content: SizedBox(
            width: 200,
            height: 300,
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                final year = DateTime.now().year - 5 + index;
                return ListTile(
                  title: Text(year.toString()),
                  onTap: () => Navigator.pop(context, year),
                );
              },
            ),
          ),
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _selectedYear = picked;
        _updateSelectedDate();
      });
    }
  }

  Future<void> _selectMonth() async {
    final int? picked = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Month'),
          content: SizedBox(
            width: 200,
            height: 300,
            child: ListView.builder(
              itemCount: 12,
              itemBuilder: (context, index) {
                final month = index + 1;
                return ListTile(
                  title: Text(month.toString().padLeft(2, '0')),
                  onTap: () => Navigator.pop(context, month),
                );
              },
            ),
          ),
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _selectedMonth = picked;
        _updateSelectedDate();
      });
    }
  }

  Future<void> _selectDay() async {
    // 计算该月的最大天数
    final daysInMonth = DateTime(_selectedYear, _selectedMonth + 1, 0).day;
    
    final int? picked = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Day'),
          content: SizedBox(
            width: 200,
            height: 300,
            child: ListView.builder(
              itemCount: daysInMonth,
              itemBuilder: (context, index) {
                final day = index + 1;
                return ListTile(
                  title: Text(day.toString().padLeft(2, '0')),
                  onTap: () => Navigator.pop(context, day),
                );
              },
            ),
          ),
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _selectedDay = picked;
        _updateSelectedDate();
      });
    }
  }

  Future<void> _saveWorkout() async {
    // 验证必填字段
    if (_exerciseTypeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter exercise type'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_durationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter exercise duration'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // TODO: 保存数据到本地存储或服务器
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Workout saved successfully'),
        duration: Duration(seconds: 2),
      ),
    );
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Add your workout check-in photo
                const Text(
                  'Add your workout check-in photo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF8B5CF6),
                        width: 2,
                      ),
                    ),
                    child: _workoutPhoto != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _workoutPhoto!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.add_photo_alternate,
                              color: Color(0xFF8B5CF6),
                              size: 48,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                // Add exercise type
                const Text(
                  'Add exercise type',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF8B5CF6),
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    controller: _exerciseTypeController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Swimming',
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Enter exercise duration
                const Text(
                  'Enter exercise duration',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF8B5CF6),
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    controller: _durationController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '45mins',
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Choose exercise time
                const Text(
                  'Choose exercise time',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _selectYear,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF8B5CF6),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _selectedYear.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '-',
                        style: TextStyle(
                          color: Color(0xFF8B5CF6),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: _selectMonth,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF8B5CF6),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _selectedMonth.toString().padLeft(2, '0'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '-',
                        style: TextStyle(
                          color: Color(0xFF8B5CF6),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: _selectDay,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF8B5CF6),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _selectedDay.toString().padLeft(2, '0'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Enter your workout pace
                const Text(
                  'Enter your workout pace',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF8B5CF6),
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    controller: _paceController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: '10:00/km',
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Done button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveWorkout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

