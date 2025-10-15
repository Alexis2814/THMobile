// lib/helpers/database_helper.dart
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/order.dart';

class DatabaseHelper {
  // Đảm bảo chỉ có một instance của DatabaseHelper (Singleton pattern)
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

  // Thêm một đơn hàng mới
  Future<Order> create(Order order) async {
    final db = await instance.database;
    final id = await db.insert('orders', order.toMap());
    return order.copyWith(id: id);
  }

  // Đọc một đơn hàng theo ID
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

  // Đọc tất cả đơn hàng (có thể tìm kiếm)
  Future<List<Order>> readAllOrders({String query = ''}) async {
    final db = await instance.database;

    final result = (query.isEmpty)
        ? await db.query('orders', orderBy: '${OrderFields.deliveryDate} DESC')
        : await db.query('orders',
        where: '${OrderFields.customerName} LIKE ?',
        whereArgs: ['%$query%'],
        orderBy: '${OrderFields.deliveryDate} DESC');

    return result.map((json) => Order.fromMap(json)).toList();
  }

  // Cập nhật một đơn hàng
  Future<int> update(Order order) async {
    final db = await instance.database;
    return db.update(
      'orders',
      order.toMap(),
      where: '${OrderFields.id} = ?',
      whereArgs: [order.id],
    );
  }

  // Xóa một đơn hàng
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