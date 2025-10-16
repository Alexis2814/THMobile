// lib/screens/workouts_screen.dart

import 'package:flutter/material.dart';
import '../models/workout_model.dart'; // Import model
import '../widgets/workout_card.dart'; // Import widget

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  // Dữ liệu giả (mock data)
  final List<Workout> workouts = [
    Workout(
      title: 'Yoga',
      exercises: '3',
      minutes: '12',
      imageUrl: 'assets/images/yoga.jpg', // Thay bằng tên file của bạn
      currentProgress: 0,
      totalProgress: 3,
    ),
    Workout(
      title: 'Pilates',
      exercises: '4',
      minutes: '14',
      imageUrl: 'assets/images/yoga2.jpg', // Thay bằng tên file của bạn
      currentProgress: 0,
      totalProgress: 4,
    ),
    Workout(
      title: 'Full body',
      exercises: '3',
      minutes: '12',
      imageUrl: 'assets/images/yoga3.jpg', // Thay bằng tên file của bạn
      currentProgress: 0,
      totalProgress: 3,
    ),
    Workout(
      title: 'Stretching',
      exercises: '5',
      minutes: '16',
      imageUrl: 'assets/images/yoga4.jpg', // Thay bằng tên file của bạn
      currentProgress: 0,
      totalProgress: 5,
    ),
  ];

  int _selectedIndex = 1; // Mặc định chọn tab 'Workouts'

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Màu nền hơi xám
      appBar: AppBar(
        title: const Text(
          'Workouts',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          return WorkoutCard(workout: workouts[index]);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center), // Icon giống trong ảnh
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple, // Màu của item được chọn
        onTap: _onItemTapped,
      ),
    );
  }
}