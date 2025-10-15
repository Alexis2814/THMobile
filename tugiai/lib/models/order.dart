// lib/models/order.dart
import 'dart:convert';

// Tên các cột trong bảng DB
class OrderFields {
  static final List<String> values = [
    id, orderId, customerName, phoneNumber, address, deliveryDate, paymentMethod, products, notes
  ];
  static const String id = 'id';
  static const String orderId = 'orderId';
  static const String customerName = 'customerName';
  static const String phoneNumber = 'phoneNumber';
  static const String address = 'address';
  static const String deliveryDate = 'deliveryDate';
  static const String paymentMethod = 'paymentMethod';
  static const String products = 'products';
  static const String notes = 'notes';
}

class Order {
  final int? id;
  final String orderId;
  final String customerName;
  final String phoneNumber;
  final String address;
  final DateTime deliveryDate;
  final String paymentMethod;
  final List<String> products;
  final String? notes;

  const Order({
    this.id,
    required this.orderId,
    required this.customerName,
    required this.phoneNumber,
    required this.address,
    required this.deliveryDate,
    required this.paymentMethod,
    required this.products,
    this.notes,
  });

  Order copyWith({
    int? id,
    String? orderId,
    String? customerName,
    String? phoneNumber,
    String? address,
    DateTime? deliveryDate,
    String? paymentMethod,
    List<String>? products,
    String? notes,
  }) =>
      Order(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        customerName: customerName ?? this.customerName,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        address: address ?? this.address,
        deliveryDate: deliveryDate ?? this.deliveryDate,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        products: products ?? this.products,
        notes: notes ?? this.notes,
      );

  // Chuyển đổi từ Map (dữ liệu đọc từ DB) sang object Order
  static Order fromMap(Map<String, Object?> map) => Order(
    id: map[OrderFields.id] as int?,
    orderId: map[OrderFields.orderId] as String,
    customerName: map[OrderFields.customerName] as String,
    phoneNumber: map[OrderFields.phoneNumber] as String,
    address: map[OrderFields.address] as String,
    deliveryDate: DateTime.parse(map[OrderFields.deliveryDate] as String),
    paymentMethod: map[OrderFields.paymentMethod] as String,
    products: (jsonDecode(map[OrderFields.products] as String) as List<dynamic>).cast<String>(),
    notes: map[OrderFields.notes] as String?,
  );

  // Chuyển đổi từ object Order sang Map (để ghi vào DB)
  Map<String, Object?> toMap() => {
    OrderFields.id: id,
    OrderFields.orderId: orderId,
    OrderFields.customerName: customerName,
    OrderFields.phoneNumber: phoneNumber,
    OrderFields.address: address,
    OrderFields.deliveryDate: deliveryDate.toIso8601String(),
    OrderFields.paymentMethod: paymentMethod,
    OrderFields.products: jsonEncode(products),
    OrderFields.notes: notes,
  };
}