import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/language_provider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F8EE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, lang),
              const SizedBox(height: 24),
              _buildAppIntro(lang),
              const SizedBox(height: 20),
              _sectionCard(
                icon: Icons.info_outline_rounded,
                iconColor: const Color(0xFF2E7D32),
                title: lang.t('About This App', 'यो एपको बारेमा'),
                child: Text(
                  lang.t(
                    'This app helps farmers and gardeners quickly identify diseases in lemon leaves. Simply scan or upload a photo of a leaf, and the app analyzes it to detect common diseases and suggest treatment options — helping protect your lemon trees and improve yield.',
                    'यो एपले किसान र बगैंचा पालकहरूलाई कागतीको पातमा हुने रोग छिटो पहिचान गर्न मद्दत गर्छ। पातको फोटो स्क्यान वा अपलोड गर्नुहोस्, एपले त्यसलाई विश्लेषण गरी सामान्य रोगहरू पत्ता लगाउँछ र उपचार सुझाव दिन्छ — जसले तपाईंको कागतीको बोट सुरक्षित राख्न र उत्पादन सुधार गर्न मद्दत गर्छ।',
                  ),
                  style: TextStyle(fontSize: 13.5, color: Colors.grey[700], height: 1.6),
                ),
              ),
              const SizedBox(height: 16),
              _sectionCard(
                icon: Icons.checklist_rounded,
                iconColor: const Color(0xFF1565C0),
                title: lang.t('How to Use', 'कसरी प्रयोग गर्ने'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _step(1, lang.t('Open the app and go to the Home screen.', 'एप खोलेर Home screen मा जानुहोस्।')),
                    _step(2, lang.t('Tap "Scan Leaf" to use your camera, or "Upload Image" to choose a photo from your gallery.', '"Scan Leaf" थिचेर क्यामेरा प्रयोग गर्नुहोस्, वा "Upload Image" थिचेर ग्यालरीबाट फोटो छान्नुहोस्।')),
                    _step(3, lang.t('Make sure the leaf is clearly visible and well-lit in the photo.', 'फोटोमा पात स्पष्ट र राम्रो उज्यालोमा देखिने सुनिश्चित गर्नुहोस्।')),
                    _step(4, lang.t('Wait a few seconds while the app analyzes the leaf.', 'एपले पात विश्लेषण गर्दा केही सेकेन्ड पर्खनुहोस्।')),
                    _step(5, lang.t('View the result along with suggested treatment, if any disease is detected.', 'रोग पत्ता लागेमा नतिजा र उपचार सुझाव हेर्नुहोस्।')),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _sectionCard(
                icon: Icons.hub_outlined,
                iconColor: const Color(0xFF7B1FA2),
                title: lang.t('Model Information', 'मोडेल जानकारी'),
                child: Text(
                  lang.t(
                    'Leaf images are analyzed using a Convolutional Neural Network (CNN) trained on a dataset of healthy and diseased lemon leaf images to recognize visual patterns associated with common diseases.',
                    'पातको फोटोलाई Convolutional Neural Network (CNN) प्रयोग गरी विश्लेषण गरिन्छ, जुन स्वस्थ र रोगी कागती पातका फोटोहरूको dataset बाट तालिम प्राप्त गरिएको हो, ताकि सामान्य रोगहरूसँग सम्बन्धित visual pattern चिन्न सकियोस्।',
                  ),
                  style: TextStyle(fontSize: 13.5, color: Colors.grey[700], height: 1.6),
                ),
              ),
              const SizedBox(height: 16),
              _sectionCard(
                icon: Icons.school_outlined,
                iconColor: const Color(0xFFEF6C00),
                title: lang.t('Developer', 'विकासकर्ता'),
                child: Text(
                  lang.t(
                    'Developed as an academic project applying deep learning to agricultural disease detection.',
                    'कृषि रोग पहिचानमा deep learning प्रयोग गरी बनाइएको एउटा academic project हो।',
                  ),
                  style: TextStyle(fontSize: 13.5, color: Colors.grey[700], height: 1.6),
                ),
              ),
              const SizedBox(height: 16),
              _sectionCard(
                icon: Icons.verified_outlined,
                iconColor: const Color(0xFF2E7D32),
                title: lang.t('Version & Contact', 'संस्करण र सम्पर्क'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow(lang.t('App Version', 'एप संस्करण'), '1.0.0'),
                    const SizedBox(height: 8),
                    _infoRow(lang.t('Feedback', 'प्रतिक्रिया'), lang.t('Use the feedback option in Settings (coming soon)', 'Settings मा भएको feedback option प्रयोग गर्नुहोस् (चाँडै आउँदैछ)')),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  lang.t('Made with care for lemon growers 🍋', 'कागती किसानहरूको लागि मायाका साथ बनाइएको 🍋'),
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, LanguageProvider lang) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: const Color(0xFF1B2E1B),
        ),
        Text(
          lang.t('About', 'बारेमा'),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B2E1B),
          ),
        ),
      ],
    );
  }

  Widget _buildAppIntro(LanguageProvider lang) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: const Color(0xFF2E7D32).withOpacity(0.25), blurRadius: 14, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
            child: const Center(child: Text('🍋', style: TextStyle(fontSize: 30))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang.t('Lemon Leaf Disease Detector', 'कागती पात रोग पहिचानकर्ता'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  lang.t('Using Deep Learning (CNN)', 'डीप लर्निङ (CNN) प्रयोग गरेर'),
                  style: const TextStyle(fontSize: 12.5, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(color: iconColor.withOpacity(0.12), shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B2E1B))),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _step(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(top: 1),
            decoration: const BoxDecoration(color: Color(0xFF1565C0), shape: BoxShape.circle),
            child: Center(
              child: Text('$number', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 13.5, color: Colors.grey[700], height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(label, style: TextStyle(fontSize: 12.5, color: Colors.grey[500], fontWeight: FontWeight.w600)),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 13, color: Color(0xFF1B2E1B))),
        ),
      ],
    );
  }
}