import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/prediction_model.dart';

class ApiService {
  // Change this to your machine's IP when testing on a real phone
  // Use 10.0.2.2 for Android emulator, localhost for iOS simulator
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  /// Send image to Django and get prediction + treatment
  static Future<PredictionResult> predictDisease({
    required File imageFile,
    required String language,   // 'en' or 'np'
  }) async {
    final uri = Uri.parse('$baseUrl/predict/');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    request.fields['language'] = language;

    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 30),
      onTimeout: () => throw Exception('Request timed out. Check your connection.'),
    );

    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return PredictionResult.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 503) {
      throw Exception('ML models not loaded. Train the model first.');
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  /// Check if Django server and models are ready
  static Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/health/'))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['stage1_model'] == true && data['stage2_model'] == true;
      }
    } catch (_) {}
    return false;
  }
}