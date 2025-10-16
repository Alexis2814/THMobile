// lib/screens/order_form_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import '../helpers/database_helper.dart';
import '../models/order.dart';
import '../widgets/multi_select_chip.dart';

class OrderFormScreen extends StatefulWidget {
  final Order? order;

  const OrderFormScreen({super.key, this.order});

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _allProducts = [
    'iPhone 15 Pro', 'Macbook Air M3', 'Apple Watch 9', 'AirPods Pro 2', 'iPad Pro M2'
  ];

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _notesController;
  late DateTime _deliveryDate;
  String _paymentMethod = 'Tiền mặt';
  List<String> _selectedProducts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.order?.customerName ?? '');
    _phoneController = TextEditingController(text: widget.order?.phoneNumber ?? '');
    _addressController = TextEditingController(text: widget.order?.address ?? '');
    _notesController = TextEditingController(text: widget.order?.notes ?? '');
    _deliveryDate = widget.order?.deliveryDate ?? DateTime.now();
    _paymentMethod = widget.order?.paymentMethod ?? 'Tiền mặt';
    _selectedProducts = widget.order?.products ?? [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _downloadOrderAsTxt(Order order) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      try {
        final directory = await getDownloadsDirectory();
        if (directory == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không thể truy cập thư mục Downloads'), backgroundColor: Colors.red),
          );
          return;
        }

        final filePath = '${directory.path}/don-hang-${order.orderId}.txt';
        final file = File(filePath);

        final content = '''
---------------------------------
    CHI TIẾT ĐƠN HÀNG
---------------------------------
Mã đơn hàng:    ${order.orderId}
Ngày đặt:       ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}
Ngày giao:      ${DateFormat('dd/MM/yyyy').format(order.deliveryDate)}

Tên khách hàng: ${order.customerName}
Số điện thoại:  ${order.phoneNumber}
Địa chỉ:        ${order.address}

Thanh toán:     ${order.paymentMethod}
Sản phẩm:       ${order.products.join(', ')}

Ghi chú:
${order.notes?.isEmpty ?? true ? '(Không có)' : order.notes}
---------------------------------
        ''';

        await file.writeAsString(content);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã lưu đơn hàng vào: $filePath'), backgroundColor: Colors.green),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi lưu file: $e'), backgroundColor: Colors.red),
        );
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không được cấp quyền truy cập bộ nhớ'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _saveOrder() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    if (_selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ít nhất một sản phẩm'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);
    final isUpdating = widget.order != null;

    final orderData = Order(
      id: widget.order?.id,
      orderId: widget.order?.orderId ?? const Uuid().v4().substring(0, 8).toUpperCase(),
      customerName: _nameController.text,
      phoneNumber: _phoneController.text,
      address: _addressController.text,
      deliveryDate: _deliveryDate,
      paymentMethod: _paymentMethod,
      products: _selectedProducts,
      notes: _notesController.text,
    );

    final savedOrder = isUpdating
        ? await DatabaseHelper.instance.update(orderData).then((_) => orderData)
        : await DatabaseHelper.instance.create(orderData);

    setState(() => _isLoading = false);

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Thành công!'),
        content: Text('Đã ${isUpdating ? 'cập nhật' : 'tạo mới'} đơn hàng #${savedOrder.orderId} thành công.'),
        actions: [
          TextButton(
            child: const Text('Về danh sách'),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(true);
            },
          ),
          ElevatedButton(
            child: const Text('Tải đơn hàng (.txt)'),
            onPressed: () {
              _downloadOrderAsTxt(savedOrder);
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Xóa nút lưu ở đây
        title: Text(widget.order == null ? 'Tạo đơn hàng mới' : 'Chỉnh sửa đơn hàng'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Thông tin khách hàng'),
              _buildTextField(
                controller: _nameController,
                label: 'Tên khách hàng',
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên' : null,
              ),
              _buildTextField(
                controller: _phoneController,
                label: 'Số điện thoại (10 số)',
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value!.isEmpty) return 'Vui lòng nhập số điện thoại';
                  if (value.length != 10) return 'Số điện thoại phải có 10 chữ số';
                  return null;
                },
              ),
              _buildTextField(
                controller: _addressController,
                label: 'Địa chỉ giao hàng',
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập địa chỉ' : null,
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Thông tin đơn hàng'),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Ngày giao dự kiến'),
                subtitle: Text(DateFormat('dd/MM/yyyy').format(_deliveryDate)),
                trailing: const Icon(Icons.arrow_drop_down),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _deliveryDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _deliveryDate) {
                    setState(() => _deliveryDate = picked);
                  }
                },
              ),
              const SizedBox(height: 16),
              const Text('Phương thức thanh toán', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              RadioListTile<String>(
                  title: const Text('Tiền mặt'),
                  value: 'Tiền mặt',
                  groupValue: _paymentMethod,
                  onChanged: (v) => setState(() => _paymentMethod = v!)),
              RadioListTile<String>(
                  title: const Text('Chuyển khoản'),
                  value: 'Chuyển khoản',
                  groupValue: _paymentMethod,
                  onChanged: (v) => setState(() => _paymentMethod = v!)),
              const SizedBox(height: 16),
              const Text('Danh sách sản phẩm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              MultiSelectChip(
                itemList: _allProducts,
                initialValue: _selectedProducts,
                onSelectionChanged: (selectedList) => setState(() => _selectedProducts = selectedList),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _notesController,
                label: 'Ghi chú (tùy chọn)',
                maxLines: 4,
                validator: (value) => null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, // Cho nút rộng hết cỡ
                child: ElevatedButton.icon(
                  label: const Text('Lưu đơn hàng'),
                  onPressed: _isLoading ? null : _saveOrder,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            maxLines: maxLines,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
      ),
    );
  }
}