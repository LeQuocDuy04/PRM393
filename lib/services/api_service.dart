import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/exceptions.dart';
import '../models/profile_model.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  // JSONPlaceholder is a demo API; PUT responses do not persist changes.
  static final Uri _profileUri =
      Uri.parse('https://jsonplaceholder.typicode.com/users/1');

  Future<Profile> fetchProfile() async {
    try {
      final response = await _client
          .get(_profileUri)
          .timeout(const Duration(seconds: 10));

      // ignore: avoid_print
      print('GET $_profileUri -> ${response.statusCode}');
      // ignore: avoid_print
      print('Body: ${response.body}');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          'Không tải được hồ sơ.',
          statusCode: response.statusCode,
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const ApiException('Dữ liệu hồ sơ từ API không hợp lệ.');
      }

      return Profile.fromJson(decoded);
    } on ApiException {
      rethrow;
    } catch (error) {
      throw ApiException('Lỗi mạng khi tải hồ sơ: $error');
    }
  }

  Future<void> updateProfile(Profile profile) async {
    try {
      final response = await _client
          .put(
            _profileUri,
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode(profile.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      // ignore: avoid_print
      print('PUT $_profileUri -> ${response.statusCode}');
      // ignore: avoid_print
      print('Body: ${response.body}');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          'Cập nhật hồ sơ thất bại.',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (error) {
      throw ApiException('Lỗi mạng khi cập nhật hồ sơ: $error');
    }
  }

  void dispose() => _client.close();
}
