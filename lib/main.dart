// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:laundry_pos/providers/transaction_provider.dart';
import 'package:laundry_pos/screens/custom_transaction_screen.dart';
import 'package:laundry_pos/screens/weight_based_transaction_screen.dart';
import 'package:laundry_pos/screens/transaction_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TransactionProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laundromat POS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laundromat POS'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomTransactionScreen()),
                );
              },
              child: Text('Custom Transaction'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeightBasedTransactionScreen()),
                );
              },
              child: Text('Weight-Based Transaction'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TransactionListScreen()),
                );
              },
              child: Text('View Transactions'),
            ),
          ],
        ),
      ),
    );
  }
}
