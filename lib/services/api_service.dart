import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ApiService {
  ApiService._();

  static const String _baseUrl = 'https://fakestoreapi.com/products';
  static const Duration _timeout = Duration(seconds: 15);

  static Future<List<Product>> fetchProducts() async {
    final response = await http
        .get(Uri.parse(_baseUrl))
        .timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception('Không thể tải danh sách sản phẩm (HTTP ${response.statusCode}).');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const FormatException('Dữ liệu danh sách không đúng định dạng.');
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(Product.fromJson)
        .toList(growable: false);
  }

  static Future<Product> fetchProductById(int id) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/$id'))
        .timeout(_timeout);

    if (response.statusCode == 404) {
      throw Exception('Không tìm thấy sản phẩm #$id (HTTP 404).');
    }
    if (response.statusCode != 200) {
      throw Exception('Không thể tải chi tiết sản phẩm (HTTP ${response.statusCode}).');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic> || decoded.isEmpty) {
      throw Exception('Không tìm thấy dữ liệu sản phẩm #$id.');
    }

    return Product.fromJson(decoded);
  }
}
