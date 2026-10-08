import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mock_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  int? expandedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppData>();
    final unresolved = data.alerts.where((a) => !a.acknowledged).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'ACTIVE INCIDENTS  ·  Unresolved: $unresolved'),
          for (int i = 0; i < data.alerts.length; i++) ...[
            _AlertCard(
              alert: data.alerts[i],
              expanded: expandedIndex == i,
              onTap: () => setState(() => expandedIndex = expandedIndex == i ? null : i),
              onAcknowledge: () => setState(() => data.acknowledgeAlert(data.alerts[i], 'System')),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final AlertIncident alert;
  final bool expanded;
  final VoidCallback onTap;
  final VoidCallback onAcknowledge;

  const _AlertCard({
    required this.alert,
    required this.expanded,
    required this.onTap,
    required this.onAcknowledge,
  });

  @override
  Widget build(BuildContext context) {
    final accent = alert.severity == Severity.critical ? AppColors.danger : AppColors.warning;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(width: 4, height: 40, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(alert.id, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
                            const SizedBox(width: 8),
                            SeverityBadge(severity: alert.severity),
                            if (alert.acknowledged) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.success),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(alert.type, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Text('App ID: ${alert.appId}  ·  ${alert.receivedAgo}',
                            style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Icon(expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded, color: AppColors.textMuted),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DeepDiveRow(icon: Icons.dns_rounded, label: 'Target Source ID', value: alert.targetSourceId),
                  _DeepDiveRow(icon: Icons.warning_amber_rounded, label: 'Event Severity', value: alert.eventSeverityLabel, valueColor: accent),
                  _DeepDiveRow(icon: Icons.schedule_rounded, label: 'Timestamp', value: alert.fullTimestampUtc),
                  const SizedBox(height: 10),
                  const Text('PIPELINE EVALUATION INSIGHTS',
                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.brandSecondary, letterSpacing: 0.4)),
                  const SizedBox(height: 8),
                  _DeepDiveRow(icon: Icons.analytics_rounded, label: 'Model A Score (Platt-calibrated)', value: alert.modelAScore.toStringAsFixed(3)),
                  _DeepDiveRow(icon: Icons.category_rounded, label: 'Classified Category', value: alert.modelACategory),
                  _DeepDiveRow(icon: Icons.shield_moon_rounded, label: 'Model B Interception', value: alert.modelBNote),
                  const SizedBox(height: 10),
                  const Text('DOWNSTREAM NOTIFICATIONS',
                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.brandSecondary, letterSpacing: 0.4)),
                  const SizedBox(height: 8),
                  _DeepDiveRow(icon: Icons.forum_rounded, label: 'Webhook', value: alert.webhookStatus),
                  _DeepDiveRow(icon: Icons.mail_rounded, label: 'Email', value: alert.emailStatus),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.replay_rounded, size: 16),
                          label: const Text('Re-test Webhook'),
                          style: OutlinedButton.styleFrom(foregroundColor: AppColors.textSecondary, side: const BorderSide(color: AppColors.border)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: alert.acknowledged ? null : onAcknowledge,
                          icon: Icon(alert.acknowledged ? Icons.check_rounded : Icons.check_circle_outline_rounded, size: 16),
                          label: Text(alert.acknowledged ? 'Acknowledged' : 'Acknowledge'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.black,
                            disabledBackgroundColor: AppColors.surfaceElevated,
                            disabledForegroundColor: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DeepDiveRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  const _DeepDiveRow({required this.icon, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: AppColors.textMuted),
          const SizedBox(width: 8),
          SizedBox(
            width: 130,
            child: Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: valueColor ?? AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}
