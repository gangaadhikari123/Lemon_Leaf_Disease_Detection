import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
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

  bool get _isWeb     => kIsWeb;
  bool get _isMobile  => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  bool get _isDesktop => !kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS);

  // ── SCAN — opens camera on mobile/web, shows dialog on desktop ─
  Future<void> _scanWithCamera() async {
    if (_isDesktop) {
      // Desktop has no camera — show helpful dialog
      _showDesktopCameraDialog();
      return;
    }

    final lang = context.read<LanguageProvider>();
    try {
      if (_isWeb) {
        final XFile? picked = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
        );
        if (picked == null) return;
        final Uint8List bytes = await picked.readAsBytes();
        setState(() => _isLoading = true);
        final prediction = await ApiService.predictDiseaseFromBytes(
          imageBytes: bytes,
          fileName: picked.name,
          language: lang.language,
        );
        if (!mounted) return;
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => ResultScreen(result: prediction, imageBytes: bytes),
        ));

      } else if (_isMobile) {
        final XFile? picked = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
          maxWidth: 1024,
          maxHeight: 1024,
          preferredCameraDevice: CameraDevice.rear,
        );
        if (picked == null) return;
        final File imageFile = File(picked.path);
        setState(() => _isLoading = true);
        final prediction = await ApiService.predictDisease(
          imageFile: imageFile,
          language: lang.language,
        );
        if (!mounted) return;
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => ResultScreen(result: prediction, imageFile: imageFile),
        ));
      }
    } on Exception catch (e) {
      if (!mounted) return;
      _showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── UPLOAD — opens gallery on mobile, file browser on desktop ──
  Future<void> _uploadFromGallery() async {
    final lang = context.read<LanguageProvider>();
    try {
      if (_isWeb) {
        final XFile? picked = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
        );
        if (picked == null) return;
        final Uint8List bytes = await picked.readAsBytes();
        setState(() => _isLoading = true);
        final prediction = await ApiService.predictDiseaseFromBytes(
          imageBytes: bytes,
          fileName: picked.name,
          language: lang.language,
        );
        if (!mounted) return;
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => ResultScreen(result: prediction, imageBytes: bytes),
        ));

      } else if (_isMobile) {
        final XFile? picked = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
          maxWidth: 1024,
          maxHeight: 1024,
        );
        if (picked == null) return;
        final File imageFile = File(picked.path);
        setState(() => _isLoading = true);
        final prediction = await ApiService.predictDisease(
          imageFile: imageFile,
          language: lang.language,
        );
        if (!mounted) return;
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => ResultScreen(result: prediction, imageFile: imageFile),
        ));

      } else if (_isDesktop) {
        final FilePickerResult? pickerResult =
            await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
          withData: true,
        );
        if (pickerResult == null || pickerResult.files.isEmpty) return;
        final PlatformFile platformFile = pickerResult.files.single;
        setState(() => _isLoading = true);

        if (platformFile.path != null) {
          final File imageFile = File(platformFile.path!);
          final prediction = await ApiService.predictDisease(
            imageFile: imageFile,
            language: lang.language,
          );
          if (!mounted) return;
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => ResultScreen(
              result: prediction,
              imageFile: imageFile,
            ),
          ));
        } else if (platformFile.bytes != null) {
          final prediction = await ApiService.predictDiseaseFromBytes(
            imageBytes: platformFile.bytes!,
            fileName: platformFile.name,
            language: lang.language,
          );
          if (!mounted) return;
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => ResultScreen(
              result: prediction,
              imageBytes: platformFile.bytes,
            ),
          ));
        }
      }
    } on Exception catch (e) {
      if (!mounted) return;
      _showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Desktop camera dialog ─────────────────────────────────────
  void _showDesktopCameraDialog() {
    final lang = context.read<LanguageProvider>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          const Icon(Icons.info_outline, color: Color(0xFF2E7D32)),
          const SizedBox(width: 10),
          Text(
            lang.t('Camera Not Available', 'क्यामेरा उपलब्ध छैन'),
            style: const TextStyle(fontSize: 16),
          ),
        ]),
        content: Text(
          lang.t(
            'Camera scanning is only available on mobile phones.\n\nPlease use "Upload Photo" to select an image from your computer, or use the mobile app to scan with your camera.',
            'क्यामेरा स्क्यान केवल मोबाइल फोनमा उपलब्ध छ।\n\nकृपया कम्प्युटरबाट तस्बिर छान्न "फोटो अपलोड गर्नुहोस्" प्रयोग गर्नुहोस्, वा मोबाइल एपबाट क्यामेरा प्रयोग गर्नुहोस्।',
          ),
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang.t('Cancel', 'रद्द गर्नुहोस्')),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              _uploadFromGallery();   // redirect to file picker
            },
            icon: const Icon(Icons.upload_file),
            label: Text(lang.t('Upload Photo Instead', 'फोटो अपलोड गर्नुहोस्')),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(child: Text(message)),
        ]),
        backgroundColor: Colors.red[700],
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        title: Text(
          lang.t('Lemon Disease Detector', 'कागती रोग पहिचानकर्ता'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: lang.toggleLanguage,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                lang.isNepali ? 'EN' : 'NP',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading ? _buildLoading(lang) : _buildBody(lang),
    );
  }

  Widget _buildLoading(LanguageProvider lang) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF2E7D32),
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          Text(
            lang.t('Analyzing leaf...', 'पात विश्लेषण गर्दै...'),
            style: const TextStyle(fontSize: 16, color: Color(0xFF2E7D32)),
          ),
          const SizedBox(height: 8),
          Text(
            lang.t('Please wait', 'कृपया प्रतीक्षा गर्नुहोस्'),
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(LanguageProvider lang) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),

          // ── Logo ────────────────────────────────────────────
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.eco,
              size: 70,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 20),

          // ── Title ───────────────────────────────────────────
          Text(
            lang.t(
              'Lemon Leaf Disease Detection',
              'कागती पातको रोग पहिचान',
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            lang.t(
              'Point your camera at a lemon leaf or upload a photo to detect diseases.',
              'रोग पहिचानका लागि कागती पातमा क्यामेरा राख्नुहोस् वा फोटो अपलोड गर्नुहोस्।',
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 36),

          // ══════════════════════════════════════════════════
          // SCAN BUTTON — Camera
          // ══════════════════════════════════════════════════
          _ScanUploadCard(
            icon: Icons.camera_alt_rounded,
            iconBgColor: const Color(0xFF1B5E20),
            title: lang.t('Scan Leaf', 'पात स्क्यान गर्नुहोस्'),
            subtitle: lang.t(
              'Open camera and point at a lemon leaf',
              'क्यामेरा खोलेर कागती पातमा देखाउनुहोस्',
            ),
            buttonLabel: lang.t('Open Camera', 'क्यामेरा खोल्नुहोस्'),
            buttonColor: const Color(0xFF2E7D32),
            badgeLabel: _isDesktop
                ? lang.t('Mobile Only', 'मोबाइलमा मात्र')
                : lang.t('Camera', 'क्यामेरा'),
            badgeColor: _isDesktop ? Colors.orange : Colors.green,
            onTap: _scanWithCamera,
            instructions: [
              lang.t('Hold phone 20-30 cm from leaf', 'पातबाट २०-३० से.मी. टाढा राख्नुहोस्'),
              lang.t('Make sure leaf fills the frame', 'पात फ्रेममा भरिएको सुनिश्चित गर्नुहोस्'),
              lang.t('Use good lighting', 'राम्रो प्रकाश प्रयोग गर्नुहोस्'),
            ],
          ),

          const SizedBox(height: 16),

          // ── OR divider ──────────────────────────────────────
          Row(children: [
            Expanded(child: Divider(color: Colors.grey[300])),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                lang.t('OR', 'वा'),
                style: TextStyle(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey[300])),
          ]),

          const SizedBox(height: 16),

          // ══════════════════════════════════════════════════
          // UPLOAD BUTTON — Gallery / File picker
          // ══════════════════════════════════════════════════
          _ScanUploadCard(
            icon: Icons.upload_file_rounded,
            iconBgColor: const Color(0xFF1565C0),
            title: lang.t('Upload Photo', 'फोटो अपलोड गर्नुहोस्'),
            subtitle: lang.t(
              _isDesktop
                  ? 'Select a leaf image from your computer'
                  : 'Choose a photo from your gallery',
              _isDesktop
                  ? 'कम्प्युटरबाट पातको तस्बिर छान्नुहोस्'
                  : 'ग्यालरीबाट फोटो छान्नुहोस्',
            ),
            buttonLabel: lang.t(
              _isDesktop ? 'Browse Files' : 'Open Gallery',
              _isDesktop ? 'फाइल खोज्नुहोस्' : 'ग्यालरी खोल्नुहोस्',
            ),
            buttonColor: const Color(0xFF1565C0),
            badgeLabel: _isDesktop
                ? lang.t('All Devices', 'सबै उपकरण')
                : lang.t('Gallery', 'ग्यालरी'),
            badgeColor: Colors.blue,
            onTap: _uploadFromGallery,
            instructions: [
              lang.t('Select a clear leaf photo', 'स्पष्ट पातको फोटो छान्नुहोस्'),
              lang.t('JPG or PNG format', 'JPG वा PNG फर्म्याट'),
              lang.t('Good lighting preferred', 'राम्रो प्रकाश भएको फोटो राम्रो'),
            ],
          ),

          const SizedBox(height: 24),

          // ── Tips card ───────────────────────────────────────
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
                  const Icon(Icons.lightbulb_outline,
                      color: Colors.amber, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    lang.t(
                      'For best results',
                      'राम्रो नतिजाका लागि',
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ]),
                const SizedBox(height: 10),
                _tip(lang.t(
                  'Focus on a single lemon leaf only',
                  'एउटा मात्र कागती पातमा फोकस गर्नुहोस्',
                )),
                _tip(lang.t(
                  'Use natural daylight, avoid dark photos',
                  'प्राकृतिक प्रकाश प्रयोग गर्नुहोस्',
                )),
                _tip(lang.t(
                  'Include both sides of leaf if diseased',
                  'रोगी भए पातको दुवै पट्टि देखाउनुहोस्',
                )),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _tip(String text) => Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('• ',
                style: TextStyle(
                    color: Colors.amber, fontWeight: FontWeight.bold)),
            Expanded(
              child: Text(text,
                  style:
                      TextStyle(fontSize: 13, color: Colors.grey[700])),
            ),
          ],
        ),
      );
}

// ── Reusable Scan/Upload card widget ─────────────────────────────
class _ScanUploadCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final Color buttonColor;
  final String badgeLabel;
  final Color badgeColor;
  final VoidCallback onTap;
  final List<String> instructions;

  const _ScanUploadCard({
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.buttonColor,
    required this.badgeLabel,
    required this.badgeColor,
    required this.onTap,
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B2E1B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: badgeColor.withOpacity(0.4)),
                      ),
                      child: Text(
                        badgeLabel,
                        style: TextStyle(
                          fontSize: 10,
                          color: badgeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ]),

          const SizedBox(height: 14),

          // Instructions list
          ...instructions.map((step) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline,
                        size: 14,
                        color: buttonColor.withOpacity(0.7)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        step,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              )),

          const SizedBox(height: 14),

          // Action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onTap,
              icon: Icon(icon, size: 18),
              label: Text(
                buttonLabel,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
