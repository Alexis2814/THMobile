// lib/models/order_model.dart
class Order {
  final String customerName;
  final String email;
  final String phone;
  final String province;
  final String district;
  final String ward;
  final String addressDetails;
  final String paymentMethod;
  final String? notes;
  final DateTime orderDate;
  final String status;

  Order({
    required this.customerName,
    required this.email,
    required this.phone,
    required this.province,
    required this.district,
    required this.ward,
    required this.addressDetails,
    required this.paymentMethod,
    this.notes,
    required this.orderDate,
    this.status = 'Đang xử lý',
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      customerName: json['customerName'],
      email: json['email'],
      phone: json['phone'],
      province: json['province'],
      district: json['district'],
      ward: json['ward'],
      addressDetails: json['addressDetails'],
      paymentMethod: json['paymentMethod'],
      notes: json['notes'],
      orderDate: DateTime.parse(json['orderDate']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'email': email,
      'phone': phone,
      'province': province,
      'district': district,
      'ward': ward,
      'addressDetails': addressDetails,
      'paymentMethod': paymentMethod,
      'notes': notes,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
    };
  }
}