// lib/screens/order_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/database_helper.dart';
import '../models/order.dart';
import 'order_form_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late Order _order;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshOrder();
  }

  Future<void> _refreshOrder() async {
    setState(() => _isLoading = true);
    _order = await DatabaseHelper.instance.readOrder(widget.orderId);
    setState(() => _isLoading = false);
  }

  Future<void> _deleteOrder() async {
    await DatabaseHelper.instance.delete(widget.orderId);
    if(mounted) {
      Navigator.of(context).pop(true); // Trả về true để refresh danh sách
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xoá'),
          content: const Text('Bạn có chắc chắn muốn xoá đơn hàng này không?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Huỷ'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Xoá', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteOrder();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
        actions: _isLoading ? null : [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => OrderFormScreen(order: _order)),
              );
              if (result == true) {
                _refreshOrder();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildDetailRow('Mã đơn hàng:', _order.orderId, isHeader: true),
          const Divider(height: 24),
          _buildSectionTitle('Khách hàng'),
          _buildDetailRow('Tên:', _order.customerName),
          _buildDetailRow('Số điện thoại:', _order.phoneNumber),
          _buildDetailRow('Địa chỉ:', _order.address),
          const Divider(height: 24),
          _buildSectionTitle('Đơn hàng'),
          _buildDetailRow('Ngày giao:', DateFormat('dd/MM/yyyy').format(_order.deliveryDate)),
          _buildDetailRow('Thanh toán:', _order.paymentMethod),
          _buildDetailRow('Ghi chú:', _order.notes?.isEmpty ?? true ? '(Không có)' : _order.notes!),
          const SizedBox(height: 16),
          _buildSectionTitle('Sản phẩm đã chọn'),
          Wrap(
            spacing: 8.0,
            children: _order.products.map((p) => Chip(label: Text(p))).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isHeader = false}) {
    final style = isHeader
        ? const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
        : const TextStyle(fontSize: 16);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: style.copyWith(color: Colors.black54))),
          Expanded(child: Text(value, style: style)),
        ],
      ),
    );
  }
}