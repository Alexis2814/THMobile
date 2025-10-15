// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/product_filter_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // <-- Thêm dòng này vào đây
      title: 'Flutter Product Filter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProductFilterScreen(),
    );
  }
}