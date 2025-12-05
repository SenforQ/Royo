import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/user_profile.dart';
import '../utils/user_storage.dart';

class FigureChatPage extends StatefulWidget {
  final UserProfile profile;

  const FigureChatPage({
    super.key,
    required this.profile,
  });

  @override
  State<FigureChatPage> createState() => _FigureChatPageState();
}

class _FigureChatPageState extends State<FigureChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _userAvatarPath;
  File? _userAvatarFile;

  static const String _apiKey = 'ae696b3404b54c82aab34d3b0531d271.XZOQoxGmoHaj5ztY';
  static const String _apiUrl = 'https://open.bigmodel.cn/api/paas/v4/chat/completions';

  @override
  void initState() {
    super.initState();
    _loadUserAvatar();
    // 添加角色的欢迎消息
    _messages.add(ChatMessage(
      text: widget.profile.showSayhi,
      isUser: false,
      timestamp: DateTime.now(),
    ));
    // 延迟滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadUserAvatar() async {
    final avatarPath = await UserStorage.getAvatarPath();
    
    setState(() {
      _userAvatarPath = avatarPath;
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
          _userAvatarFile = file;
        });
      }
    } catch (e) {
      print('Error loading avatar file: $e');
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isLoading) return;

    // 添加用户消息
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _messageController.clear();
      _isLoading = true;
    });

    // 滚动到底部
    _scrollToBottom();

    try {
      // 构建消息历史
      final List<Map<String, String>> messages = [
        {
          'role': 'system',
          'content': 'You are ${widget.profile.nickName}, a fitness enthusiast. ${widget.profile.showBackground}. Respond in English, be friendly and helpful about fitness topics.',
        },
      ];

      // 添加历史消息（最近10条）
      final recentMessages = _messages.length > 10
          ? _messages.sublist(_messages.length - 10)
          : _messages;
      
      for (var msg in recentMessages) {
        messages.add({
          'role': msg.isUser ? 'user' : 'assistant',
          'content': msg.text,
        });
      }

      // 调用API
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': 'GLM-4-Flash',
          'messages': messages,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final aiResponse = data['choices'][0]['message']['content'] as String;

        setState(() {
          _messages.add(ChatMessage(
            text: aiResponse,
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isLoading = false;
        });
      } else {
        throw Exception('API request failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending message: $e');
      setState(() {
        _messages.add(ChatMessage(
          text: 'Sorry, I encountered an error. Please try again.',
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
    }

    // 滚动到底部
    _scrollToBottom();
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            // AI头像
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
                image: DecorationImage(
                  image: AssetImage(widget.profile.userIcon),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? const Color(0xFF8B5CF6)
                    : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            // 用户头像
            if (_userAvatarFile != null)
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  image: DecorationImage(
                    image: FileImage(_userAvatarFile!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  image: const DecorationImage(
                    image: AssetImage('assets/user_default_img.webp'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                image: DecorationImage(
                  image: AssetImage(widget.profile.userIcon),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              widget.profile.nickName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/base_page_content_bg.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 20, bottom: 16),
                  itemCount: _messages.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length) {
                      // 加载指示器
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }
                    return _buildMessageBubble(_messages[index]);
                  },
                ),
              ),
              // 输入框
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _isLoading ? null : _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  bool showQuickButtons;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.showQuickButtons = false,
  });
}


