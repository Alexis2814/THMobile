import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order Wizard',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const OrderListScreen(),
    );
  }
}

// -------------------- Order List Screen --------------------
class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final List<Order> _orders = [];

  void _addOrder(Order order) {
    setState(() => _orders.add(order));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Orders")),
      body: _orders.isEmpty
          ? const Center(child: Text("No orders yet."))
          : ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (_, i) {
          final order = _orders[i];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: order.imagePath != null
                  ? Image.file(File(order.imagePath!), width: 50, height: 50, fit: BoxFit.cover)
                  : const Icon(Icons.inventory),
              title: Text(order.customerName),
              subtitle: Text("${order.productName} x${order.quantity}"),
              trailing: Text(order.phone),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderDetailScreen(order: order),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final order = await Navigator.push<Order>(
            context,
            MaterialPageRoute(builder: (_) => const OrderWizardScreen()),
          );
          if (order != null) _addOrder(order);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// -------------------- Order Wizard Screen --------------------
class OrderWizardScreen extends StatefulWidget {
  const OrderWizardScreen({super.key});
  @override
  State<OrderWizardScreen> createState() => _OrderWizardScreenState();
}

class _OrderWizardScreenState extends State<OrderWizardScreen> {
  int _currentStep = 0;

  // Step 1 controllers
  final _formCustomerKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  // Step 2 controllers
  final _formAddressKey = GlobalKey<FormState>();
  final _streetCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _zipCtrl = TextEditingController();
  String? _fullAddress;

  // Step 3 controllers
  final _formOrderKey = GlobalKey<FormState>();
  final _productCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  String? _imagePath;

  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imagePath = picked.path;
      });
    }
  }

  void _submitOrder() {
    if (_formCustomerKey.currentState!.validate() &&
        _formAddressKey.currentState!.validate() &&
        _formOrderKey.currentState!.validate() &&
        _fullAddress != null) {
      final order = Order(
        customerName: _nameCtrl.text,
        phone: _phoneCtrl.text,
        address: _fullAddress!,
        productName: _productCtrl.text,
        quantity: int.parse(_quantityCtrl.text),
        imagePath: _imagePath,
      );
      Navigator.pop(context, order);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all steps.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Order")),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() => _currentStep++);
          } else {
            _submitOrder();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) setState(() => _currentStep--);
        },
        steps: [
          // Step 1 - Customer
          Step(
            title: const Text("Customer Info"),
            isActive: _currentStep >= 0,
            content: Form(
              key: _formCustomerKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: "Customer Name"),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                  TextFormField(
                    controller: _phoneCtrl,
                    decoration: const InputDecoration(labelText: "Phone"),
                    keyboardType: TextInputType.phone,
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                ],
              ),
            ),
          ),

          // Step 2 - Address
          Step(
            title: const Text("Shipping Address"),
            isActive: _currentStep >= 1,
            content: Form(
              key: _formAddressKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _streetCtrl,
                    decoration: const InputDecoration(labelText: "Street"),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                  TextFormField(
                    controller: _cityCtrl,
                    decoration: const InputDecoration(labelText: "City"),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                  TextFormField(
                    controller: _stateCtrl,
                    decoration: const InputDecoration(labelText: "State"),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                  TextFormField(
                    controller: _zipCtrl,
                    decoration: const InputDecoration(labelText: "Zip Code"),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.length < 4 ? "Invalid" : null,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text("Save Address"),
                    onPressed: () {
                      if (_formAddressKey.currentState!.validate()) {
                        setState(() {
                          _fullAddress =
                          "${_streetCtrl.text}, ${_cityCtrl.text}, ${_stateCtrl.text}, ${_zipCtrl.text}";
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Address Saved")),
                        );
                      }
                    },
                  ),
                  if (_fullAddress != null) ...[
                    const SizedBox(height: 10),
                    Text("Saved: $_fullAddress",
                        style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.deepPurple)),
                  ],
                ],
              ),
            ),
          ),

          // Step 3 - Order summary
          Step(
            title: const Text("Order Summary"),
            isActive: _currentStep >= 2,
            content: Form(
              key: _formOrderKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _productCtrl,
                    decoration: const InputDecoration(labelText: "Product"),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                  TextFormField(
                    controller: _quantityCtrl,
                    decoration: const InputDecoration(labelText: "Quantity"),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                    v!.isEmpty ? "Required" : int.tryParse(v) == null
                        ? "Must be a number"
                        : null,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.image),
                    label: const Text("Upload Product Image"),
                    onPressed: _pickImage,
                  ),
                  if (_imagePath != null) ...[
                    const SizedBox(height: 10),
                    Image.file(File(_imagePath!), height: 100),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------- Order Detail Screen --------------------
class OrderDetailScreen extends StatelessWidget {
  final Order order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Detail")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Customer: ${order.customerName}", style: const TextStyle(fontSize: 18)),
            Text("Phone: ${order.phone}"),
            Text("Address: ${order.address}"),
            Text("Product: ${order.productName}"),
            Text("Quantity: ${order.quantity}"),
            if (order.imagePath != null) ...[
              const SizedBox(height: 12),
              Image.file(File(order.imagePath!), height: 150),
            ]
          ],
        ),
      ),
    );
  }
}

// -------------------- Model --------------------
class Order {
  final String customerName;
  final String phone;
  final String address;
  final String productName;
  final int quantity;
  final String? imagePath;

  Order({
    required this.customerName,
    required this.phone,
    required this.address,
    required this.productName,
    required this.quantity,
    this.imagePath,
  });
}
