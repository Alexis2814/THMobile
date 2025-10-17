import 'dart:math';

class SurveyPoint {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double lightIntensity; // lux
  final double motionMagnitude; // sqrt(x²+y²+z²)
  final double magneticMagnitude; // microteslas (μT)

  SurveyPoint({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.lightIntensity,
    required this.motionMagnitude,
    required this.magneticMagnitude,
  });

  // Chuyển từ Object sang Map (để encode JSON)
  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'timestamp': timestamp.toIso8601String(),
    'lightIntensity': lightIntensity,
    'motionMagnitude': motionMagnitude,
    'magneticMagnitude': magneticMagnitude,
  };

  // Tạo Object từ Map (để decode JSON)
  factory SurveyPoint.fromJson(Map<String, dynamic> json) {
    return SurveyPoint(
      latitude: json['latitude'],
      longitude: json['longitude'],
      timestamp: DateTime.parse(json['timestamp']),
      lightIntensity: json['lightIntensity'],
      motionMagnitude: json['motionMagnitude'],
      magneticMagnitude: json['magneticMagnitude'],
    );
  }

  // Hàm helper để tính độ lớn vector
  static double calculateMagnitude(double x, double y, double z) {
    return sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2));
  }
}