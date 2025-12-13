import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../utils/bmi_storage.dart';

class BmiInputPage extends StatefulWidget {
  const BmiInputPage({super.key});

  @override
  State<BmiInputPage> createState() => _BmiInputPageState();
}

class _BmiInputPageState extends State<BmiInputPage> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSave() async {
    final text = _controller.text.trim();
    final value = double.tryParse(text);
    if (value == null || value <= 0 || value > 80) {
      setState(() {
        _errorText = 'Please enter a valid BMI value (0 - 80)';
      });
      return;
    }
    await BmiStorage.setCurrentBmi(value);
    Navigator.pop<double>(context, value);
  }

  void _showHistory() async {
    final history = await BmiStorage.getBmiHistory();
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => _BmiHistoryDialog(history: history),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter BMI'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _showHistory,
            child: const Text(
              'History',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF7C4DFF),
              Color(0xFF512DA8),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter your BMI value',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Please enter your BMI value obtained from a reliable medical source or healthcare provider.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          final uri = Uri.parse('https://www.cdc.gov/healthyweight/assessing/bmi/index.html');
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'BMI Reference: ',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              'CDC BMI Information',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.open_in_new,
                              color: Colors.white,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'e.g. 21.3',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.4)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white, width: 1.5),
                    ),
                    errorText: _errorText,
                  ),
                  onChanged: (_) {
                    if (_errorText != null) {
                      setState(() {
                        _errorText = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF512DA8),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _onSave,
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withOpacity(0.6)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, null),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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

class _BmiHistoryDialog extends StatelessWidget {
  final List<BmiHistoryEntry> history;

  const _BmiHistoryDialog({required this.history});

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (date == today) {
      return 'Today ${DateFormat('HH:mm').format(dateTime)}';
    } else if (date == today.subtract(const Duration(days: 1))) {
      return 'Yesterday ${DateFormat('HH:mm').format(dateTime)}';
    } else {
      return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
    }
  }

  String _getBmiStatus(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 25) {
      return 'Normal';
    } else if (bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  Color _getBmiStatusColor(double bmi) {
    if (bmi < 18.5) {
      return Colors.blue;
    } else if (bmi < 25) {
      return Colors.green;
    } else if (bmi < 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF7C4DFF),
              Color(0xFF512DA8),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'BMI History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            if (history.isEmpty)
              Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(
                      Icons.history,
                      size: 64,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No history yet',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final entry = history[index];
                    final status = _getBmiStatus(entry.value);
                    final statusColor = _getBmiStatusColor(entry.value);
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      entry.value.toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: statusColor,
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        status,
                                        style: TextStyle(
                                          color: statusColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _formatDateTime(entry.dateTime),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            if (history.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: () async {
                    await BmiStorage.clearHistory();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('History cleared'),
                          backgroundColor: Colors.black87,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Clear History',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
