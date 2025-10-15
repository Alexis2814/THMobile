// lib/screens/order_list_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';
import 'checkout_screen.dart';
import 'order_details_screen.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  List<Order> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final orderKeys = prefs.getStringList('order_keys') ?? [];

    final List<Order> loadedOrders = [];
    for (String key in orderKeys) {
      final orderJson = prefs.getString(key);
      if (orderJson != null) {
        loadedOrders.add(Order.fromJson(jsonDecode(orderJson)));
      }
    }

    if (mounted) {
      setState(() {
        _orders = loadedOrders.reversed.toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách đơn hàng'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
          ? const Center(
        child: Text(
          'Bạn chưa có đơn hàng nào.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : RefreshIndicator(
        onRefresh: _loadOrders,
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _orders.length,
          itemBuilder: (context, index) {
            final order = _orders[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: Icon(Icons.receipt_long, color: Theme.of(context).primaryColor),
                title: Text('ĐH ngày ${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}'),
                subtitle: Text('Trạng thái: ${order.status}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OrderDetailsScreen(order: order, isFromOrderList: true),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CheckoutScreen()),
          );
          // Tải lại danh sách sau khi quay lại từ màn hình checkout
          _loadOrders();
        },
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        tooltip: 'Tạo đơn hàng mới',
      ),
    );
  }
}