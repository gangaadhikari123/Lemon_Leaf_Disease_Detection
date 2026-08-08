import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import '../utils/language_provider.dart';

/// Result returned when a photo is captured.
class CapturedPhoto {
  final Uint8List bytes;
  final String fileName;
  CapturedPhoto({required this.bytes, required this.fileName});
}

/// Live camera preview screen — used on web/desktop where the browser's
/// native camera capture isn't available (Chrome on a laptop just opens
/// a file picker instead of the webcam). This gives an actual live feed
/// from the webcam with a capture button.
class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;
  bool _isInitializing = true;
  bool _isCapturing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _errorMessage = 'no_camera';
          _isInitializing = false;
        });
        return;
      }
      await _initController(_selectedCameraIndex);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isInitializing = false;
      });
    }
  }

  Future<void> _initController(int index) async {
    setState(() => _isInitializing = true);
    final previous = _controller;
    final newController = CameraController(
      _cameras[index],
      ResolutionPreset.high,
      enableAudio: false,
    );
    try {
      await newController.initialize();
      await previous?.dispose();
      if (!mounted) return;
      setState(() {
        _controller = newController;
        _selectedCameraIndex = index;
        _isInitializing = false;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isInitializing = false;
      });
    }
  }

  void _switchCamera() {
    if (_cameras.length < 2) return;
    final nextIndex = (_selectedCameraIndex + 1) % _cameras.length;
    _initController(nextIndex);
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isCapturing) return;

    setState(() => _isCapturing = true);
    try {
      final XFile file = await controller.takePicture();
      final Uint8List bytes = await file.readAsBytes();
      if (!mounted) return;
      Navigator.pop(
        context,
        CapturedPhoto(
          bytes: bytes,
          fileName: 'scan_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isCapturing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Capture failed: $e')),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // ── Camera preview / states ──
            Positioned.fill(child: _buildPreview(lang)),

            // ── Top bar ──
            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleButton(
                    icon: Icons.close_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  if (_cameras.length > 1)
                    _circleButton(
                      icon: Icons.cameraswitch_rounded,
                      onTap: _switchCamera,
                    ),
                ],
              ),
            ),

            // ── Bottom capture button ──
            if (_controller != null && _controller!.value.isInitialized)
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: _capture,
                    child: Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: Center(
                        child: _isCapturing
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview(LanguageProvider lang) {
    if (_isInitializing) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    if (_errorMessage == 'no_camera') {
      return _messageState(
        icon: Icons.videocam_off_rounded,
        text: lang.t(
          'No camera found on this device.',
          'यस device मा कुनै क्यामेरा फेला परेन।',
        ),
      );
    }

    if (_errorMessage != null) {
      return _messageState(
        icon: Icons.error_outline_rounded,
        text: lang.t(
          'Could not access camera. Please allow camera permission in your browser and try again.',
          'क्यामेरा access गर्न सकिएन। कृपया browser मा क्यामेरा अनुमति दिनुहोस् र फेरि प्रयास गर्नुहोस्।',
        ),
      );
    }

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: controller.value.previewSize?.height ?? 1,
        height: controller.value.previewSize?.width ?? 1,
        child: CameraPreview(controller),
      ),
    );
  }

  Widget _messageState({required IconData icon, required String text}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white54, size: 56),
            const SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.black45,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}