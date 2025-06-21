// lib/screen/student_and_lecturer/cart_and_payment.dart
import 'package:flutter/material.dart';
import 'package:the_cafeteria_app/data/cart.dart';
import 'package:the_cafeteria_app/model/cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartAndPaymentScreen extends StatefulWidget {
  const CartAndPaymentScreen({super.key});

  @override
  State<CartAndPaymentScreen> createState() => _CartAndPaymentScreenState();
}

class _CartAndPaymentScreenState extends State<CartAndPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    final totalPrice = cart.fold<double>(
      0,
      (sum, item) => sum + (item.foodItem.price * item.quantity),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.green,
      ),
      body: cart.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final cartItem = cart[index];
                final itemTotal =
                    cartItem.foodItem.price * cartItem.quantity;

                return ListTile(
                  leading: Image.network(
                    cartItem.foodItem.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  ),
                  title: Text(cartItem.foodItem.name),
                  subtitle: Text(
                    '${cartItem.quantity} x RM ${cartItem.foodItem.price.toStringAsFixed(2)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('RM ${itemTotal.toStringAsFixed(2)}'),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            cart.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  final copiedCart = cart
                    .map((item) => CartItem(
                          foodItem: item.foodItem,
                          quantity: item.quantity,
                        ))
                    .toList();

                  final total = totalPrice;
                  final stallId = cart.first.foodItem.stallId;

                  await _submitOrder(
                    stallId: stallId,
                    items: copiedCart,
                    total: total,
                  );

                  setState(() {
                    cart.clear();
                  });

                  Navigator.pushNamed(
                    context,
                    '/orderConfirmation',
                    arguments: {
                      'cartItems': copiedCart,
                      'total': total,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Pay RM ${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            )
          : null,
    );
  }

  Future<void> _submitOrder({
    required String stallId,
    required List<CartItem> items,
    required double total,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    final receiptId = DateTime.now().millisecondsSinceEpoch.toString();

    final orderItems = items.map((item) {
      return {
        'name': item.foodItem.name,
        'price': item.foodItem.price,
        'quantity': item.quantity,
      };
    }).toList();

    await FirebaseFirestore.instance.collection('receipts').add({
      'id': receiptId,
      'userEmail': user?.email,
      'stallId': stallId,
      'items': orderItems,
      'total': total,
      'timestamp': Timestamp.now(),
      'status': 'Pending',
    });
  }
}
