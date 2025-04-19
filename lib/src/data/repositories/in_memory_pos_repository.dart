// src/data/repositories/in_memory_pos_repository.dart
import 'package:flutter/material.dart'; // Renk ve ikonlar için
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/pos_repository.dart';

class InMemoryPosRepository implements PosRepository {
  late List<Category> _categories;
  late List<Product> _allProducts;

  InMemoryPosRepository() {
    _categories = _createMockCategories();
    _allProducts = _createMockProducts();
  }

  @override
  Future<List<Category>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return List.unmodifiable(_categories);
  }

  @override
  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_allProducts);
  }

  @override
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    await Future.delayed(const Duration(milliseconds: 70));
    return List.unmodifiable(
      _allProducts.where((p) => p.categoryId == categoryId).toList(),
    );
  }

  // --- Mock Data Oluşturma Metotları ---

  List<Category> _createMockCategories() {
    return [
      Category(
        id: 'beverage',
        name: 'İçecek',
        color: Colors.blue.shade700,
        icon: Icons.local_drink,
      ),
      Category(
        id: 'food',
        name: 'Yemek',
        color: Colors.orange.shade700,
        icon: Icons.restaurant,
      ), // Renkleri çeşitlendirelim
      Category(
        id: 'dessert',
        name: 'Tatlı',
        color: Colors.pink.shade400,
        icon: Icons.cake,
      ),
      Category(
        id: 'fast_food',
        name: 'Fast Food',
        color: Colors.red.shade600,
        icon: Icons.fastfood,
      ),
    ];
  }

  List<Product> _createMockProducts() {
    return [
      // İçecekler
      Product(
        id: 'prod_1',
        name: 'Su',
        price: 10.0,
        categoryId: 'beverage',
        icon: Icons.water_drop,
      ),
      Product(
        id: 'prod_2',
        name: 'Cola',
        price: 45.0,
        categoryId: 'beverage',
        icon: Icons.local_bar,
      ), // Farklı ikon
      Product(
        id: 'prod_3',
        name: 'Ayran',
        price: 25.0,
        categoryId: 'beverage',
        icon: Icons.local_cafe,
      ),
      Product(
        id: 'prod_4',
        name: 'Meyve Suyu',
        price: 35.0,
        categoryId: 'beverage',
        icon: Icons.wine_bar,
      ),
      Product(
        id: 'prod_5',
        name: 'Türk Kahvesi',
        price: 40.0,
        categoryId: 'beverage',
        icon: Icons.coffee,
      ),
      Product(
        id: 'prod_6',
        name: 'Çay',
        price: 15.0,
        categoryId: 'beverage',
        icon: Icons.emoji_food_beverage,
      ),
      // Yemekler
      Product(
        id: 'prod_7',
        name: 'Pizza',
        price: 185.0,
        categoryId: 'food',
        icon: Icons.local_pizza,
      ),
      Product(
        id: 'prod_8',
        name: 'Balık',
        price: 98.0,
        categoryId: 'food',
        icon: Icons.set_meal,
      ),
      Product(
        id: 'prod_9',
        name: 'Köfte',
        price: 120.0,
        categoryId: 'food',
        icon: Icons.kebab_dining,
      ), // Farklı ikon
      Product(
        id: 'prod_10',
        name: 'Tavuk Şiş',
        price: 105.0,
        categoryId: 'food',
        icon: Icons.outdoor_grill,
      ), // Farklı ikon
      Product(
        id: 'prod_11',
        name: 'Kebap',
        price: 150.0,
        categoryId: 'food',
        icon: Icons.restaurant_menu,
      ), // Farklı ikon
      Product(
        id: 'prod_12',
        name: 'Makarna',
        price: 80.0,
        categoryId: 'food',
        icon: Icons.dinner_dining,
      ),
      // Tatlılar
      Product(
        id: 'prod_13',
        name: 'Baklava',
        price: 120.0,
        categoryId: 'dessert',
        icon: Icons.cake_outlined,
      ), // Farklı ikon
      Product(
        id: 'prod_14',
        name: 'Sütlaç',
        price: 80.0,
        categoryId: 'dessert',
        icon: Icons.rice_bowl,
      ), // Farklı ikon
      Product(
        id: 'prod_15',
        name: 'Künefe',
        price: 110.0,
        categoryId: 'dessert',
        icon: Icons.bakery_dining,
      ),
      Product(
        id: 'prod_16',
        name: 'Dondurma',
        price: 60.0,
        categoryId: 'dessert',
        icon: Icons.icecream,
      ),
      // Fast Food
      Product(
        id: 'prod_17',
        name: 'Hamburger',
        price: 130.0,
        categoryId: 'fast_food',
        icon: Icons.lunch_dining,
      ),
      Product(
        id: 'prod_18',
        name: 'Tost',
        price: 70.0,
        categoryId: 'fast_food',
        icon: Icons.breakfast_dining,
      ),
      Product(
        id: 'prod_19',
        name: 'Patates Kızartması',
        price: 50.0,
        categoryId: 'fast_food',
        icon: Icons.fastfood_outlined,
      ), // Farklı ikon
    ];
  }
}
