import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    this.quantity = 1,
  });

  // ================= FROM FIRESTORE =================
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    return Product(
      id: doc.id,
      name: data?['name'] ?? '',
      price: (data?['price'] as num?)?.toDouble() ?? 0.0,
      description: data?['description'] ?? '',
      imageUrl: data?['imageUrl'] ?? '',
    );
  }

  // ================= TO FIRESTORE =================
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
