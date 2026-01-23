import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class OrderService {
  final _db = FirebaseFirestore.instance;

  // ================= CREATE ORDER =================
  Future<void> createOrder({
    required String userId,
    required String name,
    required String phone,
    required String address,
    required String paymentMethod,
    required List<Product> items,
    required int totalPrice,
  }) async {
    await _db.collection('orders').add({
      'userId': userId,
      'name': name,
      'phone': phone,
      'address': address,
      'paymentMethod': paymentMethod,
      'items': items
          .map((p) => {
                'id': p.id,
                'name': p.name,
                'price': p.price,
                'qty': p.quantity,
              })
          .toList(),
      'totalPrice': totalPrice,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ================= GET ALL ORDERS (ADMIN) =================
  Stream<QuerySnapshot> getOrders() {
    return _db
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ================= UPDATE STATUS =================
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _db.collection('orders').doc(orderId).update({
      'status': status,
    });
  }
}
