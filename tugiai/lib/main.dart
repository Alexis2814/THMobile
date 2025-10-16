// lib/main.dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // Thêm import này
import 'screens/order_list_screen.dart';

void main() async { // Chuyển thành async
  WidgetsFlutterBinding.ensureInitialized();
  // Khởi tạo localization cho Tiếng Việt
  await initializeDateFormatting('vi_VN', null);
  runApp(const MyApp());
}

// ... class MyApp giữ nguyên

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản lý Đơn hàng',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        // Sửa lại cho đúng tên class theo yêu cầu của lỗi
        cardTheme: CardThemeData( // <--- Sửa từ CardTheme thành CardThemeData
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      home: const OrderListScreen(),
    );
  }
}