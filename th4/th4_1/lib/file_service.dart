import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:schoolyard_heatmap/data_model.dart';

class FileService {
  static const _fileName = 'schoolyard_map_data.json';

  // Lấy đường dẫn file
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  // Đọc tất cả các điểm dữ liệu từ file
  Future<List<SurveyPoint>> readData() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return [];
      }
      final contents = await file.readAsString();
      final List<dynamic> jsonData = json.decode(contents);
      return jsonData.map((json) => SurveyPoint.fromJson(json)).toList();
    } catch (e) {
      print("Error reading file: $e");
      return [];
    }
  }

  // Ghi một điểm dữ liệu mới vào file
  Future<void> writeData(SurveyPoint point) async {
    try {
      final file = await _localFile;
      // Đọc dữ liệu hiện có
      List<SurveyPoint> existingData = await readData();
      // Thêm điểm mới vào
      existingData.add(point);
      // Chuyển toàn bộ danh sách thành JSON
      final List<Map<String, dynamic>> jsonList =
      existingData.map((p) => p.toJson()).toList();
      // Ghi lại vào file
      await file.writeAsString(json.encode(jsonList));
      print("Data point saved successfully!");
    } catch (e) {
      print("Error writing file: $e");
    }
  }
}