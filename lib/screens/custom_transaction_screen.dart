// lib/screens/custom_transaction_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:laundry_pos/providers/transaction_provider.dart';

class CustomTransactionScreen extends StatefulWidget {
  @override
  _CustomTransactionScreenState createState() => _CustomTransactionScreenState();
}

class _CustomTransactionScreenState extends State<CustomTransactionScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _serviceTypeController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  void _submit() {
    String customerName = _nameController.text;
    String serviceType = _serviceTypeController.text;
    double cost = double.tryParse(_costController.text) ?? 0.0;

    if (customerName.isEmpty || serviceType.isEmpty || cost == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields correctly')),
      );
      return;
    }

    Provider.of<TransactionProvider>(context, listen: false)
        .addTransaction(customerName, 'Custom', serviceType, cost);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transaction added')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Customer Name'),
            ),
            TextField(
              controller: _serviceTypeController,
              decoration: InputDecoration(labelText: 'Service Type'),
            ),
            TextField(
              controller: _costController,
              decoration: InputDecoration(labelText: 'Cost (₱)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Proceed Transaction'),
            ),
            ElevatedButton(
              onPressed: () {
                _nameController.clear();
                _serviceTypeController.clear();
                _costController.clear();
              },
              child: Text('Cancel Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
