// lib/screens/product_filter_screen.dart

import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductFilterScreen extends StatefulWidget {
  @override
  _ProductFilterScreenState createState() => _ProductFilterScreenState();
}

class _ProductFilterScreenState extends State<ProductFilterScreen> {
  // Dữ liệu sản phẩm giả lập (local)
  final List<Product> _allProducts = [
    Product(name: 'iPhone 14 Pro', price: 999, category: 'Điện thoại', createdAt: DateTime(2023, 9, 1)),
    Product(name: 'Samsung Galaxy S23', price: 799, category: 'Điện thoại', createdAt: DateTime(2023, 8, 15)),
    Product(name: 'Macbook Air M2', price: 1199, category: 'Laptop', createdAt: DateTime(2023, 7, 20)),
    Product(name: 'Dell XPS 15', price: 1499, category: 'Laptop', createdAt: DateTime(2023, 9, 5)),
    Product(name: 'Sony WH-1000XM5', price: 399, category: 'Tai nghe', createdAt: DateTime(2023, 6, 10)),
    Product(name: 'AirPods Pro 2', price: 249, category: 'Tai nghe', createdAt: DateTime(2023, 9, 12)),
    Product(name: 'iPad Pro', price: 1099, category: 'Máy tính bảng', createdAt: DateTime(2023, 5, 1)),
  ];

  List<Product> _filteredProducts = [];

  // Controllers và các biến trạng thái cho bộ lọc
  final TextEditingController _fromPriceController = TextEditingController();
  final TextEditingController _toPriceController = TextEditingController();

  // Danh sách các danh mục có sẵn
  final List<String> _categories = ['Điện thoại', 'Laptop', 'Tai nghe', 'Máy tính bảng'];
  // Danh sách các danh mục được chọn
  List<String> _selectedCategories = [];

  // Tùy chọn sắp xếp
  String? _sortBy; // Giá trị mặc định là null

  @override
  void initState() {
    super.initState();
    _filteredProducts = _allProducts; // Ban đầu hiển thị tất cả
  }

  // lib/screens/product_filter_screen.dart

  void _applyFilters() {
    // --- PHẦN VALIDATE MỚI ---
    final fromPrice = double.tryParse(_fromPriceController.text);
    final toPrice = double.tryParse(_toPriceController.text);

    // Kiểm tra nếu cả hai giá trị đều được nhập và "Từ giá" lớn hơn "Đến giá"
    if (fromPrice != null && toPrice != null && fromPrice > toPrice) {
      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("'Đến giá' không được nhỏ hơn 'Từ giá'"),
          backgroundColor: Colors.redAccent, // Màu đỏ để báo lỗi
        ),
      );
      return; // Dừng hàm tại đây, không thực hiện lọc
    }
    // --- KẾT THÚC PHẦN VALIDATE ---
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        // Lọc theo giá (logic này không đổi)
        if (fromPrice != null && product.price < fromPrice) return false;
        if (toPrice != null && product.price > toPrice) return false;

        // Lọc theo danh mục (logic này không đổi)
        if (_selectedCategories.isNotEmpty && !_selectedCategories.contains(product.category)) {
          return false;
        }

        return true;
      }).toList();

      // Sắp xếp kết quả (logic này không đổi)
      if (_sortBy != null) {
        _filteredProducts.sort((a, b) {
          if (_sortBy == 'Giá tăng') {
            return a.price.compareTo(b.price);
          } else if (_sortBy == 'Giá giảm') {
            return b.price.compareTo(a.price);
          } else if (_sortBy == 'Mới nhất') {
            return b.createdAt.compareTo(a.createdAt);
          }
          return 0;
        });
      }
    });
  }

  void _resetFilters() {
    setState(() {
      _fromPriceController.clear();
      _toPriceController.clear();
      _selectedCategories.clear();
      _sortBy = null;
      _filteredProducts = _allProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lọc sản phẩm',
          style: TextStyle(color: Colors.white), // <--- Thêm dòng này
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- BỘ LỌC ---
            Text('Giá sản phẩm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _fromPriceController,
                    decoration: InputDecoration(labelText: 'Từ giá', prefixIcon: Icon(Icons.attach_money)),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _toPriceController,
                    decoration: InputDecoration(labelText: 'Đến giá', prefixIcon: Icon(Icons.attach_money)),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            Text('Danh mục', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8.0,
              children: _categories.map((category) {
                final isSelected = _selectedCategories.contains(category);
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedCategories.add(category);
                      } else {
                        _selectedCategories.remove(category);
                      }
                    });
                  },
                  selectedColor: Colors.blueAccent.withOpacity(0.8),
                  labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                  checkmarkColor: Colors.white,
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            Text('Xếp theo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: _sortBy,
              hint: Text('Chọn thứ tự sắp xếp'),
              onChanged: (String? newValue) {
                setState(() {
                  _sortBy = newValue;
                });
              },
              items: <String>['Giá tăng', 'Giá giảm', 'Mới nhất']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: Text('Áp dụng', style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetFilters,
                    child: Text('Đặt lại'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.blueAccent),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            Divider(height: 40, thickness: 1),

            // --- KẾT QUẢ ---
            Text('Kết quả (${_filteredProducts.length})', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${product.category} - Tạo ngày: ${product.createdAt.day}/${product.createdAt.month}/${product.createdAt.year}'),
                      trailing: Text(
                        '\$${product.price.toStringAsFixed(0)}',
                        style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}