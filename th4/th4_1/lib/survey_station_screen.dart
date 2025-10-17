import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:schoolyard_heatmap/data_model.dart';
import 'package:schoolyard_heatmap/file_service.dart';
import 'package:intl/intl.dart';

class SurveyStationScreen extends StatefulWidget {
  const SurveyStationScreen({super.key});

  @override
  _SurveyStationScreenState createState() => _SurveyStationScreenState();
}

class _SurveyStationScreenState extends State<SurveyStationScreen> {
  final FileService _fileService = FileService();
  final Location _location = Location();

  // Dữ liệu cảm biến
  double _motionMagnitude = 0.0;
  double _magneticMagnitude = 0.0;
  double _lightIntensity = 0.0; // Giả lập

  // Stream Subscriptions để hủy khi không cần
  late StreamSubscription<UserAccelerometerEvent> _accelSubscription;
  late StreamSubscription<MagnetometerEvent> _magnetoSubscription;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _startSensorListeners();
    _requestPermissions();
  }

  @override
  void dispose() {
    // Hủy lắng nghe để tránh rò rỉ bộ nhớ
    _accelSubscription.cancel();
    _magnetoSubscription.cancel();
    super.dispose();
  }

  void _startSensorListeners() {
    // Lắng nghe Gia tốc kế
    _accelSubscription = userAccelerometerEventStream().listen(
          (UserAccelerometerEvent event) {
        if (mounted) {
          setState(() {
            _motionMagnitude = SurveyPoint.calculateMagnitude(event.x, event.y, event.z);
          });
        }
      },
      onError: (e) {
        print("Accelerometer error: $e");
      },
      cancelOnError: true,
    );

    // Lắng nghe Từ kế
    _magnetoSubscription = magnetometerEventStream().listen(
          (MagnetometerEvent event) {
        if (mounted) {
          setState(() {
            _magneticMagnitude = SurveyPoint.calculateMagnitude(event.x, event.y, event.z);
            // GIẢ LẬP DỮ LIỆU ÁNH SÁNG
            // Dựa vào từ trường để có giá trị thay đổi cho sinh động
            _lightIntensity = (_magneticMagnitude * 100 + Random().nextInt(500)).clamp(50, 20000);
          });
        }
      },
      onError: (e) {
        print("Magnetometer error: $e");
      },
      cancelOnError: true,
    );
  }

  Future<void> _requestPermissions() async {
    await Permission.location.request();
  }

  Future<void> _recordData() async {
    setState(() {
      _isSaving = true;
    });

    try {
      // 1. Xin quyền và lấy tọa độ GPS
      var status = await Permission.location.status;
      if (!status.isGranted) {
        status = await Permission.location.request();
        if (!status.isGranted) {
          _showSnackBar("Không có quyền truy cập vị trí.");
          return;
        }
      }

      final LocationData locationData = await _location.getLocation();
      if (locationData.latitude == null || locationData.longitude == null) {
        _showSnackBar("Không thể lấy được vị trí.");
        return;
      }

      // 2. Gói dữ liệu
      final newPoint = SurveyPoint(
        latitude: locationData.latitude!,
        longitude: locationData.longitude!,
        timestamp: DateTime.now(),
        lightIntensity: _lightIntensity,
        motionMagnitude: _motionMagnitude,
        magneticMagnitude: _magneticMagnitude,
      );

      // 3. Lưu vào file
      await _fileService.writeData(newPoint);
      _showSnackBar("Đã ghi dữ liệu thành công!", isError: false);

    } catch (e) {
      _showSnackBar("Lỗi khi ghi dữ liệu: $e");
    } finally {
      if(mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trạm Khảo sát'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSensorDisplay(),
            const SizedBox(height: 30),
            _buildRecordButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorDisplay() {
    return Column(
      children: [
        SensorCard(
          icon: Icons.wb_sunny,
          label: 'Cường độ Ánh sáng',
          value: '${_lightIntensity.toStringAsFixed(1)} lux',
          color: Colors.orange,
        ),
        const SizedBox(height: 16),
        SensorCard(
          icon: Icons.run_circle_outlined,
          label: 'Độ "Năng động"',
          value: '${_motionMagnitude.toStringAsFixed(2)} m/s²',
          color: Colors.red,
        ),
        const SizedBox(height: 16),
        SensorCard(
          icon: Icons.explore,
          label: 'Cường độ Từ trường',
          value: '${_magneticMagnitude.toStringAsFixed(2)} μT',
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildRecordButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: _isSaving
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white,))
            : const Icon(Icons.save),
        label: Text(_isSaving ? 'ĐANG LẤY VỊ TRÍ...' : 'Ghi Dữ liệu tại Điểm này'),
        onPressed: _isSaving ? null : _recordData,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}

// Widget phụ trợ để hiển thị thông tin cảm biến
class SensorCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const SensorCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}