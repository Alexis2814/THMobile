// lib/screens/checkout_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';
import 'order_details_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

enum PaymentMethod { cash, card }

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;

  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressDetailsController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedProvince;
  String? _selectedDistrict;
  String? _selectedWard;

  final Map<String, List<String>> _districts = {
    'Hà Nội': ['Ba Đình', 'Hoàn Kiếm', 'Hai Bà Trưng'],
    'TP. Hồ Chí Minh': ['Quận 1', 'Quận 3', 'Bình Thạnh'],
  };
  final Map<String, List<String>> _wards = {
    'Ba Đình': ['Phúc Xá', 'Trúc Bạch'], 'Hoàn Kiếm': ['Hàng Bạc', 'Hàng Trống'],
    'Quận 1': ['Tân Định', 'Đa Kao'], 'Bình Thạnh': ['Phường 1', 'Phường 2'],
  };

  PaymentMethod _paymentMethod = PaymentMethod.cash;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressDetailsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo đơn hàng mới'),
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        onStepTapped: (step) => setState(() => _currentStep = step),
        steps: _buildSteps(),
        controlsBuilder: (context, details) {
          final isLastStep = details.currentStep == _buildSteps().length - 1;
          return Container(
            margin: const EdgeInsets.only(top: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (details.currentStep != 0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back'),
                  ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(isLastStep ? 'XÁC NHẬN' : 'TIẾP TỤC'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Step> _buildSteps() {
    return [
      Step(
        title: const Text('Thông tin khách hàng'),
        content: Form(
          key: _formKeyStep1,
          child: Column(
            children: [
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Họ và tên'), validator: (v) => v!.isEmpty ? 'Vui lòng nhập họ tên' : null),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress, validator: (v) => (v!.isEmpty || !v.contains('@')) ? 'Email không hợp lệ' : null),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Số điện thoại'), keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'Vui lòng nhập số điện thoại' : null),
            ],
          ),
        ),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Địa chỉ giao hàng'),
        content: Form(
          key: _formKeyStep2,
          child: Column(
            children: [
              DropdownButtonFormField<String>(value: _selectedProvince, hint: const Text('Chọn Tỉnh/Thành phố'), items: _districts.keys.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(), onChanged: (v){ setState(() { _selectedProvince = v; _selectedDistrict = null; _selectedWard = null; }); }, validator: (v) => v == null ? 'Vui lòng chọn' : null),
              if (_selectedProvince != null) DropdownButtonFormField<String>(value: _selectedDistrict, hint: const Text('Chọn Quận/Huyện'), items: _districts[_selectedProvince]!.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(), onChanged: (v) { setState(() { _selectedDistrict = v; _selectedWard = null; }); }, validator: (v) => v == null ? 'Vui lòng chọn' : null),
              if (_selectedDistrict != null && _wards.containsKey(_selectedDistrict)) DropdownButtonFormField<String>(value: _selectedWard, hint: const Text('Chọn Phường/Xã'), items: _wards[_selectedDistrict]!.map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(), onChanged: (v) => setState(() => _selectedWard = v), validator: (v) => v == null ? 'Vui lòng chọn' : null),
              TextFormField(controller: _addressDetailsController, decoration: const InputDecoration(labelText: 'Địa chỉ chi tiết'), validator: (v) => v!.isEmpty ? 'Vui lòng nhập địa chỉ' : null),
            ],
          ),
        ),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Thanh toán & Xác nhận'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phương thức thanh toán', style: Theme.of(context).textTheme.titleMedium),
            RadioListTile<PaymentMethod>(title: const Text('Thanh toán khi nhận hàng'), value: PaymentMethod.cash, groupValue: _paymentMethod, onChanged: (v) => setState(() => _paymentMethod = v!)),
            RadioListTile<PaymentMethod>(title: const Text('Thẻ'), value: PaymentMethod.card, groupValue: _paymentMethod, onChanged: (v) => setState(() => _paymentMethod = v!)),
            const SizedBox(height: 16),
            TextFormField(controller: _notesController, decoration: const InputDecoration(labelText: 'Ghi chú (tùy chọn)', border: OutlineInputBorder()), maxLines: 3),
          ],
        ),
        isActive: _currentStep >= 2,
      ),
    ];
  }

  void _onStepContinue() {
    // Lấy trạng thái của bước cuối cùng
    final isLastStep = _currentStep == _buildSteps().length - 1;

    // Kiểm tra validate cho bước 1
    if (_currentStep == 0) {
      if (_formKeyStep1.currentState!.validate()) {
        setState(() => _currentStep += 1);
      }
      // Kiểm tra validate cho bước 2
    } else if (_currentStep == 1) {
      if (_formKeyStep2.currentState!.validate()) {
        setState(() => _currentStep += 1);
      }
      // Nếu là bước cuối cùng (bước 3), thì xác nhận đơn hàng
    } else if (isLastStep) {
      _confirmOrder();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  Future<void> _confirmOrder() async {
    final order = Order(
      customerName: _nameController.text, email: _emailController.text, phone: _phoneController.text,
      province: _selectedProvince!, district: _selectedDistrict!, ward: _selectedWard!,
      addressDetails: _addressDetailsController.text,
      paymentMethod: _paymentMethod == PaymentMethod.cash ? 'Tiền mặt' : 'Thẻ',
      notes: _notesController.text, orderDate: DateTime.now(),
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final orderKeys = prefs.getStringList('order_keys') ?? [];
      final newOrderKey = 'order_${DateTime.now().millisecondsSinceEpoch}';

      await prefs.setString(newOrderKey, jsonEncode(order.toJson()));
      orderKeys.add(newOrderKey);
      await prefs.setStringList('order_keys', orderKeys);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đặt hàng thành công!'), backgroundColor: Colors.green)
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => OrderDetailsScreen(order: order)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi lưu đơn hàng: $e'), backgroundColor: Colors.red)
      );
    }
  }
}