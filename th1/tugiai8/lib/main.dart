import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Tắt banner debug
      title: 'Profile UI',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình để tính toán vị trí đường cong
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white, // Nền trắng cho toàn bộ màn hình
      body: Stack(
        children: [
          // Đường cong màu hồng ở trên
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100, // Chiều cao của phần màu hồng
              decoration: const BoxDecoration(
                color: Color(0xFFF06292), // Màu hồng đậm hơn
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50), // Bo tròn góc dưới trái
                  bottomRight: Radius.circular(50), // Bo tròn góc dưới phải
                ),
              ),
            ),
          ),
          // Đường viền cong màu hồng bên ngoài (như trong ảnh)
          Positioned(
            top: 10, // Dịch xuống một chút so với mép trên
            left: screenWidth * 0.05, // Cách lề trái 5% chiều rộng màn hình
            right: screenWidth * 0.05, // Cách lề phải 5% chiều rộng màn hình
            child: Container(
              height: 380, // Chiều cao tổng thể của card
              decoration: BoxDecoration(
                color: Colors.white, // Nền trắng của card
                borderRadius: BorderRadius.circular(20), // Bo tròn góc của card
                border: Border.all(
                  color: const Color(0xFFF06292), // Màu viền hồng
                  width: 3, // Độ dày của viền
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar người dùng
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey, // Màu nền avatar
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white, // Màu biểu tượng người
                          ),
                        ),
                        // Nút camera ở góc dưới bên phải avatar
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white, // Nền trắng cho icon camera
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20), // Khoảng cách
                    // Tên người dùng
                    const Text(
                      'Hi Sir David',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5), // Khoảng cách nhỏ
                    // Mô tả/chức vụ
                    const Text(
                      'Wildlife Advocate',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 30), // Khoảng cách
                    // Nút "Edit Profile"
                    ElevatedButton(
                      onPressed: () {
                        // Xử lý khi nhấn nút
                        print('Edit Profile pressed!');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF06292), // Màu nền nút hồng
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Bo tròn nút
                        ),
                        elevation: 0, // Bỏ bóng nút
                      ),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}