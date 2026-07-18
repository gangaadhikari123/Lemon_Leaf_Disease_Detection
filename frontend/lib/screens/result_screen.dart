import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/prediction_model.dart';
import '../utils/language_provider.dart';

class ResultScreen extends StatelessWidget {
  final PredictionResult result;
  final File? imageFile;        // mobile + desktop
  final Uint8List? imageBytes;  // web only

  const ResultScreen({
    super.key,
    required this.result,
    this.imageFile,
    this.imageBytes,
  });

  Color get _severityColor {
    switch (result.severityLevel) {
      case 'high':   return Colors.red[700]!;
      case 'medium': return Colors.orange[700]!;
      default:       return Colors.green[700]!;
    }
  }

  Widget _buildLeafImage() {
    if (kIsWeb && imageBytes != null) {
      return Image.memory(
        imageBytes!,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
      );
    } else if (imageFile != null) {
      return Image.file(
        imageFile!,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
      );
    }
    return Container(
      height: 220,
      color: Colors.grey[200],
      child: const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final treatment = result.treatment;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        title: Text(
          lang.t('Analysis Result', 'विश्लेषण नतिजा'),
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Scanned image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _buildLeafImage(),
            ),
            const SizedBox(height: 16),

            // Result card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _severityColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _severityColor.withOpacity(0.4), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(
                      result.isHealthy
                          ? Icons.check_circle
                          : result.isNotLemon
                              ? Icons.cancel
                              : Icons.warning_amber_rounded,
                      color: _severityColor,
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        treatment?.status ?? result.finalLabel,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _severityColor,
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 12),

                  // Confidence bar
                  Row(children: [
                    Text(
                      lang.t('Confidence: ', 'विश्वास: '),
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    Text(
                      '${(result.confidence * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _severityColor,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: result.confidence,
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                      color: _severityColor,
                    ),
                  ),

                  if (treatment != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      treatment.description,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Treatment steps
            if (treatment != null && treatment.treatment.isNotEmpty) ...[
              _SectionHeader(
                icon: Icons.medical_services,
                label: lang.t('Treatment Steps', 'उपचार विधि'),
                color: Colors.red[700]!,
              ),
              const SizedBox(height: 8),
              ...treatment.treatment.asMap().entries.map((e) =>
                _StepCard(
                  step: e.key + 1,
                  text: e.value,
                  color: Colors.red[50]!,
                  borderColor: Colors.red[200]!,
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Prevention tips
            if (treatment != null && treatment.prevention.isNotEmpty) ...[
              _SectionHeader(
                icon: Icons.shield,
                label: lang.t('Prevention Tips', 'रोकथाम सुझाव'),
                color: Colors.green[700]!,
              ),
              const SizedBox(height: 8),
              ...treatment.prevention.map((tip) =>
                _BulletCard(
                  text: tip,
                  color: Colors.green[50]!,
                  borderColor: Colors.green[200]!,
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Scan again button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.camera_alt),
                label: Text(lang.t('Scan Another Leaf', 'अर्को पात स्क्यान गर्नुहोस्')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _SectionHeader({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, color: color, size: 22),
    const SizedBox(width: 8),
    Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
  ]);
}

class _StepCard extends StatelessWidget {
  final int step;
  final String text;
  final Color color;
  final Color borderColor;
  const _StepCard({
    required this.step,
    required this.text,
    required this.color,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: borderColor),
    ),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CircleAvatar(
        radius: 12,
        backgroundColor: borderColor,
        child: Text(
          '$step',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Text(text, style: const TextStyle(fontSize: 14, height: 1.4)),
      ),
    ]),
  );
}

class _BulletCard extends StatelessWidget {
  final String text;
  final Color color;
  final Color borderColor;
  const _BulletCard({
    required this.text,
    required this.color,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: borderColor),
    ),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        '• ',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
      ),
      const SizedBox(width: 6),
      Expanded(
        child: Text(text, style: const TextStyle(fontSize: 14, height: 1.4)),
      ),
    ]),
  );
}
