import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductListScreen(),
    );
  }
}

class Product {
  final String image;
  final String title;
  final double price;
  final double rating;
  final String views;

  Product(this.image, this.title, this.price, this.rating, this.views);
}

class ProductListScreen extends StatelessWidget {
  final List<Product> products = [
    Product("assets/images/ví.jpg",
        "Ví nam mini dùng thẻ VS22 chất da Saffiano bền đẹp...", 255000, 4.0, "8.4k views"),
    Product("assets/images/cặpad.png",
        "Túi đeo chéo LECAT polyester chống thấm thời trang c...", 315000, 5.0, "1.3k views"),
    Product("assets/images/phin.jpg",
        "Phin cafe Trung Nguyên - Phin nhôm cà nhôm cao cấp", 28000, 4.5, "12.2k views"),
    Product("assets/images/ví da.jpg",
        "Ví da cầm tay mềm mại có lớn thiết kế thời trang cao...", 610000, 5.0, "56 views"),
    Product("assets/images/dép.jpg",
        "Dép nữ đế cao su mềm siêu nhẹ phong cách ulzzang", 159000, 4.3, "9.5k views"),
    Product("assets/images/tai nghe.jpg",
        "Tai nghe Bluetooth M10 pin trâu kèm hộp sạc", 199000, 4.8, "15.1k views"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DANH SÁCH SẢN PHẨM"),
        backgroundColor: Colors.blue,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 cột
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.65, // tỉ lệ khung sản phẩm
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: Image.asset(
                      product.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${product.price.toStringAsFixed(0)} VND",
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.orange),
                          Text(product.rating.toString(),
                              style: const TextStyle(fontSize: 12)),
                          const Spacer(),
                          Text(product.views,
                              style: const TextStyle(fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
