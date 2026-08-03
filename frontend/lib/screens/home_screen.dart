// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';
// import '../utils/language_provider.dart';
// import '../services/api_service.dart';
// import 'result_screen.dart';
// import 'about_screen.dart';
// import 'camera_capture_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   bool _isLoading = false;
//   final ImagePicker _picker = ImagePicker();
//   int _bottomNavIndex = 0; // 0 = Home, 1 = About (About screen not wired — UI only)

//   bool get _isWeb     => kIsWeb;
//   bool get _isMobile  => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
//   bool get _isDesktop => !kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS);

//   // ── SCAN — opens camera on mobile/web, shows dialog on desktop ─
//   // (unchanged logic)
//   Future<void> _scanWithCamera() async {
//     if (_isDesktop) {
//       _showDesktopCameraDialog();
//       return;
//     }

//     final lang = context.read<LanguageProvider>();
//     try {
//       if (_isWeb) {
//         // Desktop browsers (Chrome, etc.) don't support image_picker's
//         // camera source as a real webcam feed — it just falls back to a
//         // file picker. Use a live camera preview screen instead.
//         final CapturedPhoto? captured = await Navigator.push<CapturedPhoto>(
//           context,
//           MaterialPageRoute(builder: (_) => const CameraCaptureScreen()),
//         );
//         if (captured == null) return;
//         setState(() => _isLoading = true);
//         final prediction = await ApiService.predictDiseaseFromBytes(
//           imageBytes: captured.bytes,
//           fileName: captured.fileName,
//           language: lang.language,
//         );
//         if (!mounted) return;
//         Navigator.push(context, MaterialPageRoute(
//           builder: (_) => ResultScreen(result: prediction, imageBytes: captured.bytes),
//         ));

//       } else if (_isMobile) {
//         final XFile? picked = await _picker.pickImage(
//           source: ImageSource.camera,
//           imageQuality: 85,
//           maxWidth: 1024,
//           maxHeight: 1024,
//           preferredCameraDevice: CameraDevice.rear,
//         );
//         if (picked == null) return;
//         final File imageFile = File(picked.path);
//         setState(() => _isLoading = true);
//         final prediction = await ApiService.predictDisease(
//           imageFile: imageFile,
//           language: lang.language,
//         );
//         if (!mounted) return;
//         Navigator.push(context, MaterialPageRoute(
//           builder: (_) => ResultScreen(result: prediction, imageFile: imageFile),
//         ));
//       }
//     } on Exception catch (e) {
//       if (!mounted) return;
//       _showError(e.toString().replaceAll('Exception: ', ''));
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   // ── UPLOAD — opens gallery on mobile, file browser on desktop ──
//   // (unchanged logic)
//   Future<void> _uploadFromGallery() async {
//     final lang = context.read<LanguageProvider>();
//     try {
//       if (_isWeb) {
//         final XFile? picked = await _picker.pickImage(
//           source: ImageSource.gallery,
//           imageQuality: 85,
//         );
//         if (picked == null) return;
//         final Uint8List bytes = await picked.readAsBytes();
//         setState(() => _isLoading = true);
//         final prediction = await ApiService.predictDiseaseFromBytes(
//           imageBytes: bytes,
//           fileName: picked.name,
//           language: lang.language,
//         );
//         if (!mounted) return;
//         Navigator.push(context, MaterialPageRoute(
//           builder: (_) => ResultScreen(result: prediction, imageBytes: bytes),
//         ));

//       } else if (_isMobile) {
//         final XFile? picked = await _picker.pickImage(
//           source: ImageSource.gallery,
//           imageQuality: 85,
//           maxWidth: 1024,
//           maxHeight: 1024,
//         );
//         if (picked == null) return;
//         final File imageFile = File(picked.path);
//         setState(() => _isLoading = true);
//         final prediction = await ApiService.predictDisease(
//           imageFile: imageFile,
//           language: lang.language,
//         );
//         if (!mounted) return;
//         Navigator.push(context, MaterialPageRoute(
//           builder: (_) => ResultScreen(result: prediction, imageFile: imageFile),
//         ));

//       } else if (_isDesktop) {
//         final FilePickerResult? pickerResult =
//             await FilePicker.platform.pickFiles(
//           type: FileType.image,
//           allowMultiple: false,
//           withData: true,
//         );
//         if (pickerResult == null || pickerResult.files.isEmpty) return;
//         final PlatformFile platformFile = pickerResult.files.single;
//         setState(() => _isLoading = true);

//         if (platformFile.path != null) {
//           final File imageFile = File(platformFile.path!);
//           final prediction = await ApiService.predictDisease(
//             imageFile: imageFile,
//             language: lang.language,
//           );
//           if (!mounted) return;
//           Navigator.push(context, MaterialPageRoute(
//             builder: (_) => ResultScreen(
//               result: prediction,
//               imageFile: imageFile,
//             ),
//           ));
//         } else if (platformFile.bytes != null) {
//           final prediction = await ApiService.predictDiseaseFromBytes(
//             imageBytes: platformFile.bytes!,
//             fileName: platformFile.name,
//             language: lang.language,
//           );
//           if (!mounted) return;
//           Navigator.push(context, MaterialPageRoute(
//             builder: (_) => ResultScreen(
//               result: prediction,
//               imageBytes: platformFile.bytes,
//             ),
//           ));
//         }
//       }
//     } on Exception catch (e) {
//       if (!mounted) return;
//       _showError(e.toString().replaceAll('Exception: ', ''));
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   // ── Desktop camera dialog ─────────────────────────────────────
//   // (unchanged logic)
//   void _showDesktopCameraDialog() {
//     final lang = context.read<LanguageProvider>();
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Row(children: [
//           const Icon(Icons.info_outline, color: Color(0xFF2E7D32)),
//           const SizedBox(width: 10),
//           Text(
//             lang.t('Camera Not Available', 'क्यामेरा उपलब्ध छैन'),
//             style: const TextStyle(fontSize: 16),
//           ),
//         ]),
//         content: Text(
//           lang.t(
//             'Camera scanning is only available on mobile phones.\n\nPlease use "Upload Photo" to select an image from your computer, or use the mobile app to scan with your camera.',
//             'क्यामेरा स्क्यान केवल मोबाइल फोनमा उपलब्ध छ।\n\nकृपया कम्प्युटरबाट तस्बिर छान्न "फोटो अपलोड गर्नुहोस्" प्रयोग गर्नुहोस्, वा मोबाइल एपबाट क्यामेरा प्रयोग गर्नुहोस्।',
//           ),
//           style: const TextStyle(fontSize: 14, height: 1.5),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: Text(lang.t('Cancel', 'रद्द गर्नुहोस्')),
//           ),
//           ElevatedButton.icon(
//             onPressed: () {
//               Navigator.pop(ctx);
//               _uploadFromGallery();
//             },
//             icon: const Icon(Icons.upload_file),
//             label: Text(lang.t('Upload Photo Instead', 'फोटो अपलोड गर्नुहोस्')),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF2E7D32),
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(children: [
//           const Icon(Icons.error_outline, color: Colors.white),
//           const SizedBox(width: 10),
//           Expanded(child: Text(message)),
//         ]),
//         backgroundColor: Colors.red[700],
//         duration: const Duration(seconds: 4),
//       ),
//     );
//   }

//   // ══════════════════════════════════════════════════════════
//   // UI — matches the reference design
//   // ══════════════════════════════════════════════════════════

//   @override
//   Widget build(BuildContext context) {
//     final lang = context.watch<LanguageProvider>();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F8EE),
//       body: _isLoading ? _buildLoading(lang) : _buildBody(context, lang),
//       bottomNavigationBar: _isLoading ? null : _buildBottomNav(lang),
//     );
//   }

//   // ── Loading state ────────────────────────────────────────────
//   Widget _buildLoading(LanguageProvider lang) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const CircularProgressIndicator(
//             color: Color(0xFF2E7D32),
//             strokeWidth: 3,
//           ),
//           const SizedBox(height: 20),
//           Text(
//             lang.t('Analyzing leaf...', 'पात विश्लेषण गर्दै...'),
//             style: const TextStyle(fontSize: 16, color: Color(0xFF2E7D32)),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             lang.t('Please wait', 'कृपया प्रतीक्षा गर्नुहोस्'),
//             style: TextStyle(fontSize: 13, color: Colors.grey[500]),
//           ),
//         ],
//       ),
//     );
//   }

//   // ── Main body ─────────────────────────────────────────────────
//   Widget _buildBody(BuildContext context, LanguageProvider lang) {
//     return SafeArea(
//       bottom: false,
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildTopBar(lang),
//             const SizedBox(height: 22),
//             _buildHeroImage(lang),
//             const SizedBox(height: 10),
//             _buildDots(),
//             const SizedBox(height: 22),
//             Text(
//               lang.t('Detect Lemon Leaf Diseases 🍃', 'कागती पातका रोगहरू पत्ता लगाउनुहोस् 🍃'),
//               style: const TextStyle(
//                 fontSize: 26,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF1B5E20),
//                 height: 1.2,
//               ),
//             ),
//             Text(
//               lang.t('Using Deep Learning (CNN)', 'डीप लर्निङ (CNN) प्रयोग गरेर'),
//               style: const TextStyle(
//                 fontSize: 26,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF1B5E20),
//                 height: 1.2,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               lang.t(
//                 'Upload or scan a lemon leaf image to instantly identify diseases and receive treatment recommendations.',
//                 'रोग पहिचान गर्न र उपचार सुझाव पाउन कागती पातको फोटो अपलोड वा स्क्यान गर्नुहोस्।',
//               ),
//               style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
//             ),
//             const SizedBox(height: 24),
//             _buildActionButtons(lang),
//             const SizedBox(height: 24),
//             _buildFeatureCards(lang),
//             const SizedBox(height: 12),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── Top bar: logo + title + language toggle ───────────────────
//   Widget _buildTopBar(LanguageProvider lang) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('🍋', style: TextStyle(fontSize: 44)),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 lang.t('Automated', 'स्वचालित'),
//                 style: TextStyle(fontSize: 15, color: Colors.grey[700]),
//               ),
//               Text(
//                 lang.t('Lemon Leaf Disease\nDetection Using CNN', 'कागती पातको रोग\nपहिचान (CNN प्रयोग गरी)'),
//                 style: const TextStyle(
//                   fontSize: 19,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1B2E1B),
//                   height: 1.25,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 10),
//         _buildLangToggle(lang),
//       ],
//     );
//   }

//   Widget _buildLangToggle(LanguageProvider lang) {
//     return Container(
//       padding: const EdgeInsets.all(3),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: Colors.grey[300]!),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2)),
//         ],
//       ),
//       child: GestureDetector(
//         onTap: lang.toggleLanguage,
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _langSegment('English', !lang.isNepali),
//             _langSegment('नेपाली', lang.isNepali),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _langSegment(String label, bool active) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: active ? const Color(0xFF2E7D32) : Colors.transparent,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w600,
//           color: active ? Colors.white : Colors.grey[600],
//         ),
//       ),
//     );
//   }

//   // ── Hero lemon leaf image with decorative scan-frame overlay ──
//   Widget _buildHeroImage(LanguageProvider lang) {
//     return Container(
//       height: 220,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(color: const Color(0xFF2E7D32).withOpacity(0.18), blurRadius: 16, offset: const Offset(0, 8)),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(24),
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             Image.asset(
//               'assets/images/lemon_leaf.jpg',
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stack) => Container(
//                 color: const Color(0xFF2E7D32).withOpacity(0.15),
//                 child: const Icon(Icons.eco, size: 60, color: Color(0xFF2E7D32)),
//               ),
//             ),
//             // corner scan-frame brackets (decorative)
//             const Positioned(top: 16, left: 16, child: _ScanCorner()),
//             Positioned(top: 16, right: 16, child: Transform.rotate(angle: 1.5708, child: const _ScanCorner())),
//             Positioned(bottom: 16, left: 16, child: Transform.rotate(angle: -1.5708, child: const _ScanCorner())),
//             Positioned(bottom: 16, right: 16, child: Transform.rotate(angle: 3.1416, child: const _ScanCorner())),

//             // "AI SCANNING" badge — left side
//             Positioned(
//               left: 14,
//               top: 0,
//               bottom: 0,
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.45),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         width: 7,
//                         height: 7,
//                         decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
//                       ),
//                       const SizedBox(width: 7),
//                       Text(
//                         lang.t('AI SCANNING', 'AI स्क्यानिङ'),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 11,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // "DETECTION" result card — right side
//             Positioned(
//               right: 14,
//               top: 0,
//               bottom: 0,
//               child: Align(
//                 alignment: Alignment.centerRight,
//                 child: Container(
//                   width: 108,
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.55),
//                     borderRadius: BorderRadius.circular(14),
//                     border: Border.all(color: Colors.greenAccent.withOpacity(0.4)),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         lang.t('DETECTION', 'पहिचान'),
//                         style: const TextStyle(color: Colors.white70, fontSize: 9.5, fontWeight: FontWeight.bold, letterSpacing: 0.5),
//                       ),
//                       const SizedBox(height: 8),
//                       Center(
//                         child: Container(
//                           width: 34,
//                           height: 34,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.greenAccent, width: 1.5),
//                           ),
//                           child: const Icon(Icons.check, color: Colors.greenAccent, size: 18),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Divider(color: Colors.white24, height: 1),
//                       const SizedBox(height: 8),
//                       Text(
//                         lang.t('HEALTHY', 'स्वस्थ'),
//                         style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         lang.t('CONFIDENCE', 'विश्वास'),
//                         style: const TextStyle(color: Colors.white54, fontSize: 8.5, fontWeight: FontWeight.w600),
//                       ),
//                       const SizedBox(height: 3),
//                       Text(
//                         '98.6%',
//                         style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 4),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(3),
//                         child: LinearProgressIndicator(
//                           value: 0.986,
//                           minHeight: 4,
//                           backgroundColor: Colors.white24,
//                           valueColor: const AlwaysStoppedAnimation(Colors.greenAccent),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDots() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _dot(false),
//         const SizedBox(width: 5),
//         _dot(true),
//         const SizedBox(width: 5),
//         _dot(false),
//       ],
//     );
//   }

//   Widget _dot(bool active) => Container(
//         width: active ? 18 : 6,
//         height: 6,
//         decoration: BoxDecoration(
//           color: active ? const Color(0xFF2E7D32) : Colors.grey[300],
//           borderRadius: BorderRadius.circular(3),
//         ),
//       );

//   // ── Scan Leaf / Upload Image buttons ───────────────────────────
//   Widget _buildActionButtons(LanguageProvider lang) {
//     return Row(
//       children: [
//         Expanded(
//           child: _ActionCard(
//             icon: Icons.camera_alt_rounded,
//             title: lang.t('Scan Leaf', 'पात स्क्यान'),
//             subtitle: lang.t('Use Camera', 'क्यामेरा प्रयोग गर्नुहोस्'),
//             filled: true,
//             onTap: _scanWithCamera,
//           ),
//         ),
//         const SizedBox(width: 14),
//         Expanded(
//           child: _ActionCard(
//             icon: Icons.image_outlined,
//             title: lang.t('Upload Image', 'फोटो अपलोड'),
//             subtitle: lang.t('Choose from Gallery', 'ग्यालरीबाट छान्नुहोस्'),
//             filled: false,
//             onTap: _uploadFromGallery,
//           ),
//         ),
//       ],
//     );
//   }

//   // ── Feature cards (AI card removed — only 2 remain) ────────────
//   Widget _buildFeatureCards(LanguageProvider lang) {
//     return Row(
//       children: [
//         Expanded(
//           child: _FeatureCard(
//             icon: Icons.bolt_rounded,
//             iconBg: Colors.amber[100]!,
//             iconColor: Colors.amber[800]!,
//             title: lang.t('Instant Results', 'तुरुन्त नतिजा'),
//             subtitle: lang.t('Get fast and accurate results within seconds.', 'सेकेन्डभित्रै छिटो र सही नतिजा पाउनुहोस्।'),
//           ),
//         ),
//         const SizedBox(width: 14),
//         Expanded(
//           child: _FeatureCard(
//             icon: Icons.medication_liquid_outlined,
//             iconBg: const Color(0xFFE0F2E9),
//             iconColor: const Color(0xFF2E7D32),
//             title: lang.t('Treatment Suggestions', 'उपचार सुझाव'),
//             subtitle: lang.t('Receive effective treatment and care recommendations.', 'प्रभावकारी उपचार र स्याहार सुझाव पाउनुहोस्।'),
//           ),
//         ),
//       ],
//     );
//   }

//   // ── Bottom nav (History & Settings removed — Home & About only) ─
//   Widget _buildBottomNav(LanguageProvider lang) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, -3)),
//         ],
//       ),
//       child: SafeArea(
//         top: false,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _NavItem(
//               icon: Icons.home_rounded,
//               label: lang.t('Home', 'गृह'),
//               active: _bottomNavIndex == 0,
//               onTap: () => setState(() => _bottomNavIndex = 0),
//             ),
//             _NavItem(
//               icon: Icons.info_outline_rounded,
//               label: lang.t('About', 'बारेमा'),
//               active: _bottomNavIndex == 1,
//               onTap: () async {
//                 setState(() => _bottomNavIndex = 1);
//                 await Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const AboutScreen()),
//                 );
//                 if (mounted) setState(() => _bottomNavIndex = 0);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Scan-frame corner bracket (decorative) ─────────────────────────
// class _ScanCorner extends StatelessWidget {
//   const _ScanCorner();

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       size: const Size(28, 28),
//       painter: _CornerPainter(),
//     );
//   }
// }

// class _CornerPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white.withOpacity(0.9)
//       ..strokeWidth = 3
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;
//     final path = Path()
//       ..moveTo(0, size.height * 0.6)
//       ..lineTo(0, 0)
//       ..lineTo(size.width * 0.6, 0);
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// // ── Scan / Upload action card ───────────────────────────────────
// class _ActionCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final bool filled;
//   final VoidCallback onTap;

//   const _ActionCard({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.filled,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(18),
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
//         decoration: BoxDecoration(
//           color: filled ? const Color(0xFF2E7D32) : Colors.white,
//           borderRadius: BorderRadius.circular(18),
//           border: filled ? null : Border.all(color: const Color(0xFF2E7D32).withOpacity(0.4)),
//           boxShadow: filled
//               ? [BoxShadow(color: const Color(0xFF2E7D32).withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 6))]
//               : null,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 44,
//               height: 44,
//               decoration: BoxDecoration(
//                 color: filled ? Colors.white : const Color(0xFF2E7D32).withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(icon, color: const Color(0xFF2E7D32), size: 22),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.bold,
//                 color: filled ? Colors.white : const Color(0xFF1B2E1B),
//               ),
//             ),
//             const SizedBox(height: 2),
//             Text(
//               subtitle,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: filled ? Colors.white70 : Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Feature info card ────────────────────────────────────────────
// class _FeatureCard extends StatelessWidget {
//   final IconData icon;
//   final Color iconBg;
//   final Color iconColor;
//   final String title;
//   final String subtitle;

//   const _FeatureCard({
//     required this.icon,
//     required this.iconBg,
//     required this.iconColor,
//     required this.title,
//     required this.subtitle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 46,
//             height: 46,
//             decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
//             child: Icon(icon, color: iconColor, size: 22),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             title,
//             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B2E1B)),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             subtitle,
//             style: TextStyle(fontSize: 11.5, color: Colors.grey[600], height: 1.4),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ── Bottom nav item ──────────────────────────────────────────────
// class _NavItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool active;
//   final VoidCallback onTap;

//   const _NavItem({
//     required this.icon,
//     required this.label,
//     required this.active,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final color = active ? const Color(0xFF2E7D32) : Colors.grey[500];
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, color: color, size: 24),
//             const SizedBox(height: 4),
//             Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: active ? FontWeight.bold : FontWeight.normal)),
//             const SizedBox(height: 4),
//             if (active)
//               Container(width: 18, height: 2.5, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
//           ],
//         ),
//       ),
//     );
//   }
// } 



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
import 'about_screen.dart';
import 'camera_capture_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  int _bottomNavIndex = 0; // 0 = Home, 1 = About (About screen not wired — UI only)

  bool get _isWeb     => kIsWeb;
  bool get _isMobile  => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  bool get _isDesktop => !kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS);

  // ── SCAN — opens camera on mobile/web, shows dialog on desktop ─
  // (unchanged logic)
  Future<void> _scanWithCamera() async {
    if (_isDesktop) {
      _showDesktopCameraDialog();
      return;
    }

    final lang = context.read<LanguageProvider>();
    try {
      if (_isWeb) {
        // Desktop browsers (Chrome, etc.) don't support image_picker's
        // camera source as a real webcam feed — it just falls back to a
        // file picker. Use a live camera preview screen instead.
        final CapturedPhoto? captured = await Navigator.push<CapturedPhoto>(
          context,
          MaterialPageRoute(builder: (_) => const CameraCaptureScreen()),
        );
        if (captured == null) return;
        setState(() => _isLoading = true);
        final prediction = await ApiService.predictDiseaseFromBytes(
          imageBytes: captured.bytes,
          fileName: captured.fileName,
          language: lang.language,
        );
        if (!mounted) return;
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => ResultScreen(result: prediction, imageBytes: captured.bytes),
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
  // (unchanged logic)
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
  // (unchanged logic)
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
              _uploadFromGallery();
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

  // ══════════════════════════════════════════════════════════
  // UI — matches the reference design
  // ══════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F8EE),
      body: _isLoading ? _buildLoading(lang) : _buildBody(context, lang),
      bottomNavigationBar: _isLoading ? null : _buildBottomNav(lang),
    );
  }

  // ── Loading state ────────────────────────────────────────────
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

  // ── Main body ─────────────────────────────────────────────────
  Widget _buildBody(BuildContext context, LanguageProvider lang) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(lang),
            const SizedBox(height: 22),
            _buildHeroImage(lang),
            const SizedBox(height: 10),
            _buildDots(),
            const SizedBox(height: 22),
            Text(
              lang.t('Detect Lemon Leaf Diseases 🍃', 'कागती पातका रोगहरू पत्ता लगाउनुहोस् 🍃'),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
                height: 1.2,
              ),
            ),
            Text(
              lang.t('Using Deep Learning (CNN)', 'डीप लर्निङ (CNN) प्रयोग गरेर'),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              lang.t(
                'Upload or scan a lemon leaf image to instantly identify diseases and receive treatment recommendations.',
                'रोग पहिचान गर्न र उपचार सुझाव पाउन कागती पातको फोटो अपलोड वा स्क्यान गर्नुहोस्।',
              ),
              style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
            ),
            const SizedBox(height: 24),
            _buildActionButtons(lang),
            const SizedBox(height: 24),
            _buildFeatureCards(lang),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // ── Top bar: logo + title + language toggle ───────────────────
  Widget _buildTopBar(LanguageProvider lang) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('🍋', style: TextStyle(fontSize: 44)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang.t('Automated', 'स्वचालित'),
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
              Text(
                lang.t('Lemon Leaf Disease\nDetection Using CNN', 'कागती पातको रोग\nपहिचान (CNN प्रयोग गरी)'),
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2E1B),
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        _buildLangToggle(lang),
      ],
    );
  }

  Widget _buildLangToggle(LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: GestureDetector(
        onTap: lang.toggleLanguage,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _langSegment('English', !lang.isNepali),
            _langSegment('नेपाली', lang.isNepali),
          ],
        ),
      ),
    );
  }

  Widget _langSegment(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF2E7D32) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: active ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }

  // ── Hero lemon leaf image with decorative scan-frame overlay ──
  Widget _buildHeroImage(LanguageProvider lang) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: const Color(0xFF2E7D32).withOpacity(0.18), blurRadius: 16, offset: const Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/lemon_leaf.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Container(
                color: const Color(0xFF2E7D32).withOpacity(0.15),
                child: const Icon(Icons.eco, size: 60, color: Color(0xFF2E7D32)),
              ),
            ),
            // corner scan-frame brackets (decorative)
            const Positioned(top: 16, left: 16, child: _ScanCorner()),
            Positioned(top: 16, right: 16, child: Transform.rotate(angle: 1.5708, child: const _ScanCorner())),
            Positioned(bottom: 16, left: 16, child: Transform.rotate(angle: -1.5708, child: const _ScanCorner())),
            Positioned(bottom: 16, right: 16, child: Transform.rotate(angle: 3.1416, child: const _ScanCorner())),

            // "AI SCANNING" badge — left side
            Positioned(
              left: 14,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        lang.t('AI SCANNING', 'AI स्क्यानिङ'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // "DETECTION" result card — right side
            Positioned(
              right: 14,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 108,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.greenAccent.withOpacity(0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang.t('DETECTION', 'पहिचान'),
                        style: const TextStyle(color: Colors.white70, fontSize: 9.5, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.greenAccent, width: 1.5),
                          ),
                          child: const Icon(Icons.check, color: Colors.greenAccent, size: 18),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Divider(color: Colors.white24, height: 1),
                      const SizedBox(height: 8),
                      Text(
                        lang.t('HEALTHY', 'स्वस्थ'),
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lang.t('CONFIDENCE', 'विश्वास'),
                        style: const TextStyle(color: Colors.white54, fontSize: 8.5, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '98.6%',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: 0.986,
                          minHeight: 4,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation(Colors.greenAccent),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dot(false),
        const SizedBox(width: 5),
        _dot(true),
        const SizedBox(width: 5),
        _dot(false),
      ],
    );
  }

  Widget _dot(bool active) => Container(
        width: active ? 18 : 6,
        height: 6,
        decoration: BoxDecoration(
          color: active ? const Color(0xFF2E7D32) : Colors.grey[300],
          borderRadius: BorderRadius.circular(3),
        ),
      );

  // ── Scan Leaf / Upload Image buttons ───────────────────────────
  Widget _buildActionButtons(LanguageProvider lang) {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            icon: Icons.camera_alt_rounded,
            title: lang.t('Scan Leaf', 'पात स्क्यान'),
            subtitle: lang.t('Use Camera', 'क्यामेरा प्रयोग गर्नुहोस्'),
            filled: true,
            onTap: _scanWithCamera,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _ActionCard(
            icon: Icons.image_outlined,
            title: lang.t('Upload Image', 'फोटो अपलोड'),
            subtitle: lang.t('Choose from Gallery', 'ग्यालरीबाट छान्नुहोस्'),
            filled: false,
            onTap: _uploadFromGallery,
          ),
        ),
      ],
    );
  }

  // ── Feature cards — restored to 3 cards matching the reference design:
  // AI Disease Detection, Instant Results, Treatment Suggestions ────────
  Widget _buildFeatureCards(LanguageProvider lang) {
    return Row(
      children: [
        Expanded(
          child: _FeatureCard(
            icon: Icons.eco_rounded,
            iconBg: const Color(0xFFE0F2E9),
            iconColor: const Color(0xFF2E7D32),
            title: lang.t('AI Disease\nDetection', 'AI रोग\nपहिचान'),
            subtitle: lang.t('Advanced CNN model to accurately detect lemon leaf diseases.', 'सटीक रूपमा कागती पातका रोगहरू पत्ता लगाउन उन्नत CNN मोडेल।'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _FeatureCard(
            icon: Icons.bolt_rounded,
            iconBg: Colors.amber[100]!,
            iconColor: Colors.amber[800]!,
            title: lang.t('Instant\nResults', 'तुरुन्त\nनतिजा'),
            subtitle: lang.t('Get fast and accurate results within seconds.', 'सेकेन्डभित्रै छिटो र सही नतिजा पाउनुहोस्।'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _FeatureCard(
            icon: Icons.medication_liquid_outlined,
            iconBg: const Color(0xFFE0F2E9),
            iconColor: const Color(0xFF2E7D32),
            title: lang.t('Treatment\nSuggestions', 'उपचार\nसुझाव'),
            subtitle: lang.t('Receive effective treatment and care recommendations.', 'प्रभावकारी उपचार र स्याहार सुझाव पाउनुहोस्।'),
          ),
        ),
      ],
    );
  }

  // ── Bottom nav (History & Settings removed — Home & About only) ─
  Widget _buildBottomNav(LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, -3)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavItem(
              icon: Icons.home_rounded,
              label: lang.t('Home', 'गृह'),
              active: _bottomNavIndex == 0,
              onTap: () => setState(() => _bottomNavIndex = 0),
            ),
            _NavItem(
              icon: Icons.info_outline_rounded,
              label: lang.t('About', 'बारेमा'),
              active: _bottomNavIndex == 1,
              onTap: () async {
                setState(() => _bottomNavIndex = 1);
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                );
                if (mounted) setState(() => _bottomNavIndex = 0);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Scan-frame corner bracket (decorative) ─────────────────────────
class _ScanCorner extends StatelessWidget {
  const _ScanCorner();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(28, 28),
      painter: _CornerPainter(),
    );
  }
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(0, size.height * 0.6)
      ..lineTo(0, 0)
      ..lineTo(size.width * 0.6, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Scan / Upload action card ───────────────────────────────────
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool filled;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF2E7D32) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: filled ? null : Border.all(color: const Color(0xFF2E7D32).withOpacity(0.4)),
          boxShadow: filled
              ? [BoxShadow(color: const Color(0xFF2E7D32).withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 6))]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: filled ? Colors.white : const Color(0xFF2E7D32).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF2E7D32), size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: filled ? Colors.white : const Color(0xFF1B2E1B),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: filled ? Colors.white70 : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Feature info card ────────────────────────────────────────────
class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _FeatureCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1B2E1B)),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10.5, color: Colors.grey[600], height: 1.35),
          ),
        ],
      ),
    );
  }
}

// ── Bottom nav item ──────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF2E7D32) : Colors.grey[500];
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: active ? FontWeight.bold : FontWeight.normal)),
            const SizedBox(height: 4),
            if (active)
              Container(width: 18, height: 2.5, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          ],
        ),
      ),
    );
  }
}