// lib/providers/transaction_provider.dart

import 'package:flutter/material.dart';
import '../services/database_service.dart';

class TransactionProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();

  Future<void> addTransaction(String customerName, String serviceType, String details, double cost) async {
    final transaction = {
      'customerName': customerName,
      'serviceType': serviceType,
      'details': details,
      'cost': cost,
      'dateTime': DateTime.now().toIso8601String(),
    };
    await _dbService.insertTransaction(transaction);
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final List<Map<String, dynamic>> transactions = await _dbService.getTransactions();
    return transactions;
  }

  Future<void> clearTransactions() async {
    await _dbService.clearTransactions();
    notifyListeners();
  }
}
