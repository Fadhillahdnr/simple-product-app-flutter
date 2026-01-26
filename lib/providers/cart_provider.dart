import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  /// TOTAL ITEM (UNTUK BADGE CART)
  int get totalItems =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  /// TOTAL PRICE (PAKAI QUANTITY)
  double get totalPrice => _items.fold(
        0,
        (sum, item) => sum + (item.price * item.quantity),
      );

  CartProvider() {
    _loadCart();
  }

  /// ADD / INCREASE PRODUCT
  void addToCart(Product product) {
    final index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(product);
    }

    _saveCart();
    notifyListeners();
  }

  /// INCREASE QTY
  void increaseQty(Product product) {
    product.quantity++;
    _saveCart();
    notifyListeners();
  }

  /// DECREASE QTY
  void decreaseQty(Product product) {
    if (product.quantity > 1) {
      product.quantity--;
    } else {
      _items.remove(product);
    }

    _saveCart();
    notifyListeners();
  }

  /// REMOVE ITEM
  void removeFromCart(Product product) {
    _items.remove(product);
    _saveCart();
    notifyListeners();
  }

  /// CLEAR CART
  void clearCart() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }

  // ================= PERSIST CART =================

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'cart',
      jsonEncode(
        _items
            .map(
              (e) => {
                'id': e.id,
                'name': e.name,
                'price': e.price,
                'imageUrl': e.imageUrl,
                'description': e.description,
                'qty': e.quantity,
              },
            )
            .toList(),
      ),
    );
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('cart');
    if (data == null) return;

    final decoded = jsonDecode(data) as List;
    _items.addAll(
      decoded.map(
        (e) => Product(
          id: e['id'],
          name: e['name'],
          price: (e['price'] as num).toDouble(),
          imageUrl: e['imageUrl'],
          description: e['description'] ?? '',
          quantity: e['qty'],
        ),
      ),
    );

    notifyListeners();
  }
}
