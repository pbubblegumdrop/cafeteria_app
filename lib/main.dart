//C:\MAE LAB\the_cafeteria_app\lib\main.dart
import 'package:flutter/material.dart';
import 'package:the_cafeteria_app/screen/login/role_selection.dart';
import 'package:the_cafeteria_app/screen/student_and_lecturer/food_stall_list.dart';
import 'package:the_cafeteria_app/screen/student_and_lecturer/cart_and_payment.dart';
import 'package:the_cafeteria_app/screen/student_and_lecturer/order_confirmation_receipt.dart';
import 'package:the_cafeteria_app/screen/cafeteria_staff/cafeteria_staff_orders.dart';
import 'package:the_cafeteria_app/screen/student_and_lecturer/order_history.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => RoleSelection(),
        '/foodStallList': (context) => FoodStallList(),
        '/cart': (context) => const CartAndPaymentScreen(),
        '/orderHistory': (context) => const OrderHistoryScreen(),

      },
      onGenerateRoute: (settings) {
        if (settings.name == '/staff-orders') {
          final stallId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => CafeteriaStaffOrdersScreen(stallId: stallId),
          );
        }

        if (settings.name == '/orderConfirmation') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => OrderConfirmationReceiptScreen(
              cartItems: args['cartItems'],
              total: args['total'],
            ),
          );
        }

        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(child: Text('Page not found: ${settings.name}')),
          ),
        );
      },
    );


  }
}
