//lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/food_stall.dart';
import '../model/food_item.dart';
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<FoodStall>> fetchFoodStalls() async {
    final snapshot = await _db.collection('food_stalls').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return FoodStall(
        id: doc.id, // Doc ID
        name: data['name'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        hygieneRating: double.tryParse(data['hygieneRating'].toString()) ?? 0.0,
        foodRating: double.tryParse(data['foodRating'].toString()) ?? 0.0,
      );
    }).toList();
  }

  Future<List<FoodItem>> fetchFoodItemsByStallId(String stallId) async {
  final snapshot = await _db
      .collection('food_items')
      .where('stallid', isEqualTo: stallId)
      .get();

  return snapshot.docs.map((doc) {
    final data = doc.data();
    return FoodItem(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: double.tryParse(data['price'].toString()) ?? 0.0,
      stallId: data['stallid'] ?? '',
    );
  }).toList();
}

}
