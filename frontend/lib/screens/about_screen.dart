import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/language_provider.dart';

// ─────────────────────────────────────────────────────────────────────────
// ASSET SETUP REQUIRED:
// Add these 9 images under assets/images/ in your project (already
// registered as a folder in pubspec.yaml under `flutter: assets:`):
//   assets/images/healthy.jpg
//   assets/images/anthracnose.jpg
//   assets/images/bacterial_blight.jpg
//   assets/images/citrus_canker.jpg
//   assets/images/curl_virus.jpg
//   assets/images/deficiency_leaf.jpg
//   assets/images/dry_leaf.jpg
//   assets/images/sooty_mould.jpg
//   assets/images/spider_mites.jpg
// ─────────────────────────────────────────────────────────────────────────

class _DiseaseClassInfo {
  final String assetPath;
  final String nameEn;
  final String nameNp;
  final String badgeEn;
  final String badgeNp;
  final Color badgeColor;
  final String descEn;
  final String descNp;

  const _DiseaseClassInfo({
    required this.assetPath,
    required this.nameEn,
    required this.nameNp,
    required this.badgeEn,
    required this.badgeNp,
    required this.badgeColor,
    required this.descEn,
    required this.descNp,
  });
}

const List<_DiseaseClassInfo> _diseaseClasses = [
  _DiseaseClassInfo(
    assetPath: 'assets/images/healthy.jpg',
    nameEn: 'Healthy',
    nameNp: 'स्वस्थ',
    badgeEn: 'Healthy',
    badgeNp: 'स्वस्थ',
    badgeColor: Color(0xFF2E7D32),
    descEn:
        'Healthy lemon leaves are generally green, smooth, and free from major spots, lesions, curling, or visible pest damage.',
    descNp:
        'स्वस्थ कागतीको पात सामान्यतया हरियो, चिल्लो, र ठूला थोप्ला, घाउ, मुडुल्लिने वा किराको क्षतिबाट मुक्त हुन्छ।',
  ),
  _DiseaseClassInfo(
    assetPath: 'assets/images/anthracnose.jpg',
    nameEn: 'Anthracnose',
    nameNp: 'एन्थ्राक्नोज (कोत्रे रोग)',
    badgeEn: 'Fungal Disease',
    badgeNp: 'फङ्गल रोग',
    badgeColor: Color(0xFFC62828),
    descEn:
        'Anthracnose is a fungal disease that may cause dark brown or black spots, irregular lesions, and damaged areas on lemon leaves.',
    descNp:
        'एन्थ्राक्नोज एउटा फङ्गल रोग हो, जसले कागतीको पातमा गाढा खैरो वा कालो थोप्ला, अनियमित घाउ र क्षति देखा पार्न सक्छ।',
  ),
  _DiseaseClassInfo(
    assetPath: 'assets/images/bacterial_blight.jpg',
    nameEn: 'Bacterial Blight',
    nameNp: 'ब्याक्टेरियल ब्लाइट',
    badgeEn: 'Bacterial Disease',
    badgeNp: 'ब्याक्टेरियल रोग',
    badgeColor: Color(0xFF5D4037),
    descEn:
        'Bacterial blight can cause water-soaked spots, dark lesions, yellowing, and tissue damage on the leaf.',
    descNp:
        'ब्याक्टेरियल ब्लाइटले पातमा पानी भिजेजस्तो थोप्ला, गाढा घाउ, पहेंलोपन र तन्तु क्षति निम्त्याउन सक्छ।',
  ),
  _DiseaseClassInfo(
    assetPath: 'assets/images/citrus_canker.jpg',
    nameEn: 'Citrus Canker',
    nameNp: 'सिट्रस क्यान्कर',
    badgeEn: 'Bacterial Disease',
    badgeNp: 'ब्याक्टेरियल रोग',
    badgeColor: Color(0xFFEF6C00),
    descEn:
        'Citrus canker is a bacterial disease characterized by raised, rough, cork-like lesions on the leaf surface.',
    descNp:
        'सिट्रस क्यान्कर एउटा ब्याक्टेरियल रोग हो, जसमा उठेको, खस्रो, कर्क जस्तो बनावटका घाउहरू देखिन्छन्।',
  ),
  _DiseaseClassInfo(
    assetPath: 'assets/images/curl_virus.jpg',
    nameEn: 'Curl Virus',
    nameNp: 'कर्ल भाइरस',
    badgeEn: 'Viral Disease',
    badgeNp: 'भाइरल रोग',
    badgeColor: Color(0xFF6A1B9A),
    descEn:
        'Curl virus infection may cause leaves to curl, twist, become distorted, or develop unusual growth patterns.',
    descNp:
        'कर्ल भाइरस संक्रमणले पात मुडुल्लिने, बटारिने, आकार बिग्रिने वा असामान्य बढाइ देखिने समस्या ल्याउन सक्छ।',
  ),
  _DiseaseClassInfo(
    assetPath: 'assets/images/deficiency_leaf.jpg',
    nameEn: 'Deficiency Leaf',
    nameNp: 'पोषक तत्व कमी',
    badgeEn: 'Nutrient Deficiency',
    badgeNp: 'पोषक तत्व कमी',
    badgeColor: Color(0xFFEF6C00),
    descEn:
        'Nutrient deficiency can cause leaf yellowing, pale color, uneven chlorosis, or changes in leaf growth.',
    descNp:
        'पोषक तत्वको कमीले पात पहेंलो, फिक्का रङको, असमान क्लोरोसिस, वा पातको बढाइमा परिवर्तन ल्याउन सक्छ।',
  ),
  _DiseaseClassInfo(
    assetPath: 'assets/images/dry_leaf.jpg',
    nameEn: 'Dry Leaf',
    nameNp: 'सुकेको पात',
    badgeEn: 'Leaf Condition',
    badgeNp: 'पातको अवस्था',
    badgeColor: Color(0xFF616161),
    descEn:
        'Dry leaves may appear brown, crispy, curled, or dehydrated. This condition can be associated with water stress or aging.',
    descNp:
        'सुकेको पात खैरो, कुरकुरे, मुडुल्लिएको वा निर्जलित देखिन सक्छ। यो अवस्था पानीको कमी वा बोटको उमेरसँग सम्बन्धित हुन सक्छ।',
  ),
  _DiseaseClassInfo(
    assetPath: 'assets/images/sooty_mould.jpg',
    nameEn: 'Sooty Mould',
    nameNp: 'सुटी मोल्ड (कालो ध्वासे)',
    badgeEn: 'Fungal Growth',
    badgeNp: 'फङ्गल वृद्धि',
    badgeColor: Color(0xFFAD1457),
    descEn:
        'Sooty mould appears as a black, powdery coating on the leaf surface, often growing on honeydew from insects.',
    descNp:
        'सुटी मोल्ड पातको सतहमा कालो, धुलेजस्तो तह भएर देखिन्छ, जुन प्रायः किराले उत्पादन गर्ने टाँसिने मह (honeydew) मा उम्रन्छ।',
  ),
  _DiseaseClassInfo(
    assetPath: 'assets/images/spider_mites.jpg',
    nameEn: 'Spider Mites',
    nameNp: 'स्पाइडर माइट्स(सुलसुले)',
    badgeEn: 'Pest Damage',
    badgeNp: 'किराको क्षति',
    badgeColor: Color(0xFFC62828),
    descEn:
        'Spider mites are tiny pests that feed on leaf tissue. Their damage may appear as small yellow spots or discoloration.',
    descNp:
        'स्पाइडर माइट्स साना किराहरू हुन् जसले पातको तन्तु खान्छन्। यिनको क्षति साना पहेंलो थोप्ला वा रङ परिवर्तनको रूपमा देखिन सक्छ।',
  ),
];

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _green = Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    // Target for the "Learn More" button — scrolls down to the disease
    // classes section instead of doing nothing.
    final diseaseSectionKey = GlobalKey();

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
              _buildHeroBanner(context, lang, diseaseSectionKey),
              const SizedBox(height: 20),

              // ══ Project description — who it's for, why it was built ══
              _sectionCard(
                icon: Icons.info_outline_rounded,
                iconColor: _green,
                title: lang.t('About This Project', 'यो प्रोजेक्टको बारेमा'),
                child: Text(
                  lang.t(
                    'This app is built to help farmers and gardeners quickly identify lemon leaf diseases in the field. Scan or upload a leaf photo and the app analyzes it using deep learning to detect common diseases, pests, and leaf conditions, then suggests treatment and prevention steps — helping protect lemon trees and improve yield. It was developed as an academic project applying deep learning to real agricultural problems.',
                    'यो एप कागती किसान र बगैंचा पालकहरूलाई खेतमै छिटो पात रोग पहिचान गर्न मद्दत गर्नको लागि बनाइएको हो। पातको फोटो स्क्यान वा अपलोड गर्नुहोस्, एपले deep learning प्रयोग गरी सामान्य रोग, किरा र पातका समस्या पत्ता लगाउँछ र उपचार तथा रोकथाम सुझाव दिन्छ — जसले कागतीको बोट सुरक्षित राख्न र उत्पादन सुधार गर्न मद्दत गर्छ। यो deep learning लाई वास्तविक कृषि समस्यामा लागू गरेर बनाइएको एउटा academic project हो।',
                  ),
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Colors.grey[700],
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ══ "9 Lemon Leaf Classes Detected" — disease grid ══════════
              Text(
                lang.t(
                  '9 Lemon Leaf Classes Detected',
                  '९ कागती पात वर्गहरू पहिचान गरिन्छ',
                ),
                key: diseaseSectionKey,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2E1B),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                lang.t(
                  'Our CNN model is trained to classify lemon leaf images into one healthy category and eight common disease, pest, or leaf-condition categories.',
                  'हाम्रो CNN मोडेललाई कागतीको पातको फोटोलाई एउटा स्वस्थ वर्ग र आठ सामान्य रोग, किरा वा पातको समस्या सम्बन्धी वर्गमा वर्गीकरण गर्न तालिम दिइएको छ।',
                ),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              ..._diseaseClasses.map(
                (d) => _diseaseClassCard(context, lang, d),
              ),

              const SizedBox(height: 8),
              _sectionCard(
                icon: Icons.checklist_rounded,
                iconColor: const Color(0xFF1565C0),
                title: lang.t('How to Use', 'कसरी प्रयोग गर्ने'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _step(
                      1,
                      lang.t(
                        'Open the app and go to the Home screen.',
                        'एप खोलेर गृह मा जानुहोस्।',
                      ),
                    ),
                    _step(
                      2,
                      lang.t(
                        'Tap "Scan Leaf" to use your camera, or "Upload Image" to choose a photo from your gallery.',
                        '"पात स्क्यान " थिचेर क्यामेरा प्रयोग गर्नुहोस्, वा "फोटो अपलोड" थिचेर ग्यालरीबाट फोटो छान्नुहोस्।',
                      ),
                    ),
                    _step(
                      3,
                      lang.t(
                        'Make sure the leaf is clearly visible and well-lit in the photo.',
                        'फोटोमा पात स्पष्ट र राम्रो उज्यालोमा देखिने सुनिश्चित गर्नुहोस्।',
                      ),
                    ),
                    _step(
                      4,
                      lang.t(
                        'Wait a few seconds while the app analyzes the leaf.',
                        'एपले पात विश्लेषण गर्दा केही सेकेन्ड पर्खनुहोस्।',
                      ),
                    ),
                    _step(
                      5,
                      lang.t(
                        'View the result along with suggested treatment, if any disease is detected.',
                        'रोग पत्ता लागेमा नतिजा र उपचार सुझाव हेर्नुहोस्।',
                      ),
                    ),
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
                    'पातको फोटोलाई Convolutional Neural Network (CNN) प्रयोग गरी विश्लेषण गरिन्छ, जुन स्वस्थ र रोगी कागती पातका फोटोहरूको डेटासेट बाट तालिम प्राप्त गरिएको हो, ताकि सामान्य रोगहरूसँग सम्बन्धित दृश्य ढाँचा(visual pattern) चिन्न सकियोस्।',
                  ),
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Colors.grey[700],
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  lang.t(
                    'Automated Lemon Leaf Disease Detection Using CNN ',
                    'CNN प्रयोग गरी स्वचालित कागतीको पात रोग पहिचान प्रणाली ',
                  ),
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ),
            ],
          ),
        ),
      ),
      // No bottomNavigationBar here — the Home link already lives in the
      // header above, so a second (non-functional) Home button at the
      // bottom would just be a duplicate.
    );
  }

  // ══ Header — back arrow + "About" + a Home shortcut link ═══════════════
  // This is the ONLY Home control on this screen — it actually navigates.
  Widget _buildHeader(BuildContext context, LanguageProvider lang) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: const Color(0xFF1B2E1B),
        ),
        Expanded(
          child: Text(
            lang.t('About', 'बारेमा'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B2E1B),
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () =>
              Navigator.popUntil(context, (route) => route.isFirst),
          icon: const Icon(Icons.home_rounded, size: 18, color: _green),
          label: Text(
            lang.t('Home', 'गृह'),
            style: const TextStyle(
              color: _green,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  // ══ Hero banner — title, subtitle, and two action buttons ══════════════
  // Matches the light gradient / two-button layout requested, with both
  // buttons fully bilingual via lang.t().
  Widget _buildHeroBanner(
    BuildContext context,
    LanguageProvider lang,
    GlobalKey diseaseSectionKey,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.green[50]!, const Color(0xFFEFF6E8)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green[100]!),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -6,
            right: -6,
            child: Icon(
              Icons.eco_rounded,
              color: Colors.green.withOpacity(0.15),
              size: 46,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang.t('Lemon Leaf Disease Detection', 'कागती पात रोग पहिचान'),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2E1B),
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                lang.t(
                  'A CNN-powered system designed to identify lemon leaf diseases from images and support early detection for healthier citrus plants.',
                  'तस्बिरबाट कागती पातका रोगहरू पहिचान गर्न र स्वस्थ कागतीको बोटका लागि छिटो पहिचानमा सहयोग गर्न बनाइएको एप प्रणाली।',
                ),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.popUntil(context, (route) => route.isFirst),
                      icon: const Icon(Icons.camera_alt_outlined, size: 18),
                      label: Text(
                        lang.t('Detect Disease', 'रोग पहिचान गर्नुहोस्'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Scrollable.ensureVisible(
                        diseaseSectionKey.currentContext!,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      ),
                      icon: const Icon(Icons.info_outline_rounded, size: 18),
                      label: Text(lang.t('Learn More', 'थप जान्नुहोस्')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _green,
                        side: BorderSide(color: _green.withOpacity(0.6)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ══ Individual disease class card — image + name + badge + desc ════════
  Widget _diseaseClassCard(
    BuildContext context,
    LanguageProvider lang,
    _DiseaseClassInfo d,
  ) {
    final name = lang.t(d.nameEn, d.nameNp);
    final badge = lang.t(d.badgeEn, d.badgeNp);
    final desc = lang.t(d.descEn, d.descNp);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              d.assetPath,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 72,
                height: 72,
                color: Colors.grey[200],
                child: Icon(Icons.image_not_supported, color: Colors.grey[400]),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B2E1B),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: d.badgeColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          color: d.badgeColor,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _showDiseaseDetails(context, lang, d),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        lang.t('View Details', 'विस्तृत हेर्नुहोस्'),
                        style: const TextStyle(
                          color: _green,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.chevron_right, size: 16, color: _green),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDiseaseDetails(
    BuildContext context,
    LanguageProvider lang,
    _DiseaseClassInfo d,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    d.assetPath,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 48,
                      height: 48,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    lang.t(d.nameEn, d.nameNp),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B2E1B),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              lang.t(d.descEn, d.descNp),
              style: TextStyle(
                fontSize: 13.5,
                color: Colors.grey[700],
                height: 1.6,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
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
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2E1B),
                ),
              ),
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
            decoration: const BoxDecoration(
              color: Color(0xFF1565C0),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.5,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
