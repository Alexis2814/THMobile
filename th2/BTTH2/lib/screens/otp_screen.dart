import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpCtrl = TextEditingController();
  String? _error;

  Future<void> _verify() async {
    bool ok = await AuthService.verifyOtp(_otpCtrl.text);
    if (ok) {
      Navigator.pushReplacementNamed(context, '/success');
    } else {
      setState(() => _error = "Mã OTP không đúng");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Xác minh OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _otpCtrl,
              decoration: InputDecoration(
                labelText: "Nhập OTP (123456)",
                errorText: _error,
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verify,
              child: const Text("Xác minh"),
            )
          ],
        ),
      ),
    );
  }
}
