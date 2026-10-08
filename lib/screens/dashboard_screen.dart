import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mock_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import 'write_prompt_screen.dart';
import 'policy_config_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppData>();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'ACTIONS'),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    leading: const Icon(Icons.edit_note_rounded, color: AppColors.brandPrimary, size: 24),
                    title: const Text('Write Prompt', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const WritePromptScreen()),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    leading: const Icon(Icons.delete_sweep_rounded, color: AppColors.danger, size: 24),
                    title: const Text('Clear History', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: AppColors.surface,
                          title: const Text('Clear History?'),
                          content: const Text('This will reset your stats and remove all audit logs.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCEL')),
                            TextButton(
                              onPressed: () {
                                data.clearHistory();
                                Navigator.pop(ctx);
                              },
                              child: const Text('CLEAR', style: TextStyle(color: AppColors.danger)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          if (data.lastManualEvaluation != null) ...[
            const SizedBox(height: 16),
            const SectionHeader(title: 'LIVE PROMPT STATUS'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: data.lastManualEvaluation!.verdict == Verdict.blocked
                            ? AppColors.dangerBg
                            : AppColors.successBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        data.lastManualEvaluation!.verdict == Verdict.blocked
                            ? Icons.block_flipped
                            : Icons.check_circle_outline_rounded,
                        color: data.lastManualEvaluation!.verdict == Verdict.blocked
                            ? AppColors.danger
                            : AppColors.success,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.lastManualEvaluation!.verdict == Verdict.blocked ? 'BLOCKED' : 'PASSED',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                              color: data.lastManualEvaluation!.verdict == Verdict.blocked
                                  ? AppColors.danger
                                  : AppColors.success,
                            ),
                          ),
                          Text(
                            'Threat: ${data.lastManualEvaluation!.detectedEntity}',
                            style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Score: ${data.lastManualEvaluation!.score.toStringAsFixed(3)}',
                            style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    const VerticalDivider(),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: Text(
                        data.lastManualEvaluation!.maskedSnapshot,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          const SectionHeader(title: 'YOUR EVALUATION STATS'),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.35,
            children: data.userStats.map((s) => StatCard(stat: s)).toList(),
          ),
        ],
      ),
    );
  }
}
