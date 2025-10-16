// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/workouts_screen.dart'; // Import màn hình workouts

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Roboto', // Bạn có thể thêm font tùy chỉnh nếu muốn
      ),
      home: const WorkoutsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}