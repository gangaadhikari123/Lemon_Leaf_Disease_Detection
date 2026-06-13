class TreatmentData {
  final String status;
  final String description;
  final List<String> treatment;
  final List<String> prevention;
  final String severity;   // 'none', 'medium', 'high'

  TreatmentData({
    required this.status,
    required this.description,
    required this.treatment,
    required this.prevention,
    required this.severity,
  });

  factory TreatmentData.fromJson(Map<String, dynamic> json) => TreatmentData(
    status:      json['status'] ?? '',
    description: json['description'] ?? '',
    treatment:   List<String>.from(json['treatment'] ?? []),
    prevention:  List<String>.from(json['prevention'] ?? []),
    severity:    json['severity'] ?? 'none',
  );
}

class PredictionResult {
  final int id;
  final bool isLemon;
  final String finalLabel;
  final double confidence;
  final String message;
  final TreatmentData? treatment;

  PredictionResult({
    required this.id,
    required this.isLemon,
    required this.finalLabel,
    required this.confidence,
    required this.message,
    this.treatment,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) => PredictionResult(
    id:         json['id'] ?? 0,
    isLemon:    json['is_lemon'] ?? false,
    finalLabel: json['final_label'] ?? 'unknown',
    confidence: (json['confidence'] ?? 0.0).toDouble(),
    message:    json['message'] ?? '',
    treatment:  json['treatment'] != null
                    ? TreatmentData.fromJson(json['treatment'])
                    : null,
  );

  bool get isHealthy   => finalLabel == 'healthy';
  bool get isNotLemon  => !isLemon;

  // Color based on severity
  String get severityLevel => treatment?.severity ?? 'none';
}