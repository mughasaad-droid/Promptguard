import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mock_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class AuditLogsScreen extends StatefulWidget {
  const AuditLogsScreen({super.key});

  @override
  State<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends State<AuditLogsScreen> {
  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppData>();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                if (data.auditLogs.isEmpty) return;
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: AppColors.surface,
                    title: const Text('Clear Audit Logs?'),
                    content: const Text('This will permanently delete all logs in this session.'),
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
              icon: const Icon(Icons.delete_sweep_rounded, size: 18),
              label: const Text('CLEAR LOG HISTORY'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.danger,
                side: const BorderSide(color: AppColors.danger),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SectionHeader(title: 'AUDITED TRANSACTION LEDGER  ·  ${data.auditLogs.length} rows'),
          Card(
            child: data.auditLogs.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.history_rounded, size: 48, color: AppColors.textMuted),
                          SizedBox(height: 12),
                          Text('No logs found', style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w600)),
                          Text('Run an evaluation to see results', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      for (final e in data.auditLogs) ...[
                        _AuditLogTile(entry: e),
                        if (e != data.auditLogs.last) const Divider(height: 1),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _AuditLogTile extends StatelessWidget {
  final AuditLogEntry entry;
  const _AuditLogTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final scoreColor = entry.score >= 0.5 ? AppColors.danger : AppColors.success;
    return InkWell(
      onTap: () => _showHashSheet(context, entry),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(entry.timestamp, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                const SizedBox(width: 8),
                Text(entry.evaluationId, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
                const Spacer(),
                VerdictBadge(verdict: entry.verdict),
                const SizedBox(width: 8),
                Text(entry.score.toStringAsFixed(2), style: TextStyle(color: scoreColor, fontSize: 12.5, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 8),
            Text(entry.maskedSnapshot, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontStyle: FontStyle.italic)),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.fingerprint_rounded, size: 13, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text('Entity: ${entry.detectedEntity}', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                const Spacer(),
                const Icon(Icons.visibility_rounded, size: 13, color: AppColors.brandSecondary),
                const SizedBox(width: 4),
                const Text('hash', style: TextStyle(color: AppColors.brandSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showHashSheet(BuildContext context, AuditLogEntry entry) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lock_rounded, size: 16, color: AppColors.brandSecondary),
                SizedBox(width: 8),
                Text('PRIVACY SHIELD', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 10),
            Text('Prompt SHA-256:', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
            const SizedBox(height: 4),
            SelectableText(entry.promptSha256, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12.5)),
            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 13, color: AppColors.textMuted),
                SizedBox(width: 6),
                Text('Row plaintext data never stored', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
