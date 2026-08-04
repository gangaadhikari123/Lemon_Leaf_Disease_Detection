// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/prediction_model.dart';
// import '../utils/language_provider.dart';

// class ResultScreen extends StatelessWidget {
//   final PredictionResult result;
//   final File? imageFile;
//   final Uint8List? imageBytes;

//   const ResultScreen({
//     super.key,
//     required this.result,
//     this.imageFile,
//     this.imageBytes,
//   });

//   Color get _severityColor {
//     switch (result.severityLevel) {
//       case 'high':   return Colors.red[700]!;
//       case 'medium': return Colors.orange[700]!;
//       default:       return Colors.green[700]!;
//     }
//   }

//   Widget _buildLeafImage() {
//     if (kIsWeb && imageBytes != null) {
//       return Image.memory(imageBytes!, width: double.infinity,
//           height: 220, fit: BoxFit.cover);
//     } else if (imageFile != null) {
//       return Image.file(imageFile!, width: double.infinity,
//           height: 220, fit: BoxFit.cover);
//     }
//     return Container(height: 220, color: Colors.grey[200],
//         child: const Icon(Icons.image_not_supported,
//             size: 60, color: Colors.grey));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final lang = context.watch<LanguageProvider>();
//     final treatment = result.treatment?.forLanguage(lang.language);

//     print('=== RESULT SCREEN ===');
//     print('isLemon: ${result.isLemon}');
//     print('disease: ${result.disease}');
//     print('confidence: ${result.confidence}');
//     print('treatment null? ${result.treatment == null}');
//     print('====================');

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F9F0),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF2E7D32),
//         title: Text(lang.t('Analysis Result', 'विश्लेषण नतिजा'),
//             style: const TextStyle(color: Colors.white)),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             // Leaf image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: _buildLeafImage(),
//             ),
//             const SizedBox(height: 16),

//             // ══ NOT A LEMON LEAF ══════════════════════════════
//             if (result.isNotLemon) ...[
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   color: Colors.red[50],
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: Colors.red[300]!, width: 1.5),
//                 ),
//                 child: Column(children: [
//                   const Icon(Icons.cancel_outlined,
//                       color: Colors.red, size: 56),
//                   const SizedBox(height: 14),
//                   Text(
//                     lang.t('Not a Lemon Leaf', 'कागती पात होइन'),
//                     style: const TextStyle(fontSize: 22,
//                         fontWeight: FontWeight.bold, color: Colors.red),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     lang.t(
//                       'This image does not appear to be a lemon leaf.\nPlease take a clear photo of a lemon leaf and try again.',
//                       'यो तस्बिर कागती पात जस्तो देखिँदैन।\nकृपया कागती पातको स्पष्ट फोटो खिचेर पुनः प्रयास गर्नुहोस्।',
//                     ),
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.red[700],
//                         fontSize: 14, height: 1.6),
//                   ),
//                   const SizedBox(height: 16),
//                   // Tips for better photo
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.red[100],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(lang.t('Tips:', 'सुझाव:'),
//                             style: const TextStyle(fontWeight: FontWeight.bold)),
//                         const SizedBox(height: 6),
//                         _tipRow(lang.t('• Use only lemon leaf', '• कागती पात मात्र प्रयोग गर्नुहोस्')),
//                         _tipRow(lang.t('• Good lighting', '• राम्रो प्रकाश')),
//                         _tipRow(lang.t('• Fill frame with leaf', '• फ्रेम पातले भर्नुहोस्')),
//                       ],
//                     ),
//                   ),
//                 ]),
//               ),
//             ]

//             // ══ LEMON LEAF DETECTED ═══════════════════════════
//             else ...[
//               // Result card
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: _severityColor.withOpacity(0.08),
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(
//                       color: _severityColor.withOpacity(0.4), width: 1.5),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Status row
//                     Row(children: [
//                       Icon(
//                         result.isHealthy
//                             ? Icons.check_circle
//                             : Icons.warning_amber_rounded,
//                         color: _severityColor, size: 30,
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Text(
//                           treatment?.status.isNotEmpty == true
//                               ? treatment!.status
//                               : result.disease.isNotEmpty
//                                   ? result.disease
//                                   : lang.t('Lemon Leaf Detected',
//                                       'कागती पात पहिचान भयो'),
//                           style: TextStyle(fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: _severityColor),
//                         ),
//                       ),
//                     ]),
//                     const SizedBox(height: 10),

//                     // Disease badge
//                     if (result.disease.isNotEmpty)
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 5),
//                         decoration: BoxDecoration(
//                           color: _severityColor.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(
//                               color: _severityColor.withOpacity(0.3)),
//                         ),
//                         child: Text(result.disease,
//                             style: TextStyle(color: _severityColor,
//                                 fontWeight: FontWeight.bold, fontSize: 13)),
//                       ),

//                     if (result.confidence > 0) ...[
//                       const SizedBox(height: 12),
//                       Row(children: [
//                         Text(lang.t('Confidence: ', 'विश्वास: '),
//                             style: TextStyle(
//                                 color: Colors.grey[600], fontSize: 13)),
//                         Text(
//                           '${(result.confidence * 100).toStringAsFixed(1)}%',
//                           style: TextStyle(fontWeight: FontWeight.bold,
//                               color: _severityColor),
//                         ),
//                       ]),
//                       const SizedBox(height: 6),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: LinearProgressIndicator(
//                           value: result.confidence.clamp(0.0, 1.0),
//                           minHeight: 8,
//                           backgroundColor: Colors.grey[200],
//                           color: _severityColor,
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Treatment steps
//               if (treatment != null && treatment.treatment.isNotEmpty) ...[
//                 _SectionHeader(
//                   icon: Icons.medical_services,
//                   label: lang.t('Treatment Steps', 'उपचार विधि'),
//                   color: Colors.red[700]!,
//                 ),
//                 const SizedBox(height: 8),
//                 ...treatment.treatment.asMap().entries.map((e) =>
//                     _StepCard(step: e.key + 1, text: e.value,
//                         color: Colors.red[50]!,
//                         borderColor: Colors.red[200]!)),
//                 const SizedBox(height: 20),
//               ],

//               // Prevention tips
//               if (treatment != null && treatment.prevention.isNotEmpty) ...[
//                 _SectionHeader(
//                   icon: Icons.shield,
//                   label: lang.t('Prevention Tips', 'रोकथाम सुझाव'),
//                   color: Colors.green[700]!,
//                 ),
//                 const SizedBox(height: 8),
//                 ...treatment.prevention.map((tip) =>
//                     _BulletCard(text: tip, color: Colors.green[50]!,
//                         borderColor: Colors.green[200]!)),
//                 const SizedBox(height: 20),
//               ],

//               // No treatment available message
//               if (treatment == null && result.isLemon) ...[
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.blue[50],
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.blue[200]!),
//                   ),
//                   child: Row(children: [
//                     Icon(Icons.info_outline, color: Colors.blue[600]),
//                     const SizedBox(width: 10),
//                     Expanded(child: Text(
//                       lang.t(
//                         'Lemon leaf detected. Treatment information not available for this disease yet.',
//                         'कागती पात पहिचान भयो। यस रोगको उपचार जानकारी अहिले उपलब्ध छैन।',
//                       ),
//                       style: TextStyle(color: Colors.blue[700], fontSize: 13),
//                     )),
//                   ]),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ],

//             // Scan again button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: () => Navigator.pop(context),
//                 icon: const Icon(Icons.camera_alt),
//                 label: Text(lang.t(
//                     'Scan Another Leaf', 'अर्को पात स्क्यान गर्नुहोस्')),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF2E7D32),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 32),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _tipRow(String text) => Padding(
//     padding: const EdgeInsets.only(top: 3),
//     child: Text(text, style: const TextStyle(fontSize: 12)),
//   );
// }

// class _SectionHeader extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color color;
//   const _SectionHeader(
//       {required this.icon, required this.label, required this.color});
//   @override
//   Widget build(BuildContext context) => Row(children: [
//         Icon(icon, color: color, size: 22),
//         const SizedBox(width: 8),
//         Text(label, style: TextStyle(
//             fontSize: 16, fontWeight: FontWeight.bold, color: color)),
//       ]);
// }

// class _StepCard extends StatelessWidget {
//   final int step;
//   final String text;
//   final Color color;
//   final Color borderColor;
//   const _StepCard({required this.step, required this.text,
//       required this.color, required this.borderColor});
//   @override
//   Widget build(BuildContext context) => Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(color: color,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: borderColor)),
//         child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           CircleAvatar(radius: 12, backgroundColor: borderColor,
//               child: Text('$step', style: const TextStyle(
//                   fontSize: 12, fontWeight: FontWeight.bold))),
//           const SizedBox(width: 10),
//           Expanded(child: Text(text,
//               style: const TextStyle(fontSize: 14, height: 1.4))),
//         ]),
//       );
// }

// class _BulletCard extends StatelessWidget {
//   final String text;
//   final Color color;
//   final Color borderColor;
//   const _BulletCard({required this.text, required this.color,
//       required this.borderColor});
//   @override
//   Widget build(BuildContext context) => Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(color: color,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: borderColor)),
//         child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           const Text('• ', style: TextStyle(fontSize: 18,
//               fontWeight: FontWeight.bold, color: Colors.green)),
//           const SizedBox(width: 6),
//           Expanded(child: Text(text,
//               style: const TextStyle(fontSize: 14, height: 1.4))),
//         ]),
//       );
// }



// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/prediction_model.dart';
// import '../utils/language_provider.dart';

// class ResultScreen extends StatelessWidget {
//   final PredictionResult result;
//   final File? imageFile;
//   final Uint8List? imageBytes;

//   const ResultScreen({
//     super.key,
//     required this.result,
//     this.imageFile,
//     this.imageBytes,
//   });

//   Color get _severityColor {
//     switch (result.severityLevel) {
//       case 'high':   return Colors.red[700]!;
//       case 'medium': return Colors.orange[700]!;
//       default:       return Colors.green[700]!;
//     }
//   }

//   // ── Leaf image — FULL image visible (BoxFit.contain), no cropping ──
//   Widget _buildLeafImage() {
//     Widget img;
//     if (kIsWeb && imageBytes != null) {
//       img = Image.memory(imageBytes!, fit: BoxFit.contain);
//     } else if (imageFile != null) {
//       img = Image.file(imageFile!, fit: BoxFit.contain);
//     } else {
//       img = const Icon(Icons.image_not_supported, size: 60, color: Colors.grey);
//     }

//     return Container(
//       width: double.infinity,
//       height: 280,
//       decoration: BoxDecoration(
//         color: const Color(0xFFEFF5EA),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       padding: const EdgeInsets.all(10),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(14),
//         child: Container(
//           color: Colors.black.withOpacity(0.03),
//           width: double.infinity,
//           height: double.infinity,
//           child: img,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final lang = context.watch<LanguageProvider>();
//     final treatment = result.treatment?.forLanguage(lang.language);

//     print('=== RESULT SCREEN ===');
//     print('isLemon: ${result.isLemon}');
//     print('disease: ${result.disease}');
//     print('confidence: ${result.confidence}');
//     print('treatment null? ${result.treatment == null}');
//     print('====================');

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F9F0),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF2E7D32),
//         elevation: 0,
//         title: Text(lang.t('Analysis Result', 'विश्लेषण नतिजा'),
//             style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             // Leaf image — box-shadow wrapper
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFF2E7D32).withOpacity(0.12),
//                     blurRadius: 16,
//                     offset: const Offset(0, 8),
//                   ),
//                 ],
//               ),
//               child: _buildLeafImage(),
//             ),
//             const SizedBox(height: 18),

//             // ══ NOT A LEMON LEAF ══════════════════════════════
//             if (result.isNotLemon) ...[
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   color: Colors.red[50],
//                   borderRadius: BorderRadius.circular(18),
//                   border: Border.all(color: Colors.red[300]!, width: 1.5),
//                 ),
//                 child: Column(children: [
//                   Container(
//                     width: 76,
//                     height: 76,
//                     decoration: BoxDecoration(
//                       color: Colors.red[100],
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(Icons.cancel_outlined,
//                         color: Colors.red, size: 40),
//                   ),
//                   const SizedBox(height: 14),
//                   Text(
//                     lang.t('Not a Lemon Leaf', 'कागती पात होइन'),
//                     style: const TextStyle(fontSize: 22,
//                         fontWeight: FontWeight.bold, color: Colors.red),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     lang.t(
//                       'This image does not appear to be a lemon leaf.\nPlease take a clear photo of a lemon leaf and try again.',
//                       'यो तस्बिर कागती पात जस्तो देखिँदैन।\nकृपया कागती पातको स्पष्ट फोटो खिचेर पुनः प्रयास गर्नुहोस्।',
//                     ),
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.red[700],
//                         fontSize: 14, height: 1.6),
//                   ),
//                   const SizedBox(height: 16),
//                   // Tips for better photo
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(14),
//                     decoration: BoxDecoration(
//                       color: Colors.red[100],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(lang.t('Tips:', 'सुझाव:'),
//                             style: const TextStyle(fontWeight: FontWeight.bold)),
//                         const SizedBox(height: 6),
//                         _tipRow(lang.t('• Use only lemon leaf', '• कागती पात मात्र प्रयोग गर्नुहोस्')),
//                         _tipRow(lang.t('• Good lighting', '• राम्रो प्रकाश')),
//                         _tipRow(lang.t('• Fill frame with leaf', '• फ्रेम पातले भर्नुहोस्')),
//                       ],
//                     ),
//                   ),
//                 ]),
//               ),
//             ]

//             // ══ LEMON LEAF DETECTED ═══════════════════════════
//             else ...[
//               // Result card
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(18),
//                   border: Border.all(
//                       color: _severityColor.withOpacity(0.25), width: 1.5),
//                   boxShadow: [
//                     BoxShadow(
//                       color: _severityColor.withOpacity(0.08),
//                       blurRadius: 14,
//                       offset: const Offset(0, 6),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Status row
//                     Row(children: [
//                       Container(
//                         width: 46,
//                         height: 46,
//                         decoration: BoxDecoration(
//                           color: _severityColor.withOpacity(0.12),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           result.isHealthy
//                               ? Icons.check_circle
//                               : Icons.warning_amber_rounded,
//                           color: _severityColor, size: 26,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Text(
//                           treatment?.status.isNotEmpty == true
//                               ? treatment!.status
//                               : result.disease.isNotEmpty
//                                   ? result.disease
//                                   : lang.t('Lemon Leaf Detected',
//                                       'कागती पात पहिचान भयो'),
//                           style: TextStyle(fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: _severityColor),
//                         ),
//                       ),
//                     ]),
//                     const SizedBox(height: 12),

//                     // Disease badge
//                     if (result.disease.isNotEmpty)
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: _severityColor.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(
//                               color: _severityColor.withOpacity(0.3)),
//                         ),
//                         child: Text(result.disease,
//                             style: TextStyle(color: _severityColor,
//                                 fontWeight: FontWeight.bold, fontSize: 13)),
//                       ),

//                     if (result.confidence > 0) ...[
//                       const SizedBox(height: 14),
//                       Row(children: [
//                         Text(lang.t('Confidence', 'विश्वास'),
//                             style: TextStyle(
//                                 color: Colors.grey[600], fontSize: 13)),
//                         const Spacer(),
//                         Text(
//                           '${(result.confidence * 100).toStringAsFixed(1)}%',
//                           style: TextStyle(fontWeight: FontWeight.bold,
//                               fontSize: 15, color: _severityColor),
//                         ),
//                       ]),
//                       const SizedBox(height: 8),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: LinearProgressIndicator(
//                           value: result.confidence.clamp(0.0, 1.0),
//                           minHeight: 8,
//                           backgroundColor: Colors.grey[200],
//                           color: _severityColor,
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 22),

//               // Treatment steps — timeline style
//               if (treatment != null && treatment.treatment.isNotEmpty) ...[
//                 _SectionHeader(
//                   icon: Icons.medical_services_rounded,
//                   label: lang.t('Treatment Steps', 'उपचार विधि'),
//                   color: Colors.red[700]!,
//                 ),
//                 const SizedBox(height: 12),
//                 _Timeline(
//                   steps: treatment.treatment,
//                   color: Colors.red[600]!,
//                 ),
//                 const SizedBox(height: 22),
//               ],

//               // Prevention tips — card grid
//               if (treatment != null && treatment.prevention.isNotEmpty) ...[
//                 _SectionHeader(
//                   icon: Icons.shield_rounded,
//                   label: lang.t('Prevention Tips', 'रोकथाम सुझाव'),
//                   color: Colors.green[700]!,
//                 ),
//                 const SizedBox(height: 12),
//                 ...treatment.prevention.map((tip) => _PreventionTile(text: tip)),
//                 const SizedBox(height: 22),
//               ],

//               // No treatment available message
//               if (treatment == null && result.isLemon) ...[
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.blue[50],
//                     borderRadius: BorderRadius.circular(14),
//                     border: Border.all(color: Colors.blue[200]!),
//                   ),
//                   child: Row(children: [
//                     Icon(Icons.info_outline, color: Colors.blue[600]),
//                     const SizedBox(width: 10),
//                     Expanded(child: Text(
//                       lang.t(
//                         'Lemon leaf detected. Treatment information not available for this disease yet.',
//                         'कागती पात पहिचान भयो। यस रोगको उपचार जानकारी अहिले उपलब्ध छैन।',
//                       ),
//                       style: TextStyle(color: Colors.blue[700], fontSize: 13),
//                     )),
//                   ]),
//                 ),
//                 const SizedBox(height: 22),
//               ],
//             ],

//             // Scan again button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: () => Navigator.pop(context),
//                 icon: const Icon(Icons.camera_alt),
//                 label: Text(lang.t(
//                     'Scan Another Leaf', 'अर्को पात स्क्यान गर्नुहोस्')),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF2E7D32),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14)),
//                   elevation: 2,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _tipRow(String text) => Padding(
//     padding: const EdgeInsets.only(top: 3),
//     child: Text(text, style: const TextStyle(fontSize: 12)),
//   );
// }

// class _SectionHeader extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color color;
//   const _SectionHeader(
//       {required this.icon, required this.label, required this.color});
//   @override
//   Widget build(BuildContext context) => Row(children: [
//         Container(
//           width: 32,
//           height: 32,
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.12),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(icon, color: color, size: 18),
//         ),
//         const SizedBox(width: 10),
//         Text(label, style: TextStyle(
//             fontSize: 16, fontWeight: FontWeight.bold, color: color)),
//       ]);
// }

// // ── Treatment steps rendered as a connected vertical timeline ──────
// class _Timeline extends StatelessWidget {
//   final List<String> steps;
//   final Color color;
//   const _Timeline({required this.steps, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: List.generate(steps.length, (i) {
//         final isLast = i == steps.length - 1;
//         return IntrinsicHeight(
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Column(
//                 children: [
//                   Container(
//                     width: 26,
//                     height: 26,
//                     decoration: BoxDecoration(
//                       color: color,
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: color.withOpacity(0.35),
//                           blurRadius: 6,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     alignment: Alignment.center,
//                     child: Text('${i + 1}',
//                         style: const TextStyle(color: Colors.white,
//                             fontWeight: FontWeight.bold, fontSize: 12)),
//                   ),
//                   if (!isLast)
//                     Expanded(
//                       child: Container(
//                         width: 2,
//                         margin: const EdgeInsets.symmetric(vertical: 2),
//                         color: color.withOpacity(0.25),
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Container(
//                   margin: EdgeInsets.only(bottom: isLast ? 0 : 14),
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 14, vertical: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: color.withOpacity(0.2)),
//                   ),
//                   child: Text(steps[i],
//                       style: const TextStyle(fontSize: 14, height: 1.45)),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }

// // ── Prevention tip — icon-led card ──────────────────────────────────
// class _PreventionTile extends StatelessWidget {
//   final String text;
//   const _PreventionTile({required this.text});

//   @override
//   Widget build(BuildContext context) => Container(
//         margin: const EdgeInsets.only(bottom: 10),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         decoration: BoxDecoration(
//           color: Colors.green[50],
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.green[200]!),
//         ),
//         child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Container(
//             width: 26,
//             height: 26,
//             margin: const EdgeInsets.only(top: 1),
//             decoration: BoxDecoration(
//               color: Colors.green[600],
//               shape: BoxShape.circle,
//             ),
//             alignment: Alignment.center,
//             child: const Icon(Icons.check, color: Colors.white, size: 15),
//           ),
//           const SizedBox(width: 10),
//           Expanded(child: Text(text,
//               style: const TextStyle(fontSize: 14, height: 1.45))),
//         ]),
//       );
// } 




import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/prediction_model.dart';
import '../utils/language_provider.dart';

// ─────────────────────────────────────────────────────────────────────────
// NOTE ON MODEL: this screen reads `treatment.forLanguage(lang).description`
// for the "About Leaf" card below. TreatmentLanguage (in prediction_model.dart)
// parses "description" from the backend's treatment_map.py response for
// both "en" and "np". If a disease is missing a description for some
// reason, this screen falls back to a local static English description.
// ─────────────────────────────────────────────────────────────────────────

class ResultScreen extends StatefulWidget {
  final PredictionResult result;
  final File? imageFile;
  final Uint8List? imageBytes;

  const ResultScreen({
    super.key,
    required this.result,
    this.imageFile,
    this.imageBytes,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // "Was this helpful?" feedback — purely visual state, wire up to your
  // analytics / API call where marked TODO below.
  bool? _feedbackHelpful;

  PredictionResult get result => widget.result;
  File? get imageFile => widget.imageFile;
  Uint8List? get imageBytes => widget.imageBytes;

  static const _green = Color(0xFF2E7D32);
  static const _bg = Color(0xFFF5F9F0);

  // ══ Local fallback descriptions ═════════════════════════════════════
  // Only used if the backend response for this result doesn't carry a
  // `description` field (see treatment_map.py, which now includes
  // "description" for every disease under both "en" and "np"). Keys here
  // match the backend's exact disease labels, compared case-insensitively.
  static const Map<String, Map<String, String>> _diseaseDescriptions = {
    'healthy leaf': {
      'en':
          'Healthy lemon leaves are generally green, smooth, and free from major spots, lesions, curling, or visible pest damage. This category indicates that the leaf does not show significant disease symptoms.',
      'np':
          'स्वस्थ कागतीको पात सामान्यतया हरियो, चिल्लो, र ठूला थोप्ला, घाउ, मुडुल्लिने वा किराको क्षतिबाट मुक्त हुन्छ। यसले पातमा उल्लेखनीय रोगको लक्षण नदेखिएको जनाउँछ।',
    },
    'anthracnose': {
      'en':
          'Anthracnose is a fungal disease that may cause dark brown or black spots, irregular lesions, and damaged areas on lemon leaves. Severe infection can lead to leaf yellowing and premature leaf drop.',
      'np':
          'एन्थ्राक्नोज एउटा फङ्गल रोग हो, जसले कागतीको पातमा गाढा खैरो वा कालो थोप्ला, अनियमित घाउ र क्षति देखा पार्न सक्छ। गम्भीर संक्रमणले पात पहेंलो भई समयभन्दा अगावै झर्न सक्छ।',
    },
    'bacterial blight': {
      'en':
          'Bacterial blight can cause water-soaked spots, dark lesions, yellowing, and tissue damage. The infection may spread under warm and humid conditions and affect the overall health of the plant.',
      'np':
          'ब्याक्टेरियल ब्लाइटले पातमा पानी भिजेजस्तो थोप्ला, गाढा घाउ, पहेंलोपन र तन्तु क्षति निम्त्याउन सक्छ। तातो र आर्द्र मौसममा यो संक्रमण छिटो फैलिन सक्छ र बोटको समग्र स्वास्थ्यमा असर पार्छ।',
    },
    'citrus canker': {
      'en':
          'Citrus canker is a bacterial disease characterized by raised, rough, cork-like lesions. The affected areas may have brown centers surrounded by yellow halos.',
      'np':
          'सिट्रस क्यान्कर एउटा ब्याक्टेरियल रोग हो, जसमा उठेको, खस्रो, कर्क जस्तो बनावटका घाउहरू देखिन्छन्। संक्रमित भागको बीचमा खैरो र वरिपरि पहेंलो घेरा हुन सक्छ।',
    },
    'curl virus': {
      'en':
          'Curl virus infection may cause leaves to curl, twist, become distorted, or develop unusual growth patterns. Infected leaves may also show yellowing and reduced growth.',
      'np':
          'कर्ल भाइरस संक्रमणले पात मुडुल्लिने, बटारिने, आकार बिग्रिने वा असामान्य बढाइ देखिने समस्या ल्याउन सक्छ। संक्रमित पातमा पहेंलोपन र बढाइ कम हुने लक्षण पनि देखिन सक्छ।',
    },
    'deficiency leaf': {
      'en':
          'Nutrient deficiency can cause leaf yellowing, pale color, uneven chlorosis, or changes in leaf growth. Different nutrient deficiencies may produce different visual symptoms.',
      'np':
          'पोषक तत्वको कमीले पात पहेंलो, फिक्का रङको, असमान क्लोरोसिस, वा पातको बढाइमा परिवर्तन ल्याउन सक्छ। फरक-फरक पोषक तत्वको कमीले फरक-फरक लक्षण देखाउन सक्छ।',
    },
    'dry leaf': {
      'en':
          'Dry leaves may appear brown, crispy, curled, or dehydrated. This condition can be associated with water stress, environmental conditions, aging, or plant health problems.',
      'np':
          'सुकेको पात खैरो, कुरकुरे, मुडुल्लिएको वा निर्जलित देखिन सक्छ। यो अवस्था पानीको कमी, वातावरणीय परिस्थिति, बोटको उमेर, वा बोटको स्वास्थ्य समस्यासँग सम्बन्धित हुन सक्छ।',
    },
    'sooty mould': {
      'en':
          'Sooty mould appears as a black, powdery, or soot-like coating on the surface of leaves. It often grows on sticky honeydew produced by insects such as aphids, whiteflies, or scale insects.',
      'np':
          'सुटी मोल्ड पातको सतहमा कालो, धुलेजस्तो वा धुँवाजस्तो तह भएर देखिन्छ। यो प्रायः लाही, सेतो झिँगा, वा स्केल किराले उत्पादन गर्ने टाँसिने मह (honeydew) मा उम्रन्छ।',
    },
    'spider mites': {
      'en':
          'Spider mites are tiny pests that feed on leaf tissue. Their damage may appear as small yellow or pale spots, discoloration, fine webbing, and gradual leaf drying.',
      'np':
          'स्पाइडर माइट्स साना किराहरू हुन् जसले पातको तन्तु खान्छन्। यिनको क्षति साना पहेंलो वा फिक्का थोप्ला, रङ परिवर्तन, महीन जाला, र बिस्तारै पात सुक्नेको रूपमा देखिन सक्छ।',
    },
  };

  Color get _severityColor {
    switch (result.severityLevel) {
      case 'high':
        return Colors.red[700]!;
      case 'medium':
        return Colors.orange[700]!;
      default:
        return Colors.green[700]!;
    }
  }

  Widget _leafThumb({double size = 100}) {
    Widget img;
    if (kIsWeb && imageBytes != null) {
      img = Image.memory(imageBytes!, fit: BoxFit.cover);
    } else if (imageFile != null) {
      img = Image.file(imageFile!, fit: BoxFit.cover);
    } else {
      img = const Icon(Icons.image_not_supported, size: 32, color: Colors.grey);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(width: size, height: size, child: img),
    );
  }

  Widget _leafFull() {
    Widget img;
    if (kIsWeb && imageBytes != null) {
      img = Image.memory(imageBytes!, fit: BoxFit.cover);
    } else if (imageFile != null) {
      img = Image.file(imageFile!, fit: BoxFit.cover);
    } else {
      img = const Icon(Icons.image_not_supported, size: 60, color: Colors.grey);
    }
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(width: double.infinity, height: 220, child: img),
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: GestureDetector(
            onTap: () => _openFullImage(context),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.45),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.fullscreen, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  void _openFullImage(BuildContext context) {
    Widget img;
    if (kIsWeb && imageBytes != null) {
      img = Image.memory(imageBytes!, fit: BoxFit.contain);
    } else if (imageFile != null) {
      img = Image.file(imageFile!, fit: BoxFit.contain);
    } else {
      return;
    }
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(12),
        child: InteractiveViewer(child: img),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final treatment = result.treatment?.forLanguage(lang.language);
    final now = DateTime.now();
    final dateStr = DateFormat('MMM d, y').format(now);
    final timeStr = DateFormat('hh:mm a').format(now);

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _green),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          lang.t('Detection Result', 'पहिचान नतिजा'),
          style: const TextStyle(
              color: _green, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: _green),
            onPressed: () {
              // TODO: hook up report export / share, logic unchanged.
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (result.isNotLemon)
                // Not-lemon card already has its own "Scan Valid Lemon
                // Leaf" action button below — no extra button needed here.
                _notLemonCard(lang)
              else ...[
                _topResultCard(lang, treatment, dateStr, timeStr),
                const SizedBox(height: 16),
                _aboutDiseaseCard(lang, treatment),
                const SizedBox(height: 16),
                if (treatment != null && treatment.prevention.isNotEmpty) ...[
                  _bulletCard(
                    icon: Icons.shield_rounded,
                    iconColor: Colors.green[700]!,
                    title: lang.t('Prevention', 'रोकथाम'),
                    items: treatment.prevention,
                  ),
                  const SizedBox(height: 16),
                ],
                if (treatment != null && treatment.treatment.isNotEmpty) ...[
                  _bulletCard(
                    icon: Icons.medical_services_rounded,
                    iconColor: Colors.green[800]!,
                    title: lang.t('Treatment', 'उपचार'),
                    items: treatment.treatment,
                  ),
                  const SizedBox(height: 16),
                ],
                if (treatment == null && result.isLemon) ...[
                  _infoNotice(lang),
                  const SizedBox(height: 16),
                ],
                if (result.confidence > 0) ...[
                  _confidenceCard(lang),
                  const SizedBox(height: 16),
                ],
                _uploadedImageCard(lang),
                const SizedBox(height: 16),
                _helpfulRow(lang),
                const SizedBox(height: 16),

                // Scan again — only shown for a valid lemon-leaf result.
                // The not-lemon branch has its own button inside
                // _notLemonCard, so we don't render this one there —
                // that's what removes the duplicate/unwanted button.
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.camera_alt),
                    label: Text(lang.t(
                        'Scan Another Leaf', 'अर्को पात स्क्यान गर्नुहोस्')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomNav(lang),
    );
  }

  // ══ TOP CARD — thumbnail + disease name + confidence + date/time ═══════
  Widget _topResultCard(
      LanguageProvider lang, TreatmentLanguage? treatment, String dateStr, String timeStr) {
    // Prefer the backend's localized status (e.g. "स्वस्थ पात" / "Healthy
    // Leaf") for the big title — falls back to the raw disease code if the
    // backend didn't send a status for this language.
    final displayName = (treatment != null && treatment.status.isNotEmpty)
        ? treatment.status
        : (result.disease.isNotEmpty
            ? result.disease
            : lang.t('Lemon Leaf Detected', 'कागती पात पहिचान भयो'));

    return _card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _leafThumb(size: 96),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.isHealthy
                      ? lang.t('Healthy Leaf', 'स्वस्थ पात')
                      : lang.t('Disease Detected', 'रोग पत्ता लाग्यो'),
                  style: TextStyle(
                      color: _severityColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  displayName,
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                if (result.confidence > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lang.t('Confidence Score', 'विश्वास स्कोर'),
                            style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                        Text(
                          '${(result.confidence * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold, color: _green),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 13, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(dateStr, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    const SizedBox(width: 12),
                    Icon(Icons.access_time, size: 13, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(timeStr, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══ ABOUT LEAF ═══════════════════════════════════════════════════════
  Widget _aboutDiseaseCard(LanguageProvider lang, TreatmentLanguage? treatment) {
    String about;
    // 1) Prefer the backend's own "description" field for this result's
    //    language (treatment_map.py provides this for every disease, in
    //    both "en" and "np" — TreatmentLanguage now parses it directly).
    if (treatment != null && treatment.description.isNotEmpty) {
      about = treatment.description;
    } else {
      // 2) Fall back to the local static map (now language-aware, en+np)
      //    if the backend didn't send a description for some reason.
      final key = result.disease.trim().toLowerCase();
      final fallbackEntry = _diseaseDescriptions[key];
      about = fallbackEntry?[lang.language] ??
          fallbackEntry?['en'] ??
          lang.t(
            'Detailed information about this leaf is not available yet.',
            'यस पातको विस्तृत जानकारी अहिलेसम्म उपलब्ध छैन।',
          );
    }

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[600], size: 20),
              const SizedBox(width: 8),
              Text(
                lang.t('About Leaf', 'पातको बारेमा'),
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(about, style: TextStyle(fontSize: 13.5, height: 1.55, color: Colors.grey[800])),
        ],
      ),
    );
  }

  // ══ Generic bulleted card used for Prevention & Treatment ═══════════
  Widget _bulletCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<String> items,
  }) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(title,
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold, color: iconColor)),
            ],
          ),
          const SizedBox(height: 10),
          ...items.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(t,
                          style: const TextStyle(fontSize: 13.5, height: 1.5)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _infoNotice(LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(children: [
        Icon(Icons.info_outline, color: Colors.blue[600]),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            lang.t(
              'Lemon leaf detected. Treatment information not available for this disease yet.',
              'कागती पात पहिचान भयो। यस रोगको उपचार जानकारी अहिले उपलब्ध छैन।',
            ),
            style: TextStyle(color: Colors.blue[700], fontSize: 13),
          ),
        ),
      ]),
    );
  }

  // ══ MODEL CONFIDENCE BAR ═════════════════════════════════════════════
  Widget _confidenceCard(LanguageProvider lang) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(lang.t('Model Confidence', 'मोडेल विश्वास'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const Spacer(),
            Text('${(result.confidence * 100).toStringAsFixed(1)}%',
                style: const TextStyle(fontWeight: FontWeight.bold, color: _green)),
          ]),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: result.confidence.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              color: _green,
            ),
          ),
        ],
      ),
    );
  }

  // ══ UPLOADED IMAGE ═══════════════════════════════════════════════════
  Widget _uploadedImageCard(LanguageProvider lang) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.image_outlined, color: Colors.grey[700], size: 19),
            const SizedBox(width: 8),
            Text(lang.t('Uploaded Image', 'अपलोड गरिएको तस्बिर'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ]),
          const SizedBox(height: 10),
          _leafFull(),
        ],
      ),
    );
  }

  // ══ WAS THIS HELPFUL? ════════════════════════════════════════════════
  Widget _helpfulRow(LanguageProvider lang) {
    return Row(
      children: [
        Text(lang.t('Was this result helpful?', 'यो नतिजा उपयोगी थियो?'),
            style: TextStyle(fontSize: 13, color: Colors.grey[700])),
        const Spacer(),
        _feedbackChip(
          icon: Icons.thumb_up_alt_outlined,
          label: lang.t('Yes', 'हो'),
          selected: _feedbackHelpful == true,
          color: Colors.green,
          onTap: () {
            setState(() => _feedbackHelpful = true);
            // TODO: send feedback=true to your backend, logic unchanged.
          },
        ),
        const SizedBox(width: 8),
        _feedbackChip(
          icon: Icons.thumb_down_alt_outlined,
          label: lang.t('No', 'होइन'),
          selected: _feedbackHelpful == false,
          color: Colors.red,
          onTap: () {
            setState(() => _feedbackHelpful = false);
            // TODO: send feedback=false to your backend, logic unchanged.
          },
        ),
      ],
    );
  }

  Widget _feedbackChip({
    required IconData icon,
    required String label,
    required bool selected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.15) : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? color : Colors.grey[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: selected ? color : Colors.grey[600]),
            const SizedBox(width: 5),
            Text(label,
                style: TextStyle(
                    fontSize: 12.5,
                    color: selected ? color : Colors.grey[700],
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ══ NOT A LEMON LEAF ═════════════════════════════════════════════════
  Widget _notLemonCard(LanguageProvider lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: _green.withOpacity(0.10), blurRadius: 16, offset: const Offset(0, 8)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: double.infinity,
              height: 220,
              color: const Color(0xFFEFF5EA),
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: (kIsWeb && imageBytes != null)
                    ? Image.memory(imageBytes!, fit: BoxFit.contain)
                    : (imageFile != null)
                        ? Image.file(imageFile!, fit: BoxFit.contain)
                        : const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.red[300]!, width: 1.5),
          ),
          child: Column(children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(color: Colors.red[100], shape: BoxShape.circle),
              child: const Icon(Icons.cancel_outlined, color: Colors.red, size: 40),
            ),
            const SizedBox(height: 14),
            Text(
              lang.t('Not a Lemon Leaf', 'कागती पात होइन'),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 10),
            Text(
              lang.t(
                'This image does not appear to be a lemon leaf.\nPlease scan or upload a clear photo of a valid lemon leaf and try again.',
                'यो तस्बिर कागती पात जस्तो देखिँदैन।\nकृपया मान्य कागती पातको स्पष्ट फोटो स्क्यान वा अपलोड गरेर पुनः प्रयास गर्नुहोस्।',
              ),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red[700], fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lang.t('Tips:', 'सुझाव:'),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(lang.t('• Use only a lemon leaf', '• कागती पात मात्र प्रयोग गर्नुहोस्'),
                      style: const TextStyle(fontSize: 12)),
                  Text(lang.t('• Good lighting', '• राम्रो प्रकाश'),
                      style: const TextStyle(fontSize: 12)),
                  Text(lang.t('• Fill frame with leaf', '• फ्रेम पातले भर्नुहोस्'),
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // The ONLY action button on this branch — no duplicate
            // "Scan Another Leaf" button is rendered below it.
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.camera_alt),
                label: Text(lang.t('Scan Valid Lemon Leaf', 'मान्य कागती पात स्क्यान गर्नुहोस्')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }

  // ══ SHARED CARD WRAPPER ══════════════════════════════════════════════
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }

  // ══ BOTTOM BAR — Home only ═══════════════════════════════════════════
  // NOTE: Flutter's BottomNavigationBar requires at least 2 items or it
  // throws an assertion error, so a single-button bar is built manually
  // here instead of using BottomNavigationBar with one item.
  Widget _bottomNav(LanguageProvider lang) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: InkWell(
          onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.home_rounded, color: _green, size: 26),
                const SizedBox(height: 2),
                Text(
                  lang.t('Home', 'गृह'),
                  style: const TextStyle(color: _green, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}