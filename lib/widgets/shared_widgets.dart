import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

/// Small badge for SAFE/BLOCKED/PASSED-style verdicts, reused on the
/// Dashboard live stream and Audit Log rows.
class VerdictBadge extends StatelessWidget {
  final Verdict verdict;
  const VerdictBadge({super.key, required this.verdict});

  @override
  Widget build(BuildContext context) {
    final isBlocked = verdict == Verdict.blocked;
    final color = isBlocked ? AppColors.danger : AppColors.success;
    final bg = isBlocked ? AppColors.dangerBg : AppColors.successBg;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        verdict.label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.3),
      ),
    );
  }
}

/// Severity badge for the Alert Inbox (CRITICAL / WARNING).
class SeverityBadge extends StatelessWidget {
  final Severity severity;
  const SeverityBadge({super.key, required this.severity});

  @override
  Widget build(BuildContext context) {
    final isCritical = severity == Severity.critical;
    final color = isCritical ? AppColors.danger : AppColors.warning;
    final bg = isCritical ? AppColors.dangerBg : AppColors.warningBg;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        isCritical ? 'CRITICAL' : 'WARNING',
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.3),
      ),
    );
  }
}

/// 2x2 quick-stat tile used on the Dashboard.
class StatCard extends StatelessWidget {
  final QuickStat stat;
  const StatCard({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    final subtitleColor = stat.subtitle.startsWith('↓')
        ? AppColors.success
        : stat.subtitle.startsWith('↑')
            ? AppColors.brandSecondary
            : AppColors.textMuted;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              stat.label,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 10.5, fontWeight: FontWeight.w700, letterSpacing: 0.4),
            ),
            const SizedBox(height: 10),
            Text(
              stat.value,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              stat.subtitle,
              style: TextStyle(color: subtitleColor, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section header with a title and optional trailing widget, used to
/// introduce each card block on a screen.
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const SectionHeader({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 0.3),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Rounded role/user badge shown in the app bar (e.g. "SA" / "CO").
class RoleBadge extends StatelessWidget {
  final String initials;
  final String label;
  const RoleBadge({super.key, required this.initials, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: AppColors.brandPrimary,
            child: Text(initials, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white)),
          ),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

/// The PromptGuard shield logo mark used in app bars.
class BrandMark extends StatelessWidget {
  final double size;
  const BrandMark({super.key, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.brandPrimary, AppColors.brandSecondary]),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.shield_rounded, size: size * 0.6, color: Colors.white),
    );
  }
}

/// Dropdown used in the Policy Config governance matrix.
class PolicyActionDropdown extends StatelessWidget {
  final PolicyAction value;
  final ValueChanged<PolicyAction> onChanged;
  const PolicyActionDropdown({super.key, required this.value, required this.onChanged});

  Color _colorFor(PolicyAction a) => switch (a) {
        PolicyAction.hardBlock => AppColors.danger,
        PolicyAction.pass => AppColors.brandSecondary,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PolicyAction>(
          value: value,
          isDense: true,
          dropdownColor: AppColors.surfaceElevated,
          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: _colorFor(value)),
          items: PolicyAction.values
              .map((a) => DropdownMenuItem(value: a, child: Text(a.label, style: TextStyle(color: _colorFor(a)))))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}
