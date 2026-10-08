import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class WritePromptScreen extends StatefulWidget {
  const WritePromptScreen({super.key});

  @override
  State<WritePromptScreen> createState() => _WritePromptScreenState();
}

class _WritePromptScreenState extends State<WritePromptScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppData>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluate Prompt'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'INPUT PROMPT'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Enter prompt to test firewall rules...',
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: data.isChecking 
                          ? null 
                          : () async {
                              if (_controller.text.trim().isNotEmpty) {
                                await data.checkPrompt(_controller.text.trim());
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Prompt evaluated successfully!')),
                                );
                              }
                            },
                        icon: data.isChecking 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.security_rounded),
                        label: Text(data.isChecking ? 'SCANNING...' : 'CHECK PROMPT'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (data.lastManualEvaluation != null) ...[
              const SizedBox(height: 24),
              const SectionHeader(title: 'LATEST EVALUATION RESULT'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Verdict', style: TextStyle(fontWeight: FontWeight.w600)),
                          VerdictBadge(verdict: data.lastManualEvaluation!.verdict),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Security Score', style: TextStyle(fontWeight: FontWeight.w600)),
                          Text(
                            data.lastManualEvaluation!.score.toStringAsFixed(3),
                            style: TextStyle(
                              color: data.lastManualEvaluation!.score >= data.blockThreshold
                                  ? AppColors.danger
                                  : AppColors.success,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Detected Threat', style: TextStyle(fontWeight: FontWeight.w600)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: data.lastManualEvaluation!.detectedEntity == 'None' 
                                  ? AppColors.successBg 
                                  : AppColors.dangerBg,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              data.lastManualEvaluation!.detectedEntity,
                              style: TextStyle(
                                color: data.lastManualEvaluation!.detectedEntity == 'None' 
                                    ? AppColors.success 
                                    : AppColors.danger,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Masked Snapshot', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.textMuted)),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          data.lastManualEvaluation!.maskedSnapshot,
                          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
