// src/domain/entities/product.dart
import 'package:flutter/material.dart'; // IconData için gerekli

class Product {
  final String id; // Ürünü unique olarak tanımlamak için ID ekleyelim
  final String name;
  final double price;
  final String categoryId;
  final IconData icon;

  Product({
    required this.id, // ID ekledik
    required this.name,
    required this.price,
    required this.categoryId,
    this.icon = Icons.fastfood, // Varsayılan ikon
  });
}
