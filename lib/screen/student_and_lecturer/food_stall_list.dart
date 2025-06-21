// C:\MAE LAB\the_cafeteria_app\lib\screen\student_and_lecturer\food_stall_list.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_cafeteria_app/model/food_stall.dart';
import 'package:the_cafeteria_app/screen/student_and_lecturer/food_stall_menu.dart';

class FoodStallList extends StatefulWidget {
  const FoodStallList({super.key});

  @override
  State<FoodStallList> createState() => _FoodStallListState();
}

class _FoodStallListState extends State<FoodStallList> {
  late Future<List<FoodStall>> _foodStalls;

  @override
  void initState() {
    super.initState();
    _foodStalls = fetchFoodStalls();
  }

  Future<List<FoodStall>> fetchFoodStalls() async {
    final snapshot = await FirebaseFirestore.instance.collection('food_stalls').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      print('Fetched: ${doc.id} → $data'); // debug line

      return FoodStall(
        id: doc.id,
        name: data['name'] ?? 'Unnamed Stall',
        imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/150', // Default placeholder
        hygieneRating: (data['hygieneRating'] ?? 0).toDouble(),
        foodRating: (data['foodRating'] ?? 0).toDouble(),
      );
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Stalls'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, '/orderHistory');
            },
          ),
        ],
      ),

      body: FutureBuilder<List<FoodStall>>(
        future: _foodStalls,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final stalls = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
              children: stalls.map((stall) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FoodStallMenu(stall: stall),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              stall.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stall.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text("Food Rating: ⭐ ${stall.foodRating}"),
                              Text("Hygiene: 🧼 ${stall.hygieneRating}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
