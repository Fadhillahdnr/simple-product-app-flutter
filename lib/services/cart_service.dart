import '../models/product_model.dart';

class CartService {
  // ================= SINGLETON =================
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  // ================= DATA KERANJANG =================
  final List<Product> _cartItems = [];

  // ================= GETTER =================
  List<Product> get cartItems => _cartItems;

  int get totalPrice {
    int total = 0;
    for (var product in _cartItems) {
      total += product.price;
    }
    return total;
  }

  // ================= METHOD =================
  void addToCart(Product product) {
    _cartItems.add(product);
  }

  void removeFromCart(Product product) {
    _cartItems.remove(product);
  }

  void clearCart() {
    _cartItems.clear();
  }
}
