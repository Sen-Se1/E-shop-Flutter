import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String uid;
  final String name;
  final String description;
  final String category;
  final double price;
  final String? imageUrl;
  bool isFavorite;

  Product({
    required this.uid,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.imageUrl,
    this.isFavorite = false,
  });

  Product copyWith({
    String? uid,
    String? name,
    String? description,
    String? category,
    double? price,
    String? imageUrl,
  }) {
    return Product(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'],
    );
  }
}
