import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class PolicyConfigScreen extends StatelessWidget {
  const PolicyConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppData>();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'MODEL A CONFIGURATION:'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Hard Block Score Threshold', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.brandPrimary, borderRadius: BorderRadius.circular(20)),
                        child: Text(data.blockThreshold.toStringAsFixed(2),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
                      ),
                    ],
                  ),
                  Slider(
                    value: data.blockThreshold,
                    min: 0,
                    max: 1,
                    divisions: 20,
                    label: data.blockThreshold.toStringAsFixed(2),
                    onChanged: (v) => data.setBlockThreshold(v),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('0.0', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                      Text('1.0', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.surfaceElevated, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline_rounded, size: 15, color: AppColors.brandSecondary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Current selection: ${data.blockThreshold.toStringAsFixed(2)} → prompts scoring ≥ this value trigger an immediate fail-closed drop.',
                            style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          const SectionHeader(title: 'MODEL B CONFIGURATION:'),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: [
                  for (final entity in data.policyEntities) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      child: Row(
                        children: [
                          Icon(_iconFor(entity.name), size: 16, color: AppColors.textMuted),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(entity.name, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                          ),
                          PolicyActionDropdown(
                            value: entity.action,
                            onChanged: (a) => data.setPolicyAction(entity, a),
                          ),
                        ],
                      ),
                    ),
                    if (entity != data.policyEntities.last) const Divider(height: 1, indent: 14, endIndent: 14),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: 'SAVE AND DEPLOY RUNTIME REVISIONS'),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: data.policyDirty
                  ? () {
                      data.commitPolicyChanges();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Configuration committed — rolling deploy triggered.')),
                      );
                    }
                  : null,
              icon: const Icon(Icons.cloud_upload_rounded, size: 18),
              label: const Text('COMMIT CONFIGURATION REVISIONS'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandPrimary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.surfaceElevated,
                disabledForegroundColor: AppColors.textMuted,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String entity) => switch (entity) {
        'EMAIL' => Icons.email_rounded,
        'PHONE_NUM' => Icons.phone_rounded,
        'API_KEY' => Icons.vpn_key_rounded,
        'CREDIT_CARD' => Icons.credit_card_rounded,
        'PASSWORD' => Icons.password_rounded,
        'SALARY' => Icons.payments_rounded,
        'CLIENT_NAME' => Icons.badge_rounded,
        'EMPLOYEE_ID' => Icons.perm_identity_rounded,
        _ => Icons.data_object_rounded,
      };
}
