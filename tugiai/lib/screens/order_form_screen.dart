// lib/screens/order_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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

  // Dữ liệu mẫu cho danh sách sản phẩm
  final List<String> _allProducts = [
    'iPhone 15 Pro', 'Macbook Air M3', 'Apple Watch 9', 'AirPods Pro 2', 'iPad Pro M2'
  ];

  // Controllers và các biến trạng thái
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deliveryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _deliveryDate) {
      setState(() {
        _deliveryDate = picked;
      });
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

    final order = Order(
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

    if (isUpdating) {
      await DatabaseHelper.instance.update(order);
    } else {
      await DatabaseHelper.instance.create(order);
    }

    if (mounted) {
      Navigator.of(context).pop(true); // Trả về true để báo hiệu danh sách cần refresh
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.order == null ? 'Tạo đơn hàng mới' : 'Chỉnh sửa đơn hàng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveOrder,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Thông tin khách hàng'),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tên khách hàng', icon: Icon(Icons.person)),
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Số điện thoại', icon: Icon(Icons.phone)),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value!.isEmpty) return 'Vui lòng nhập số điện thoại';
                  if (value.length != 10) return 'Số điện thoại phải có 10 chữ số';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Địa chỉ giao hàng', icon: Icon(Icons.home)),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập địa chỉ' : null,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Thông tin đơn hàng'),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Ngày giao dự kiến'),
                subtitle: Text(DateFormat('dd/MM/yyyy').format(_deliveryDate)),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),
              const Text('Phương thức thanh toán', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              RadioListTile<String>(
                title: const Text('Tiền mặt'),
                value: 'Tiền mặt',
                groupValue: _paymentMethod,
                onChanged: (value) => setState(() => _paymentMethod = value!),
              ),
              RadioListTile<String>(
                title: const Text('Chuyển khoản'),
                value: 'Chuyển khoản',
                groupValue: _paymentMethod,
                onChanged: (value) => setState(() => _paymentMethod = value!),
              ),
              const SizedBox(height: 16),
              const Text('Danh sách sản phẩm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              MultiSelectChip(
                itemList: _allProducts,
                initialValue: _selectedProducts,
                onSelectionChanged: (selectedList) {
                  setState(() {
                    _selectedProducts = selectedList;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Ghi chú', border: OutlineInputBorder()),
                maxLines: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
      ),
    );
  }
}