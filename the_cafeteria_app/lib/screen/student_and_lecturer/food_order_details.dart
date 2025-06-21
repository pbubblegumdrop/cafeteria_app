// lib/screen/student_and_lecturer/food_order_details.dart
import 'package:flutter/material.dart';
import 'package:the_cafeteria_app/model/food_item.dart';
import 'package:the_cafeteria_app/model/cart_item.dart';
import 'package:the_cafeteria_app/data/cart.dart';

class FoodOrderDetails extends StatefulWidget {
  final FoodItem item;

  const FoodOrderDetails({super.key, required this.item});

  @override
  State<FoodOrderDetails> createState() => _FoodOrderDetailsState();
}

class _FoodOrderDetailsState extends State<FoodOrderDetails> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.item.price * quantity;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              widget.item.imageUrl,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 100),
            ),
            const SizedBox(height: 16),
            Text(
              widget.item.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.item.description),
            const SizedBox(height: 16),
            Text(
              'RM ${widget.item.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),

            // Quantity Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: quantity > 1
                      ? () => setState(() => quantity--)
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                Text(quantity.toString(), style: const TextStyle(fontSize: 18)),
                IconButton(
                  onPressed: () => setState(() => quantity++),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Total Price
            Text(
              'Total: RM ${totalPrice.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const Spacer(),

            // Add to Cart Button
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Add to Cart'),
                      content: Text(
                        'Add to cart:\n\n'
                        '${widget.item.name}\nQuantity: $quantity\nTotal: RM ${totalPrice.toStringAsFixed(2)}',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final existingItem = cart.firstWhere(
                              (c) => c.foodItem.id == widget.item.id,
                              orElse: () => CartItem(
                                foodItem: widget.item,
                                quantity: 0,
                              ),
                            );

                            if (existingItem.quantity == 0) {
                              cart.add(CartItem(
                                foodItem: widget.item,
                                quantity: quantity,
                              ));
                            } else {
                              existingItem.quantity += quantity;
                            }

                            Navigator.of(context).pop(); // Close dialog
                            Navigator.of(context).pop(); // Go back
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),

      // Floating Cart Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.pushNamed(context, '/cart');
        },
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
