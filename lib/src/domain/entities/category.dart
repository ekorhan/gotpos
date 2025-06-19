// src/domain/entities/category.dart
import 'package:flutter/material.dart'; // Color ve IconData için

class Category {
  final String id;
  final String name;
  final Color color = Colors.purple;
  final IconData icon = Icons.category;

  Category({required this.id, required this.name});
}
