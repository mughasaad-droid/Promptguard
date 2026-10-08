/// Core data models mirroring the SDS schema (Section 5.2 Schema Tables,
/// Section 6 API Design). In this prototype they're populated with mock
/// data via MockData; swap the sourcing in `mock_data.dart` for real
/// `/api/v1/...` calls once the backend is live.
library;

enum Verdict { safe, blocked }

enum Severity { critical, warning }

enum PolicyAction { pass, hardBlock }

extension VerdictX on Verdict {
  String get label => this == Verdict.safe ? 'PASSED' : 'BLOCKED';
}

extension PolicyActionX on PolicyAction {
  String get label => switch (this) {
        PolicyAction.pass => 'PASS',
        PolicyAction.hardBlock => 'HARD BLOCK',
      };
}

class QuickStat {
  final String label;
  final String value;
  final String subtitle;
  final bool subtitleIsPositive;

  const QuickStat({
    required this.label,
    required this.value,
    required this.subtitle,
    this.subtitleIsPositive = true,
  });
}

class ThreatTrendPoint {
  final String day;
  final double injection;
  final double jailbreak;
  final double instructionOverride;

  const ThreatTrendPoint({
    required this.day,
    required this.injection,
    required this.jailbreak,
    required this.instructionOverride,
  });
}

class LiveViolation {
  final String time;
  final String clientId;
  final Verdict verdict;
  final String category;

  const LiveViolation({
    required this.time,
    required this.clientId,
    required this.verdict,
    required this.category,
  });
}

class AuditLogEntry {
  final String timestamp;
  final String evaluationId;
  final Verdict verdict;
  final double score;
  final String maskedSnapshot;
  final String detectedEntity;
  final String promptSha256;

  const AuditLogEntry({
    required this.timestamp,
    required this.evaluationId,
    required this.verdict,
    required this.score,
    required this.maskedSnapshot,
    required this.detectedEntity,
    required this.promptSha256,
  });

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'evaluationId': evaluationId,
      'verdict': verdict.index,
      'score': score,
      'maskedSnapshot': maskedSnapshot,
      'detectedEntity': detectedEntity,
      'promptSha256': promptSha256,
      'serverTimestamp': DateTime.now().toIso8601String(), // For ordering
    };
  }

  factory AuditLogEntry.fromMap(Map<String, dynamic> map) {
    return AuditLogEntry(
      timestamp: map['timestamp'] ?? '',
      evaluationId: map['evaluationId'] ?? '',
      verdict: Verdict.values[map['verdict'] ?? 0],
      score: (map['score'] ?? 0.0).toDouble(),
      maskedSnapshot: map['maskedSnapshot'] ?? '',
      detectedEntity: map['detectedEntity'] ?? '',
      promptSha256: map['promptSha256'] ?? '',
    );
  }
}

class AlertIncident {
  final String id;
  final Severity severity;
  final String type;
  final String appId;
  final String receivedAgo;
  final String targetSourceId;
  final String eventSeverityLabel;
  final String fullTimestampUtc;
  final double modelAScore;
  final String modelACategory;
  final String modelBNote;
  final String webhookStatus;
  final String emailStatus;
  bool acknowledged;

  AlertIncident({
    required this.id,
    required this.severity,
    required this.type,
    required this.appId,
    required this.receivedAgo,
    required this.targetSourceId,
    required this.eventSeverityLabel,
    required this.fullTimestampUtc,
    required this.modelAScore,
    required this.modelACategory,
    required this.modelBNote,
    required this.webhookStatus,
    required this.emailStatus,
    this.acknowledged = false,
  });
}

class PolicyEntity {
  final String name;
  PolicyAction action;

  PolicyEntity({required this.name, required this.action});
}
