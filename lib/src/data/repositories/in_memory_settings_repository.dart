// src/data/repositories/in_memory_settings_repository.dart
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:gotpos/src/domain/entities/category.dart';

import 'dart:convert';
import '../../domain/repositories/settings_repository.dart';

class InMemorySettingsRepository implements SettingsRepository {
  // Verileri saklamak için listeler (Mock data)
  final List<Map<String, dynamic>> _tables = [];
  final List<Map<String, dynamic>> _products = [];
  final Map<String, int> _stock = {};
  int _lastTableId = 0; // Otomatik ID için
  int _lastProductId = 0; // Otomatik ID için

  @override
  Future<void> addTable(String name, int capacity) async {
    await Future.delayed(const Duration(milliseconds: 100)); // Simülasyon
    _lastTableId++;
    _tables.add({
      'id': _lastTableId,
      'name': name,
      'capacity': capacity,
      'status': 'empty',
    });
    print(
      '[InMemorySettingsRepository] Masa eklendi: ID: $_lastTableId, Ad: $name, Kapasite: $capacity',
    );
  }

  @override
  Future<void> addProduct(String name, double price, String categoryId) async {
    final response = await http.post(
      Uri.parse('http://34.40.120.88:8082/api/v1/products'),
      headers: {
        'accept': 'application/json',
        'X-API-Key': 'menu-service-staging-key-2024',
      },
      body: json.encode({
        'product_name': name,
        'base_price': price,
        'category_id': categoryId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonBody = json.decode(response.body);
      final String productId = jsonBody['data']['id'];

      addProductToBranch(productId);
    } else {
      throw Exception('Failed to add product');
    }
  }

  @override
  Future<void> addStock(String productId, int quantity) async {
    await Future.delayed(const Duration(milliseconds: 100)); // Simülasyon
    _stock[productId] = (_stock[productId] ?? 0) + quantity;
    print(
      '[InMemorySettingsRepository] Stok güncellendi: Ürün ID: $productId, Yeni Miktar: ${_stock[productId]}',
    );
  }

  @override
  Future<List<Category>> getCategories() async {
    final response = await http.get(
      Uri.parse('http://34.40.120.88:8082/api/v1/categories'),
      headers: {
        'accept': 'application/json',
        'X-API-Key': 'menu-service-staging-key-2024',
      },
    );

    if (response.statusCode == 200) {
      print("categories fetched successfully");

      final jsonBody = json.decode(response.body);
      final List<dynamic> categoryJson = jsonBody['data']['categories'];

      return categoryJson.map((category) {
        return Category(id: category['id'], name: category['category_name']);
      }).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  void addProductToBranch(String productId) async {
    final response = await http.post(
      Uri.parse(
        'http://34.40.120.88:8082/api/v1/branches/f84f20dc-0d14-400b-a948-0777a2aed3fb/products',
      ),
      headers: {
        'accept': 'application/json',
        'X-API-Key': 'menu-service-staging-key-2024',
      },
      body: json.encode({
        'discount': 10,
        'first_price': 120,
        'product_id': productId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Ürün şubeye eklendi.');
    } else {
      throw Exception('Failed to add product');
    }
  }
}
