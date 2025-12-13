import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../utils/user_storage.dart';
import '../services/coin_service.dart';
import 'wallet_page.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _hasPaidForSession = false; // Whether coins have been deducted for this session
  bool _isInitializing = true; // Whether initializing (deducting coins)
  String? _userAvatarPath;
  File? _userAvatarFile;

  static const String _apiKey = 'ae696b3404b54c82aab34d3b0531d271.XZOQoxGmoHaj5ztY';
  static const String _apiUrl = 'https://open.bigmodel.cn/api/paas/v4/chat/completions';

  @override
  void initState() {
    super.initState();
    _loadUserAvatar();
    // Deduct 200 Coins every time entering the page
    _initializeAndDeductCoins();
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

  Future<void> _initializeAndDeductCoins() async {
    setState(() {
      _isInitializing = true;
    });

    // Deduct 200 Coins
    final ok = await _deductCoinsAndConfirm(
      cost: 200,
      featureName: 'AI Coach',
    );

    if (!mounted) return;

    if (!ok) {
      // Insufficient balance, return to previous page
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _hasPaidForSession = true;
      _isInitializing = false;
    });

    // Add AI welcome message
    _messages.add(ChatMessage(
      text: 'Hello! I\'m your AI fitness assistant. How can I help you with your workout today?',
      isUser: false,
      timestamp: DateTime.now(),
      showQuickButtons: true, // Mark to show quick buttons
    ));
    // Delay scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isLoading || _isInitializing) return;

    // Add user message
    setState(() {
      // Hide all quick buttons
      for (var msg in _messages) {
        msg.showQuickButtons = false;
      }
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
        showQuickButtons: false,
      ));
      _isLoading = true;
    });
    _messageController.clear();
    _scrollToBottom();

    try {
      // Build system prompt to make AI act as fitness assistant
      final systemPrompt = '''You are a professional AI fitness assistant. You help users with:
- Workout plans and exercise recommendations
- Fitness tips and motivation
- Nutrition advice related to fitness
- Answering questions about health and exercise
Please respond in English, be helpful, encouraging, and professional. Keep responses concise and practical.''';

      // Build message history
      final List<Map<String, String>> messages = [
        {'role': 'system', 'content': systemPrompt},
      ];

      // Add conversation history (last 10 messages)
      final recentMessages = _messages.length > 10 
          ? _messages.sublist(_messages.length - 10)
          : _messages;
      
      for (var msg in recentMessages) {
        messages.add({
          'role': msg.isUser ? 'user' : 'assistant',
          'content': msg.text,
        });
      }

      // Call Zhipu AI API
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': 'glm-4-flash',
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 1000,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final aiResponse = data['choices'][0]['message']['content'] as String;
        
        setState(() {
          _messages.add(ChatMessage(
            text: aiResponse,
            isUser: false,
            timestamp: DateTime.now(),
            showQuickButtons: false,
          ));
          _isLoading = false;
        });
        _scrollToBottom();
      } else {
        throw Exception('API request failed: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Sorry, I encountered an error. Please try again.',
          isUser: false,
          timestamp: DateTime.now(),
          showQuickButtons: false,
        ));
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  Future<bool> _deductCoinsAndConfirm({
    required int cost,
    required String featureName,
  }) async {
    final success = await CoinService.deductCoins(cost);
    if (success) return true;

    if (!mounted) return false;
    final current = await CoinService.getCurrentCoins();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1C191D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Coins Not Enough',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          '$featureName requires $cost Coins.\nCurrent balance: $current Coins.',
          style: const TextStyle(color: Colors.white70, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Later', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const WalletPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF420372),
              foregroundColor: Colors.white,
            ),
            child: const Text('Top Up'),
          ),
        ],
      ),
    );
    return false;
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
                image: const DecorationImage(
                  image: AssetImage('assets/ai_icon.webp'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'AI Assistant',
              style: TextStyle(
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
            children: [
              // Message list
              Expanded(
                child: _isInitializing
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return _buildMessageBubble(message);
                  },
                ),
              ),
              // Input box
              if (!_isInitializing)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: TextField(
                            controller: _messageController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            maxLines: null,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _isLoading ? null : _sendMessage,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _isLoading 
                                ? Colors.grey.withOpacity(0.5)
                                : const Color(0xFF8B5CF6),
                            shape: BoxShape.circle,
                          ),
                          child: _isLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 24,
                                ),
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

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: message.isUser 
            ? CrossAxisAlignment.end 
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: message.isUser 
                ? MainAxisAlignment.end 
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.isUser) ...[
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
                      image: AssetImage('assets/ai_icon.webp'),
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
                    color: message.isUser
                        ? const Color(0xFF8B5CF6)
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(message.isUser ? 18 : 4),
                      bottomRight: Radius.circular(message.isUser ? 4 : 18),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
                image: _userAvatarFile != null
                    ? DecorationImage(
                        image: FileImage(_userAvatarFile!),
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: AssetImage('assets/user_default_img.webp'),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ],
            ],
          ),
          // Quick question buttons (only shown when AI message and showQuickButtons is true)
          if (!message.isUser && message.showQuickButtons) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 44),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuickButton('1: Workout Plan', 'What should be included in each workout plan?'),
                  const SizedBox(height: 8),
                  _buildQuickButton('2: How to Exercise', 'How should I exercise and train?'),
                  const SizedBox(height: 8),
                  _buildQuickButton('3: Diet Tips', 'What should I pay attention to in my diet?'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickButton(String label, String question) {
    return GestureDetector(
      onTap: () {
        // Automatically send corresponding question
        _messageController.text = question;
        _sendMessage();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.7),
              size: 14,
            ),
          ],
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

