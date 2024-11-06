// lib/services/database_service.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/foundation.dart'; // Import to use kIsWeb
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Check if the platform is web
    if (kIsWeb) {
      // If on the web, throw an error or handle the logic differently
      throw UnsupportedError('Web platform is not supported for database operations');
    }

    // Initialize FFI database factory if on desktop
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    String path = join(await getDatabasesPath(), 'laundry_pos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customerName TEXT,
        serviceType TEXT,
        details TEXT,
        cost REAL,
        dateTime TEXT
      )
    ''');
  }

  Future<void> insertTransaction(Map<String, dynamic> transaction) async {
    if (kIsWeb) {
      // Handle insertion logic differently for web, e.g., local storage or throw an error
      throw UnsupportedError('Web platform is not supported for database operations');
    }
    final db = await database;
    await db.insert('transactions', transaction);
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    if (kIsWeb) {
      // Handle retrieval logic differently for web, e.g., return an empty list or throw an error
      throw UnsupportedError('Web platform is not supported for database operations');
    }
    final db = await database;
    return await db.query('transactions');
  }

  Future<void> clearTransactions() async {
    if (kIsWeb) {
      // Handle clearing logic differently for web
      throw UnsupportedError('Web platform is not supported for database operations');
    }
    final db = await database;
    await db.delete('transactions');
  }
}
