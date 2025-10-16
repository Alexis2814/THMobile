// lib/helpers/database_helper.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/order.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('orders.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textTypeNull = 'TEXT';

    await db.execute('''
      CREATE TABLE orders ( 
        id $idType, 
        orderId $textType,
        customerName $textType,
        phoneNumber $textType,
        address $textType,
        deliveryDate $textType,
        paymentMethod $textType,
        products $textType,
        notes $textTypeNull
      )
    ''');
  }

  Future<Order> create(Order order) async {
    final db = await instance.database;
    final id = await db.insert('orders', order.toMap());
    return order.copyWith(id: id);
  }

  Future<Order> readOrder(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'orders',
      columns: OrderFields.values,
      where: '${OrderFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Order.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  // ==========================================================
  // HÀM QUAN TRỌNG ĐÃ ĐƯỢC CẬP NHẬT ĐỂ LỌC
  // ==========================================================
  Future<List<Order>> readAllOrders({
    String query = '',
    DateTimeRange? dateRange,
    String? paymentMethod,
  }) async {
    final db = await instance.database;

    // Xây dựng câu lệnh WHERE và các tham số một cách linh hoạt
    String? whereClause;
    List<Object?> whereArgs = [];

    // Thêm điều kiện tìm kiếm tên
    if (query.isNotEmpty) {
      whereClause = '${OrderFields.customerName} LIKE ?';
      whereArgs.add('%$query%');
    }

    // Thêm điều kiện lọc theo ngày
    if (dateRange != null) {
      final startDate = dateRange.start.toIso8601String().substring(0, 10);
      final endDate = dateRange.end.toIso8601String().substring(0, 10);
      final dateCondition = "SUBSTR(${OrderFields.deliveryDate}, 1, 10) BETWEEN ? AND ?";

      whereClause = whereClause == null ? dateCondition : '$whereClause AND $dateCondition';
      whereArgs.addAll([startDate, endDate]);
    }

    // Thêm điều kiện lọc theo phương thức thanh toán
    if (paymentMethod != null) {
      final paymentCondition = '${OrderFields.paymentMethod} = ?';
      whereClause = whereClause == null ? paymentCondition : '$whereClause AND $paymentCondition';
      whereArgs.add(paymentMethod);
    }

    final result = await db.query(
      'orders',
      where: whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: '${OrderFields.deliveryDate} DESC', // Luôn sắp xếp theo ngày mới nhất
    );

    return result.map((json) => Order.fromMap(json)).toList();
  }
  // ==========================================================

  Future<int> update(Order order) async {
    final db = await instance.database;
    return db.update(
      'orders',
      order.toMap(),
      where: '${OrderFields.id} = ?',
      whereArgs: [order.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'orders',
      where: '${OrderFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}