// lib/screen/student_and_lecturer/order_confirmation_receipt.dart
import 'package:flutter/material.dart';
import 'package:the_cafeteria_app/model/cart_item.dart';

class OrderConfirmationReceiptScreen extends StatelessWidget {
  final List<CartItem> cartItems;
  final double total;

  const OrderConfirmationReceiptScreen({
    super.key,
    required this.cartItems,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ...cartItems.map((item) => ListTile(
                      title: Text(item.foodItem.name),
                      subtitle: Text(
                          '${item.quantity} x RM ${item.foodItem.price.toStringAsFixed(2)}'),
                      trailing: Text(
                          'RM ${(item.quantity * item.foodItem.price).toStringAsFixed(2)}'),
                    )),
                const Divider(),
                ListTile(
                  title: const Text('Total'),
                  trailing: Text('RM ${total.toStringAsFixed(2)}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
