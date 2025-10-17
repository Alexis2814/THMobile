import 'package:flutter/material.dart';
import 'package:schoolyard_heatmap/data_model.dart';
import 'package:schoolyard_heatmap/file_service.dart';
import 'package:intl/intl.dart';

class DataMapScreen extends StatefulWidget {
  const DataMapScreen({super.key});

  @override
  State<DataMapScreen> createState() => _DataMapScreenState();
}

class _DataMapScreenState extends State<DataMapScreen> {
  final FileService _fileService = FileService();
  late Future<List<SurveyPoint>> _dataPointsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _dataPointsFuture = _fileService.readData();
    });
  }

  // Hàm nội suy màu sắc dựa trên giá trị
  Color _getColorForValue(double value, double min, double max, Color startColor, Color endColor) {
    // Chuẩn hóa giá trị về khoảng [0, 1]
    double t = ((value - min) / (max - min)).clamp(0.0, 1.0);
    return Color.lerp(startColor, endColor, t) ?? startColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bản đồ Dữ liệu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Tải lại dữ liệu',
          ),
        ],
      ),
      body: FutureBuilder<List<SurveyPoint>>(
        future: _dataPointsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có dữ liệu nào được ghi.\nHãy qua "Trạm Khảo sát" để bắt đầu!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final dataPoints = snapshot.data!;
          // Sắp xếp để điểm mới nhất lên đầu
          dataPoints.sort((a, b) => b.timestamp.compareTo(a.timestamp));

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: dataPoints.length,
            itemBuilder: (context, index) {
              final point = dataPoints[index];
              return _buildDataCard(point);
            },
          );
        },
      ),
    );
  }

  Widget _buildDataCard(SurveyPoint point) {
    // Định nghĩa dải giá trị min/max để nội suy màu.
    // Bạn có thể điều chỉnh các giá trị này để có kết quả tốt hơn.
    final lightColor = _getColorForValue(point.lightIntensity, 0, 15000, Colors.yellow.shade100, Colors.yellow.shade800);
    final motionColor = _getColorForValue(point.motionMagnitude, 0, 15, Colors.red.shade100, Colors.red.shade900);
    final magneticColor = _getColorForValue(point.magneticMagnitude, 30, 100, Colors.blue.shade100, Colors.blue.shade900);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Điểm lúc: ${DateFormat('HH:mm:ss - dd/MM/yyyy').format(point.timestamp)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'GPS: ${point.latitude.toStringAsFixed(6)}, ${point.longitude.toStringAsFixed(6)}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildVisualIcon(Icons.wb_sunny, lightColor, '${point.lightIntensity.toStringAsFixed(0)} lux'),
                _buildVisualIcon(Icons.directions_walk, motionColor, '${point.motionMagnitude.toStringAsFixed(2)} m/s²'),
                _buildVisualIcon(Icons.compass_calibration, magneticColor, '${point.magneticMagnitude.toStringAsFixed(2)} μT'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualIcon(IconData icon, Color color, String valueText) {
    return Column(
      children: [
        Icon(icon, color: color, size: 36),
        const SizedBox(height: 4),
        Text(valueText, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}