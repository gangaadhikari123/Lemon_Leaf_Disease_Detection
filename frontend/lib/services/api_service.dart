import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../models/prediction_model.dart';

class ApiService {
  // Android emulator → 10.0.2.2
  // Linux/Chrome dev → 127.0.0.1 
  // Real phone → your computer IP e.g. 192.168.1.105
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  /// Mobile + Desktop — sends image as File
  static Future<PredictionResult> predictDisease({
    required File imageFile,
    required String language,
  }) async {
    final uri = Uri.parse('$baseUrl/predict/');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );
    request.fields['language'] = language;

    final streamed = await request.send().timeout(
      const Duration(seconds: 30),
      onTimeout: () => throw Exception('Request timed out. Check your connection.'),
    );
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      return PredictionResult.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 503) {
      throw Exception('ML models not loaded. Train the model first.');
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  /// Web/Chrome — sends image as bytes (no file path on web)
  static Future<PredictionResult> predictDiseaseFromBytes({
    required List<int> imageBytes,
    required String fileName,
    required String language,
  }) async {
    final uri = Uri.parse('$baseUrl/predict/');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(http.MultipartFile.fromBytes(
      'image',
      imageBytes,
      filename: fileName,
    ));
    request.fields['language'] = language;

    final streamed = await request.send().timeout(
      const Duration(seconds: 30),
      onTimeout: () => throw Exception('Request timed out.'),
    );
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      return PredictionResult.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  /// Health check
  static Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/health/'))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['server'] == 'ok';
      }
    } catch (_) {}
    return false;
  }
}