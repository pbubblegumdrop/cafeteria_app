// lib/screen/student_and_lecturer/food_stall_menu.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_cafeteria_app/model/food_stall.dart';
import 'package:the_cafeteria_app/model/food_item.dart';
import 'package:the_cafeteria_app/screen/student_and_lecturer/food_order_details.dart';

class FoodStallMenu extends StatefulWidget {
  final FoodStall stall;

  const FoodStallMenu({super.key, required this.stall});

  @override
  State<FoodStallMenu> createState() => _FoodStallMenuState();
}

class _FoodStallMenuState extends State<FoodStallMenu> {
  late Future<List<FoodItem>> _menuItems;

  @override
  void initState() {
    super.initState();
    _menuItems = fetchFoodItems(widget.stall.id);
  }

  Future<List<FoodItem>> fetchFoodItems(String stallId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('food_stalls')
        .doc(stallId)
        .collection('food_item')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return FoodItem(
        id: doc.id,
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        price: double.tryParse(data['price'].toString()) ?? 0.0,
        stallId: stallId,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stall.name),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<FoodItem>>(
        future: _menuItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final menuItems = snapshot.data!;
          if (menuItems.isEmpty) {
            return Center(child: Text('No food items available.'));
          }

          return ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.description),
                  trailing: Text('RM ${item.price.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FoodOrderDetails(item: item),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
