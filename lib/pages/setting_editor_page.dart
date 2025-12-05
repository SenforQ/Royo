import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../utils/user_storage.dart';

class SettingEditorPage extends StatefulWidget {
  const SettingEditorPage({super.key});

  @override
  State<SettingEditorPage> createState() => _SettingEditorPageState();
}

class _SettingEditorPageState extends State<SettingEditorPage> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _signatureController = TextEditingController();
  String? _avatarPath;
  File? _avatarFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _loadUserInfo() async {
    final nickname = await UserStorage.getNickname();
    final signature = await UserStorage.getSignature();
    final avatarPath = await UserStorage.getAvatarPath();

    setState(() {
      _nicknameController.text = nickname;
      _signatureController.text = signature;
      _avatarPath = avatarPath;
      if (avatarPath != null) {
        _loadAvatarFile(avatarPath);
      }
    });
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

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        await _saveImageToSandbox(image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _saveImageToSandbox(String imagePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final avatarDir = Directory(path.join(directory.path, 'avatars'));
      if (!await avatarDir.exists()) {
        await avatarDir.create(recursive: true);
      }

      final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final relativePath = path.join('avatars', fileName);
      final targetPath = path.join(directory.path, relativePath);

      final sourceFile = File(imagePath);
      final targetFile = await sourceFile.copy(targetPath);

      setState(() {
        _avatarFile = targetFile;
        _avatarPath = relativePath;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving image: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _saveUserInfo() async {
    if (_nicknameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nickname cannot be empty'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await UserStorage.setNickname(_nicknameController.text.trim());
      await UserStorage.setSignature(_signatureController.text.trim());
      
      if (_avatarPath != null) {
        await UserStorage.setAvatarPath(_avatarPath!);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saved successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Setting'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF8B5CF6),
                            width: 3,
                          ),
                          image: _avatarFile != null
                              ? DecorationImage(
                                  image: FileImage(_avatarFile!),
                                  fit: BoxFit.cover,
                                )
                              : const DecorationImage(
                                  image: AssetImage('assets/user_default_img.webp'),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFF8B5CF6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _nicknameController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Nickname',
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF8B5CF6),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF8B5CF6),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _signatureController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Signature',
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF8B5CF6),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF8B5CF6),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveUserInfo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

