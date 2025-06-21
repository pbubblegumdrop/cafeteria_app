// lib/screen/cafeteria_staff/cafeteria_staff_orders.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CafeteriaStaffOrdersScreen extends StatelessWidget {
  final String stallId;

  const CafeteriaStaffOrdersScreen({super.key, required this.stallId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Incoming Orders')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('receipts')
            .where('stallId', isEqualTo: stallId)
            .orderBy('timestamp', descending: true) // Ensures sorting
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final receipts = snapshot.data?.docs ?? [];

          if (receipts.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          return ListView.builder(
            itemCount: receipts.length,
            itemBuilder: (context, index) {
              final data = receipts[index].data() as Map<String, dynamic>;
              final items = data['items'] as List<dynamic>;
              final status = data['status'] ?? 'Unknown';

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text('Receipt ID: ${data['id'] ?? 'N/A'}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var item in items)
                        Text('${item['quantity']}x ${item['name']}'),
                      Text('Status: $status'),
                    ],
                  ),
                  trailing: status == 'Pending'
                      ? ElevatedButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('receipts')
                                .doc(receipts[index].id)
                                .update({'status': 'Completed'});
                          },
                          child: const Text('Mark Completed'),
                        )
                      : const Icon(Icons.check, color: Colors.green),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
