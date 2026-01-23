import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart' as model; 

class OrderService {
  final _db = FirebaseFirestore.instance;

  Stream<List<model.OrderModel>> getOrders() {
    return _db
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => model.OrderModel.fromFirestore(e)).toList());
  }

  Future<void> createOrder({
    required String userId,
    required int totalPrice,
  }) async {
    await _db.collection('orders').add({
      'userId': userId,
      'totalPrice': totalPrice,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
