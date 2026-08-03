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



import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/prediction_model.dart';
import '../utils/language_provider.dart';

class ResultScreen extends StatelessWidget {
  final PredictionResult result;
  final File? imageFile;
  final Uint8List? imageBytes;

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

  // ── Leaf image — FULL image visible (BoxFit.contain), no cropping ──
  Widget _buildLeafImage() {
    Widget img;
    if (kIsWeb && imageBytes != null) {
      img = Image.memory(imageBytes!, fit: BoxFit.contain);
    } else if (imageFile != null) {
      img = Image.file(imageFile!, fit: BoxFit.contain);
    } else {
      img = const Icon(Icons.image_not_supported, size: 60, color: Colors.grey);
    }

    return Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF5EA),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          color: Colors.black.withOpacity(0.03),
          width: double.infinity,
          height: double.infinity,
          child: img,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final treatment = result.treatment?.forLanguage(lang.language);

    print('=== RESULT SCREEN ===');
    print('isLemon: ${result.isLemon}');
    print('disease: ${result.disease}');
    print('confidence: ${result.confidence}');
    print('treatment null? ${result.treatment == null}');
    print('====================');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        title: Text(lang.t('Analysis Result', 'विश्लेषण नतिजा'),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Leaf image — box-shadow wrapper
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2E7D32).withOpacity(0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: _buildLeafImage(),
            ),
            const SizedBox(height: 18),

            // ══ NOT A LEMON LEAF ══════════════════════════════
            if (result.isNotLemon) ...[
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
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.cancel_outlined,
                        color: Colors.red, size: 40),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    lang.t('Not a Lemon Leaf', 'कागती पात होइन'),
                    style: const TextStyle(fontSize: 22,
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    lang.t(
                      'This image does not appear to be a lemon leaf.\nPlease take a clear photo of a lemon leaf and try again.',
                      'यो तस्बिर कागती पात जस्तो देखिँदैन।\nकृपया कागती पातको स्पष्ट फोटो खिचेर पुनः प्रयास गर्नुहोस्।',
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red[700],
                        fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 16),
                  // Tips for better photo
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
                        _tipRow(lang.t('• Use only lemon leaf', '• कागती पात मात्र प्रयोग गर्नुहोस्')),
                        _tipRow(lang.t('• Good lighting', '• राम्रो प्रकाश')),
                        _tipRow(lang.t('• Fill frame with leaf', '• फ्रेम पातले भर्नुहोस्')),
                      ],
                    ),
                  ),
                ]),
              ),
            ]

            // ══ LEMON LEAF DETECTED ═══════════════════════════
            else ...[
              // Result card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                      color: _severityColor.withOpacity(0.25), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: _severityColor.withOpacity(0.08),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status row
                    Row(children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: _severityColor.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          result.isHealthy
                              ? Icons.check_circle
                              : Icons.warning_amber_rounded,
                          color: _severityColor, size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          treatment?.status.isNotEmpty == true
                              ? treatment!.status
                              : result.disease.isNotEmpty
                                  ? result.disease
                                  : lang.t('Lemon Leaf Detected',
                                      'कागती पात पहिचान भयो'),
                          style: TextStyle(fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _severityColor),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 12),

                    // Disease badge
                    if (result.disease.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _severityColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: _severityColor.withOpacity(0.3)),
                        ),
                        child: Text(result.disease,
                            style: TextStyle(color: _severityColor,
                                fontWeight: FontWeight.bold, fontSize: 13)),
                      ),

                    if (result.confidence > 0) ...[
                      const SizedBox(height: 14),
                      Row(children: [
                        Text(lang.t('Confidence', 'विश्वास'),
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 13)),
                        const Spacer(),
                        Text(
                          '${(result.confidence * 100).toStringAsFixed(1)}%',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 15, color: _severityColor),
                        ),
                      ]),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: result.confidence.clamp(0.0, 1.0),
                          minHeight: 8,
                          backgroundColor: Colors.grey[200],
                          color: _severityColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Treatment steps — timeline style
              if (treatment != null && treatment.treatment.isNotEmpty) ...[
                _SectionHeader(
                  icon: Icons.medical_services_rounded,
                  label: lang.t('Treatment Steps', 'उपचार विधि'),
                  color: Colors.red[700]!,
                ),
                const SizedBox(height: 12),
                _Timeline(
                  steps: treatment.treatment,
                  color: Colors.red[600]!,
                ),
                const SizedBox(height: 22),
              ],

              // Prevention tips — card grid
              if (treatment != null && treatment.prevention.isNotEmpty) ...[
                _SectionHeader(
                  icon: Icons.shield_rounded,
                  label: lang.t('Prevention Tips', 'रोकथाम सुझाव'),
                  color: Colors.green[700]!,
                ),
                const SizedBox(height: 12),
                ...treatment.prevention.map((tip) => _PreventionTile(text: tip)),
                const SizedBox(height: 22),
              ],

              // No treatment available message
              if (treatment == null && result.isLemon) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(children: [
                    Icon(Icons.info_outline, color: Colors.blue[600]),
                    const SizedBox(width: 10),
                    Expanded(child: Text(
                      lang.t(
                        'Lemon leaf detected. Treatment information not available for this disease yet.',
                        'कागती पात पहिचान भयो। यस रोगको उपचार जानकारी अहिले उपलब्ध छैन।',
                      ),
                      style: TextStyle(color: Colors.blue[700], fontSize: 13),
                    )),
                  ]),
                ),
                const SizedBox(height: 22),
              ],
            ],

            // Scan again button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.camera_alt),
                label: Text(lang.t(
                    'Scan Another Leaf', 'अर्को पात स्क्यान गर्नुहोस्')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
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
        ),
      ),
    );
  }

  Widget _tipRow(String text) => Padding(
    padding: const EdgeInsets.only(top: 3),
    child: Text(text, style: const TextStyle(fontSize: 12)),
  );
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _SectionHeader(
      {required this.icon, required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Row(children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      ]);
}

// ── Treatment steps rendered as a connected vertical timeline ──────
class _Timeline extends StatelessWidget {
  final List<String> steps;
  final Color color;
  const _Timeline({required this.steps, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (i) {
        final isLast = i == steps.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.35),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text('${i + 1}',
                        style: const TextStyle(color: Colors.white,
                            fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        color: color.withOpacity(0.25),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: isLast ? 0 : 14),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.2)),
                  ),
                  child: Text(steps[i],
                      style: const TextStyle(fontSize: 14, height: 1.45)),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// ── Prevention tip — icon-led card ──────────────────────────────────
class _PreventionTile extends StatelessWidget {
  final String text;
  const _PreventionTile({required this.text});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green[200]!),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 26,
            height: 26,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: Colors.green[600],
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.check, color: Colors.white, size: 15),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text,
              style: const TextStyle(fontSize: 14, height: 1.45))),
        ]),
      );
}