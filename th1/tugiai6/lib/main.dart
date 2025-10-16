import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GradientButtonScreen(),
    );
  }
}

class GradientButtonScreen extends StatelessWidget {
  const GradientButtonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Gradient Buttons',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: false, // <-- THAY ĐỔI DÒNG NÀY
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Nút 1: Gradient Xanh lá
            GradientButton(
              text: 'Click me 1',
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              onPressed: () {
                print('Button 1 pressed');
              },
            ),
            const SizedBox(height: 20),

            // Nút 2: Gradient Đỏ - Cam
            GradientButton(
              text: 'Click me 2',
              gradient: const LinearGradient(
                colors: [Color(0xFFF44336), Color(0xFFFF9800)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              onPressed: () {
                print('Button 2 pressed');
              },
            ),
            const SizedBox(height: 20),

            // Nút 3: Gradient Xanh dương
            GradientButton(
              text: 'Click me 3',
              gradient: const LinearGradient(
                colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              onPressed: () {
                print('Button 3 pressed');
              },
            ),
            const SizedBox(height: 20),

            // Nút 4: Gradient Đen - Xám
            GradientButton(
              text: 'Click me 4',
              gradient: LinearGradient(
                colors: [Colors.black54, Colors.grey.shade400],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              onPressed: () {
                print('Button 4 pressed');
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Widget tùy chỉnh cho nút gradient
class GradientButton extends StatelessWidget {
  final String text;
  final Gradient gradient;
  final VoidCallback onPressed;

  const GradientButton({
    super.key,
    required this.text,
    required this.gradient,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}