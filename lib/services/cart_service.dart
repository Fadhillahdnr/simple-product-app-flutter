import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  int get totalPrice {
    int total = 0;
    for (var item in _cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void addItem(Product product) {
    final index = _cartItems.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(product);
    }

    notifyListeners();
  }

  void increaseQty(Product product) {
    product.quantity++;
    notifyListeners();
  }

  void decreaseQty(Product product) {
    if (product.quantity > 1) {
      product.quantity--;
    } else {
      _cartItems.remove(product);
    }
    notifyListeners();
  }

  void removeItem(Product product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
