// C:\MAE LAB\the_cafeteria_app\lib\model\cart_item.dart
import 'food_item.dart';

class CartItem {
  final FoodItem foodItem;
  int quantity;

  CartItem({required this.foodItem, this.quantity = 1});
}
