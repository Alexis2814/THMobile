import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  DateTime? _dob;
  String? _gender = "Nam";
  bool _agree = false;

  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  OutlineInputBorder normalBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.grey),
  );

  OutlineInputBorder errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.red),
  );

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (!_agree) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Bạn cần đồng ý điều khoản")),
        );
        return;
      }

      await AuthService.register({
        "name": _nameCtrl.text,
        "email": _emailCtrl.text,
        "phone": _phoneCtrl.text,
        "password": _passCtrl.text,
        "dob": _dob,
        "gender": _gender,
      });

      Navigator.pushNamed(context, '/otp');
    } else {
      setState(() {
        _autoValidate = AutovalidateMode.always; // 🔹 bật validate sau khi bấm nút
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Header cố định
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent],
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Đăng Ký Tài Khoản",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Icon(Icons.person_add, color: Colors.white),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Tạo tài khoản để bắt đầu trải nghiệm",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Form scroll bên dưới
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autoValidate,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: InputDecoration(
                          labelText: "Họ & tên",
                          border: normalBorder,
                          focusedBorder: normalBorder,
                          errorBorder: errorBorder,
                        ),
                        validator: (v) =>
                        v == null || v.isEmpty ? "Không được bỏ trống" : null,
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _emailCtrl,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: normalBorder,
                          focusedBorder: normalBorder,
                          errorBorder: errorBorder,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Không được bỏ trống";
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return "Email không hợp lệ";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Số điện thoại",
                          border: normalBorder,
                          focusedBorder: normalBorder,
                          errorBorder: errorBorder,
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Không được bỏ trống";
                          if (!RegExp(r'^[0-9]{10}$').hasMatch(v)) {
                            return "Số điện thoại phải đủ 10 số";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _passCtrl,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Mật khẩu",
                          border: normalBorder,
                          focusedBorder: normalBorder,
                          errorBorder: errorBorder,
                        ),
                        validator: (v) => v != null && v.length >= 6
                            ? null
                            : "Mật khẩu phải > 6 ký tự",
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _confirmCtrl,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Xác nhận mật khẩu",
                          border: normalBorder,
                          focusedBorder: normalBorder,
                          errorBorder: errorBorder,
                        ),
                        validator: (v) =>
                        v == _passCtrl.text ? null : "Mật khẩu không khớp",
                      ),
                      const SizedBox(height: 12),

                      InkWell(
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            initialDate: DateTime(2000),
                          );
                          if (picked != null) {
                            setState(() => _dob = picked);
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: "Ngày sinh",
                            border: normalBorder,
                            suffixIcon: const Icon(Icons.calendar_today, color: Colors.blue),
                          ),
                          child: Text(
                            _dob == null
                                ? "dd/mm/yyyy"
                                : "${_dob!.day}/${_dob!.month}/${_dob!.year}",
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Giới tính"),
                          Row(
                            children: [
                              Radio<String>(
                                value: "Nam",
                                groupValue: _gender,
                                onChanged: (v) => setState(() => _gender = v),
                              ),
                              const Text("Nam"),
                              Radio<String>(
                                value: "Nữ",
                                groupValue: _gender,
                                onChanged: (v) => setState(() => _gender = v),
                              ),
                              const Text("Nữ"),
                              Radio<String>(
                                value: "Khác",
                                groupValue: _gender,
                                onChanged: (v) => setState(() => _gender = v),
                              ),
                              const Text("Khác"),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text("Tôi đồng ý với điều khoản sử dụng"),
                        value: _agree,
                        onChanged: (v) => setState(() => _agree = v ?? false),
                      ),
                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text("Đăng Ký", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
