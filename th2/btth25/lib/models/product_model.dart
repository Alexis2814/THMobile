// lib/models/product_model.dart

class Product {
  final String name;
  final double price;
  final String category;
  final DateTime createdAt;

  Product({
    required this.name,
    required this.price,
    required this.category,
    required this.createdAt,
  });
}