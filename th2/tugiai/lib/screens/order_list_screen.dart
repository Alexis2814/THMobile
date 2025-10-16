// lib/screens/order_list_screen.dart
import 'package:collection/collection.dart'; // Thêm thư viện collection để nhóm
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/database_helper.dart';
import '../models/order.dart';
import 'order_detail_screen.dart';
import 'order_form_screen.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  late Future<List<Order>> _ordersFuture;
  final TextEditingController _searchController = TextEditingController();

  // Biến trạng thái cho bộ lọc
  DateTimeRange? _selectedDateRange;
  String? _selectedPaymentMethod;
  bool _isFilterApplied = false;

  @override
  void initState() {
    super.initState();
    _refreshOrders();
  }

  void _refreshOrders() {
    setState(() {
      _ordersFuture = DatabaseHelper.instance.readAllOrders(
        query: _searchController.text,
        dateRange: _selectedDateRange,
        paymentMethod: _selectedPaymentMethod,
      );
      _isFilterApplied = _selectedDateRange != null || _selectedPaymentMethod != null;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirmDelete(int id) {
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
              onPressed: () async {
                await DatabaseHelper.instance.delete(id);
                Navigator.of(context).pop();
                _refreshOrders();
              },
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // HÀM MỚI ĐỂ HIỂN THỊ BỘ LỌC
  // ==========================================================
  void _showFilterDialog() {
    // Lưu lại giá trị tạm thời
    DateTimeRange? tempDateRange = _selectedDateRange;
    String? tempPaymentMethod = _selectedPaymentMethod;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 20, left: 20, right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bộ lọc đơn hàng', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 20),

                  // Lọc theo ngày
                  ListTile(
                    leading: const Icon(Icons.date_range),
                    title: const Text('Lọc theo ngày giao'),
                    subtitle: Text(
                      tempDateRange == null
                          ? 'Chưa chọn'
                          : '${DateFormat('dd/MM/yyyy').format(tempDateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(tempDateRange!.end)}',
                    ),
                    onTap: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        initialDateRange: tempDateRange,
                      );
                      if (picked != null) {
                        setModalState(() {
                          tempDateRange = picked;
                        });
                      }
                    },
                  ),

                  // Lọc theo phương thức thanh toán
                  const SizedBox(height: 10),
                  const Text('Phương thức thanh toán', style: TextStyle(fontWeight: FontWeight.bold)),
                  RadioListTile<String?>(
                    title: const Text('Tất cả'), value: null, groupValue: tempPaymentMethod,
                    onChanged: (v) => setModalState(() => tempPaymentMethod = v),
                  ),
                  RadioListTile<String?>(
                    title: const Text('Tiền mặt'), value: 'Tiền mặt', groupValue: tempPaymentMethod,
                    onChanged: (v) => setModalState(() => tempPaymentMethod = v),
                  ),
                  RadioListTile<String?>(
                    title: const Text('Chuyển khoản'), value: 'Chuyển khoản', groupValue: tempPaymentMethod,
                    onChanged: (v) => setModalState(() => tempPaymentMethod = v),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text('Xoá bộ lọc'),
                        onPressed: () {
                          setState(() {
                            _selectedDateRange = null;
                            _selectedPaymentMethod = null;
                          });
                          _refreshOrders();
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        child: const Text('Áp dụng'),
                        onPressed: () {
                          setState(() {
                            _selectedDateRange = tempDateRange;
                            _selectedPaymentMethod = tempPaymentMethod;
                          });
                          _refreshOrders();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý đơn hàng'),
        actions: [
          // Thêm nút mở bộ lọc
          IconButton(
            icon: Icon(Icons.filter_list, color: _isFilterApplied ? Colors.amber : Colors.white),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Tìm kiếm theo tên khách hàng',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _refreshOrders();
                  },
                )
                    : null,
              ),
              onChanged: (value) => _refreshOrders(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Order>>(
              future: _ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Không có đơn hàng nào.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                // ==========================================================
                // LOGIC PHÂN NHÓM THEO NGÀY
                // ==========================================================
                final orders = snapshot.data!;
                final groupedOrders = groupBy(orders, (Order order) {
                  // Chuẩn hóa ngày về 00:00:00 để nhóm chính xác
                  return DateTime(order.deliveryDate.year, order.deliveryDate.month, order.deliveryDate.day);
                });

                // Chuyển map thành danh sách các key đã sắp xếp
                final sortedKeys = groupedOrders.keys.toList()..sort((a, b) => b.compareTo(a));

                return ListView.builder(
                  itemCount: sortedKeys.length,
                  itemBuilder: (context, index) {
                    final dateKey = sortedKeys[index];
                    final ordersInGroup = groupedOrders[dateKey]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header cho mỗi nhóm ngày
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Text(
                            DateFormat('EEEE, dd MMMM, yyyy', 'vi_VN').format(dateKey),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                          ),
                        ),
                        // Danh sách các đơn hàng trong ngày đó
                        ...ordersInGroup.map((order) => _buildOrderListItem(order)).toList(),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const OrderFormScreen()),
          );
          if (result == true) {
            _refreshOrders();
          }
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
        tooltip: 'Tạo đơn hàng mới',
      ),
    );
  }

  // Tách ra thành widget riêng để dễ quản lý
  Widget _buildOrderListItem(Order order) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.shade100,
          child: Text(order.customerName[0].toUpperCase(), style: const TextStyle(color: Colors.deepPurple)),
        ),
        title: Text(order.customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Mã: ${order.orderId} - ${order.paymentMethod}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _confirmDelete(order.id!),
        ),
        onTap: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => OrderDetailScreen(orderId: order.id!)),
          );
          if (result == true) {
            _refreshOrders();
          }
        },
      ),
    );
  }
}