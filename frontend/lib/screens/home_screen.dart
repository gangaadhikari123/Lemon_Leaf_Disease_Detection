import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../utils/language_provider.dart';
import '../services/api_service.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  // Pick image from camera or gallery then send to API
  Future<void> _pickAndPredict(ImageSource source) async {
    final lang = context.read<LanguageProvider>();

    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1024,
    );
    if (picked == null) return;

    setState(() => _isLoading = true);

    try {
      final result = await ApiService.predictDisease(
        imageFile: File(picked.path),
        language: lang.language,
      );

      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => ResultScreen(
          result:    result,
          imageFile: File(picked.path),
        ),
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        title: Text(lang.t('Lemon Disease Detector', 'कागती रोग पहिचानकर्ता'),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          // Language toggle button
          GestureDetector(
            onTap: lang.toggleLanguage,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(lang.isNepali ? 'EN' : 'NP',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Color(0xFF2E7D32)),
                  const SizedBox(height: 16),
                  Text(lang.t('Analyzing leaf...', 'पात विश्लेषण गर्दै...'),
                      style: const TextStyle(fontSize: 16, color: Color(0xFF2E7D32))),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // App icon / illustration
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.eco, size: 80, color: Color(0xFF2E7D32)),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    lang.t('Detect Lemon Leaf Disease', 'कागती पातको रोग पत्ता लगाउनुहोस्'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    lang.t(
                      'Scan or upload a lemon leaf photo to identify diseases and get treatment advice.',
                      'रोग पहिचान र उपचार सुझाव पाउन कागती पातको फोटो स्क्यान वा अपलोड गर्नुहोस्।',
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
                  ),

                  const SizedBox(height: 48),

                  // Scan with Camera button
                  _ActionButton(
                    icon: Icons.camera_alt,
                    label: lang.t('Scan with Camera', 'क्यामेराले स्क्यान गर्नुहोस्'),
                    subtitle: lang.t('Take a photo now', 'अहिले फोटो खिच्नुहोस्'),
                    color: const Color(0xFF2E7D32),
                    onTap: () => _pickAndPredict(ImageSource.camera),
                  ),

                  const SizedBox(height: 16),

                  // Upload from Gallery button
                  _ActionButton(
                    icon: Icons.photo_library,
                    label: lang.t('Upload from Gallery', 'ग्यालरीबाट अपलोड गर्नुहोस्'),
                    subtitle: lang.t('Choose an existing photo', 'पहिलेको फोटो छान्नुहोस्'),
                    color: const Color(0xFF388E3C),
                    onTap: () => _pickAndPredict(ImageSource.gallery),
                  ),

                  const SizedBox(height: 32),

                  // Tips card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(Icons.lightbulb, color: Colors.amber, size: 18),
                          const SizedBox(width: 8),
                          Text(lang.t('Tips for best results', 'राम्रो नतिजाका लागि सुझाव'),
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ]),
                        const SizedBox(height: 8),
                        _tip(lang.t('• Use natural daylight', '• प्राकृतिक प्रकाशमा खिच्नुहोस्')),
                        _tip(lang.t('• Focus on ONE leaf clearly', '• एउटा पातमा स्पष्ट फोकस गर्नुहोस्')),
                        _tip(lang.t('• Fill the frame with the leaf', '• फ्रेम पातले भर्नुहोस्')),
                        _tip(lang.t('• Avoid blurry photos', '• धमिलो फोटो नखिच्नुहोस्')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _tip(String text) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Text(text, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
  );
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon, required this.label, required this.subtitle,
    required this.color, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 36),
            const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ]),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
          ],
        ),
      ),
    );
  }
}