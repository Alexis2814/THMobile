class AuthService {
  // Giả lập lưu dữ liệu local
  static Map<String, dynamic> userData = {};

  static Future<bool> register(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 500));
    userData = data;
    return true;
  }

  static Future<bool> verifyOtp(String otp) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return otp == "123456";
  }
}
