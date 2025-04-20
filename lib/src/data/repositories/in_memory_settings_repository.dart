// src/data/repositories/in_memory_settings_repository.dart
import 'dart:async';
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
    await Future.delayed(const Duration(milliseconds: 100)); // Simülasyon
    _lastProductId++;
    String newProductId = 'prod_${_lastProductId}'; // Basit ID üretimi
    _products.add({
      'id': newProductId,
      'name': name,
      'price': price,
      'categoryId': categoryId,
    });
    print(
      '[InMemorySettingsRepository] Ürün eklendi: ID: $newProductId, Ad: $name, Fiyat: $price, Kategori: $categoryId',
    );
  }

  @override
  Future<void> addStock(String productId, int quantity) async {
    await Future.delayed(const Duration(milliseconds: 100)); // Simülasyon
    _stock[productId] = (_stock[productId] ?? 0) + quantity;
    print(
      '[InMemorySettingsRepository] Stok güncellendi: Ürün ID: $productId, Yeni Miktar: ${_stock[productId]}',
    );
  }

  // Gerekirse diğer metodların implementasyonları...
}
