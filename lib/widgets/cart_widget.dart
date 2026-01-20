import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:intl/intl.dart';
import '../utils/currency_formatter.dart';

class CartWidget extends StatelessWidget {
  final List<Product> cartItems;

  const CartWidget({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double total = cartItems.fold(0, (sum, item) => sum + item.price);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...cartItems.map((item) => ListTile(
                title: Text(item.name),
                trailing: Text(
                            CurrencyFormatter.formatRupiah(item.price),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
              )),
          Divider(),
          Text(
            "Total: ${NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(total)}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
