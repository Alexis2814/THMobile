// lib/screens/order_details_screen.dart
import 'package:flutter/material.dart';
import '../models/order_model.dart';
import 'order_list_screen.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Order order;
  final bool isFromOrderList;

  const OrderDetailsScreen({
    super.key,
    required this.order,
    this.isFromOrderList = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
        // Tự động ẩn nút back nếu đến từ luồng checkout
        automaticallyImplyLeading: isFromOrderList,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (!isFromOrderList) ...[
              const Center(child: Icon(Icons.check_circle, color: Colors.green, size: 80)),
              const SizedBox(height: 16),
              Center(child: Text('Đặt hàng thành công!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold))),
              const SizedBox(height: 24),
            ],
            _buildSectionTitle('Thông tin khách hàng'),
            _buildDetailRow('Họ tên:', order.customerName),
            _buildDetailRow('Số điện thoại:', order.phone),
            _buildDetailRow('Địa chỉ:', '${order.addressDetails}, ${order.ward}, ${order.district}, ${order.province}'),
            const Divider(height: 30),
            _buildSectionTitle('Thông tin đơn hàng'),
            _buildDetailRow('Ngày đặt:', '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}'),
            _buildDetailRow('Hình thức thanh toán:', order.paymentMethod),
            _buildDetailRow('Ghi chú:', order.notes!.isEmpty ? '(Không có)' : order.notes!),
            const SizedBox(height: 40),
            if (!isFromOrderList)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const OrderListScreen()),
                        (Route<dynamic> route) => false,
                  );
                },
                child: const Text('Về danh sách đơn hàng'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}