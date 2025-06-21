// lib/screen/student_and_lecturer/order_history.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email;

    if (userEmail == null) {
      return const Scaffold(
        body: Center(child: Text('Not logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('receipts')
            .where('userEmail', isEqualTo: userEmail)
            .orderBy('timestamp', descending: true) 
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
            return const Center(child: Text('No order history found.'));
          }

          return ListView.builder(
            itemCount: receipts.length,
            itemBuilder: (context, index) {
              final data = receipts[index].data() as Map<String, dynamic>;
              final items = data['items'] as List<dynamic>;
              final total = data['total'];
              final status = data['status'] ?? 'Unknown';

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text('Receipt ID: ${data['id'] ?? 'N/A'}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var item in items)
                        Text(
                          '${item['quantity']}x ${item['name']} - RM ${item['price']}',
                        ),
                      const SizedBox(height: 4),
                      Text('Total: RM ${total.toString()}'),
                      Text('Status: $status'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
