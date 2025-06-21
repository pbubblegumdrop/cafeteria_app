// C:\MAE LAB\the_cafeteria_app\lib\model\receipt.dart
import 'package:the_cafeteria_app/model/cart_item.dart';


class Receipt {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime timestamp;
  bool isCompleted; // NEW

  Receipt({
    required this.id,
    required this.items,
    required this.total,
    required this.timestamp,
    this.isCompleted = false, // default to not completed
  });
}

