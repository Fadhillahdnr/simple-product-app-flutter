import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final int totalPrice;
  final String status;
  final Timestamp createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return OrderModel(
      id: doc.id,
      userId: data['userId'],
      totalPrice: data['totalPrice'],
      status: data['status'],
      createdAt: data['createdAt'],
    );
  }
}
