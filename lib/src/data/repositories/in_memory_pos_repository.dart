import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/pos_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InMemoryPosRepository implements PosRepository {
  late List<Category> _categories;
  late List<Product> _allProducts;
  bool _isInitialized = false;

  // Private constructor
  InMemoryPosRepository._();

  // Factory constructor - asenkron initialization için
  static Future<InMemoryPosRepository> create() async {
    final repository = InMemoryPosRepository._();
    await repository._init();
    return repository;
  }

  /// Asenkron olarak veri çeken init fonksiyonu
  Future<void> _init() async {
    _categories = await fetchCategories();
    _allProducts = await fetchProducts();
    _isInitialized = true;
    print('Repository initialized with ${_allProducts.length} products');
  }

  // Her metotta initialization kontrolü
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'Repository has not been initialized. Use InMemoryPosRepository.create() instead of constructor.',
      );
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    _ensureInitialized();
    return List.unmodifiable(_categories);
  }

  @override
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    _ensureInitialized();
    return List.unmodifiable(
      _allProducts.where((p) => p.categoryId == categoryId).toList(),
    );
  }

  Future<List<Category>> fetchCategories() async {
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

  Future<List<Product>> fetchProducts() async {
    const String url =
        'http://34.40.120.88:8082/api/v1/branches/f84f20dc-0d14-400b-a948-0777a2aed3fb/products?limit=50&offset=0&sort_by=sort_order&sort_order=asc';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'X-API-Key': 'menu-service-staging-key-2024',
        },
      );

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final List<dynamic> productsJson = jsonBody['data']['products'];

        List<Product> res =
            productsJson.map((jsonItem) {
              final product = jsonItem['product'];
              final category = product['category'];

              print('categoryName1: ${category['id']}');

              return Product(
                id: jsonItem['id'] ?? '',
                name: product['product_name'] ?? '',
                price: double.tryParse(jsonItem['price'].toString()) ?? 0.0,
                categoryId: category['id'],
                icon: _mapCategoryToIcon(category['category_name']),
              );
            }).toList();

        return res;
      } else {
        throw Exception('Failed to load products (${response.statusCode})');
      }
    } catch (e) {
      print('fetchProducts error: $e');
      rethrow;
    }
  }

  IconData _mapCategoryToIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'coffee':
      case 'drink':
      case 'beverage':
      case 'kahveler':
        return Icons.local_cafe;
      case 'food':
      case 'food':
      case 'food':
        return Icons.restaurant;
      case 'dessert':
      case 'tatlılar':
      case 'Tatlılar':
        return Icons.cake;
      case 'sandviçler':
      case 'fast food':
      case 'fast food':
        return Icons.fastfood;
      default:
        return Icons.category;
    }
  }
}
