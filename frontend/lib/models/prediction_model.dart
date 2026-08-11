
class TreatmentLanguage {
  final String status;
  final String description;
  final List<String> treatment;
  final List<String> prevention;

  TreatmentLanguage({
    required this.status,
    required this.description,
    required this.treatment,
    required this.prevention,
  });

  factory TreatmentLanguage.fromJson(Map<String, dynamic> json) {
    return TreatmentLanguage(
      status:      json['status']      ?? '',
      description: json['description'] ?? '',
      treatment:   List<String>.from(json['treatment']  ?? []),
      prevention:  List<String>.from(json['prevention'] ?? []),
    );
  }
}

class TreatmentData {
  final TreatmentLanguage en;
  final TreatmentLanguage np;

  TreatmentData({required this.en, required this.np});

  factory TreatmentData.fromJson(Map<String, dynamic> json) {
    return TreatmentData(
      en: TreatmentLanguage.fromJson(json['en'] ?? {}),
      np: TreatmentLanguage.fromJson(json['np'] ?? {}),
    );
  }

  TreatmentLanguage forLanguage(String lang) => lang == 'np' ? np : en;
}

class PredictionResult {
  final bool isLemon;
  final String disease;
  final double confidence;
  final TreatmentData? treatment;
  final String result;

  PredictionResult({
    required this.isLemon,
    required this.disease,
    required this.confidence,
    required this.result,
    this.treatment,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    print('=== RAW API RESPONSE ===');
    print(json);
    print('========================');

    final resultStr = (json['result'] ?? '').toString();
    final isLemon   = resultStr == 'Lemon Leaf Detected';
    final disease   = (json['disease'] ?? '').toString();

    double confidence = 0.0;
    if (json['leaf_confidence'] != null) {
      confidence = (json['leaf_confidence'] as num).toDouble();
    } else if (json['confidence'] != null) {
      confidence = (json['confidence'] as num).toDouble();
    } else if (json['disease_confidence'] != null) {
      confidence = (json['disease_confidence'] as num).toDouble();
    }

    TreatmentData? treatment;
    if (json['treatment'] != null) {
      try {
        treatment = TreatmentData.fromJson(json['treatment']);
      } catch (e) {
        print('Treatment parse error: $e');
      }
    }

    return PredictionResult(
      result:     resultStr,
      isLemon:    isLemon,
      disease:    disease,
      confidence: confidence,
      treatment:  treatment,
    );
  }

  bool get isHealthy  => disease.toLowerCase().contains('healthy');
  bool get isNotLemon => !isLemon;

  String get severityLevel {
    if (!isLemon) return 'none';
    final d = disease.toLowerCase();
    if (d.contains('canker') || d.contains('blight') ||
        d.contains('curl')   || d.contains('virus')) return 'high';
    if (d.contains('healthy')) return 'none';
    return 'medium';
  }
}