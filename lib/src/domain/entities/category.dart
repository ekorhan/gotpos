// src/domain/entities/category.dart
import 'package:flutter/material.dart'; // Color ve IconData için

class Category {
  final String id;
  final String name;
  final Color color;
  final IconData icon;

  Category({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });
}
