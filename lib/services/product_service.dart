import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'products';

  Stream<List<Product>> getProducts() {
    return _db.collection(_collection).snapshots().map(
      (snapshot) {
        return snapshot.docs
            .map((doc) => Product.fromFirestore(doc))
            .toList();
      },
    );
  }

  Future<void> addProduct(Product product) async {
    await _db.collection(_collection).add(product.toFirestore());
  }
}
