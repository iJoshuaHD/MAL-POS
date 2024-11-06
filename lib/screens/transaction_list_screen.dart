// lib/screens/transaction_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class TransactionListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction List"),
      ),
      body: FutureBuilder(
        future: Provider.of<TransactionProvider>(context, listen: false).getTransactions(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Display the error details if an error occurred
            return Center(child: Text('Error fetching transactions: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No transactions available'));
          } else {
            // If data exists, show it in a DataTable
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Customer Name')),
                  DataColumn(label: Text('Service Type')),
                  DataColumn(label: Text('Details')),
                  DataColumn(label: Text('Cost')),
                  DataColumn(label: Text('Date/Time')),
                ],
                rows: snapshot.data!.map((transaction) {
                  return DataRow(
                    cells: [
                      DataCell(Text(transaction['customerName'] ?? '')),
                      DataCell(Text(transaction['serviceType'] ?? '')),
                      DataCell(Text(transaction['details'] ?? '')),
                      DataCell(Text(transaction['cost']?.toString() ?? '')),
                      DataCell(Text(transaction['dateTime'] ?? '')),
                    ],
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
