import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Lăn Bi',
      // Thuộc tính theme chỉ chứa các dữ liệu về giao diện
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Đặt debugShowCheckedModeBanner ở đây là đúng
      debugShowCheckedModeBanner: false,
      home: const BalanceGameScreen(),
    );
  }
}

class BalanceGameScreen extends StatefulWidget {
  const BalanceGameScreen({super.key});

  @override
  State<BalanceGameScreen> createState() => _BalanceGameScreenState();
}

class _BalanceGameScreenState extends State<BalanceGameScreen> {
  // Kích thước của quả bi và đích
  static const double _ballSize = 50.0;
  static const double _targetSize = 60.0;

  // Tọa độ của quả bi và đích
  double? _ballX, _ballY;
  double? _targetX, _targetY;

  // Kích thước màn hình
  double _screenWidth = 0;
  double _screenHeight = 0;

  // Stream subscription cho cảm biến
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  // Biến kiểm tra xem game đã được khởi tạo chưa
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Bắt đầu lắng nghe sự kiện từ gia tốc kế
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
          if (!_isInitialized || _ballX == null) return;

          // Cập nhật tọa độ X và Y của quả bi
          setState(() {
            // event.x điều khiển chuyển động ngang, event.y điều khiển dọc
            // Dấu trừ (-) được dùng để đảo ngược hướng cho tự nhiên hơn
            // Hệ số nhân (ví dụ: 2.5) để làm mượt và điều chỉnh tốc độ
            _ballX = _ballX! - event.x * 2.5;
            _ballY = _ballY! + event.y * 2.5;

            // Giới hạn để quả bi không đi ra ngoài màn hình
            _clampBallPosition();

            // Kiểm tra điều kiện thắng
            _checkWinCondition();
          });
        });
  }

  // Hàm này được gọi khi các dependency của State thay đổi,
  // và cũng được gọi sau initState. An toàn để lấy kích thước màn hình ở đây.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final size = MediaQuery.of(context).size;
      _screenWidth = size.width;
      // Trừ đi chiều cao của AppBar và thanh trạng thái để quả bi không bị che
      _screenHeight = size.height -
          MediaQuery.of(context).padding.top -
          kToolbarHeight;

      // Khởi tạo vị trí ban đầu cho quả bi ở giữa màn hình
      setState(() {
        _ballX = (_screenWidth - _ballSize) / 2;
        _ballY = (_screenHeight - _ballSize) / 2;
        // Đặt đích ở một vị trí ngẫu nhiên
        _randomizeTargetPosition();
        _isInitialized = true;
      });
    }
  }

  void _clampBallPosition() {
    // Giới hạn tọa độ X
    if (_ballX! < 0) {
      _ballX = 0;
    } else if (_ballX! > _screenWidth - _ballSize) {
      _ballX = _screenWidth - _ballSize;
    }

    // Giới hạn tọa độ Y
    if (_ballY! < 0) {
      _ballY = 0;
    } else if (_ballY! > _screenHeight - _ballSize) {
      _ballY = _screenHeight - _ballSize;
    }
  }

  void _randomizeTargetPosition() {
    final random = Random();
    setState(() {
      // Tạo vị trí ngẫu nhiên trong phạm vi màn hình
      _targetX = random.nextDouble() * (_screenWidth - _targetSize);
      _targetY = random.nextDouble() * (_screenHeight - _targetSize);
    });
  }

  void _checkWinCondition() {
    if (_ballX == null || _targetX == null) return;

    // Tính toán tâm của quả bi và đích
    double ballCenterX = _ballX! + _ballSize / 2;
    double ballCenterY = _ballY! + _ballSize / 2;
    double targetCenterX = _targetX! + _targetSize / 2;
    double targetCenterY = _targetY! + _targetSize / 2;

    // Tính khoảng cách giữa hai tâm
    double distance = sqrt(pow(ballCenterX - targetCenterX, 2) +
        pow(ballCenterY - targetCenterY, 2));

    // Nếu khoảng cách nhỏ hơn bán kính của đích, tức là quả bi đã vào trong
    if (distance < _targetSize / 2) {
      // Hiển thị thông báo chiến thắng
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Tuyệt vời! Bạn đã thắng! 🎉'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      // Di chuyển đích đến vị trí ngẫu nhiên mới
      _randomizeTargetPosition();
    }
  }

  @override
  void dispose() {
    // Hủy đăng ký lắng nghe để tránh rò rỉ bộ nhớ
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Lăn Bi Thăng Bằng'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: _isInitialized // Chỉ build game khi đã có kích thước màn hình
          ? Stack(
        children: [
          // Cái Đích
          if (_targetX != null && _targetY != null)
            Positioned(
              left: _targetX,
              top: _targetY,
              child: Container(
                width: _targetSize,
                height: _targetSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade600, width: 4),
                  color: Colors.grey.withOpacity(0.3),
                ),
              ),
            ),
          // Quả Bi
          if (_ballX != null && _ballY != null)
            Positioned(
              left: _ballX,
              top: _ballY,
              child: Container(
                width: _ballSize,
                height: _ballSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.lightBlueAccent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
        ],
      )
          : const Center(
        child: CircularProgressIndicator(), // Hiển thị loading
      ),
    );
  }
}
