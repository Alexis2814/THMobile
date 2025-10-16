// lib/widgets/workout_card.dart

import 'package:flutter/material.dart';
import '../models/workout_model.dart'; // Import model

class WorkoutCard extends StatelessWidget {
  final Workout workout;

  const WorkoutCard({Key? key, required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Phần thông tin bên trái
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '${workout.exercises} Exercises',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${workout.minutes} Minutes',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: workout.currentProgress / workout.totalProgress,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text('${workout.currentProgress}/${workout.totalProgress}'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            // Phần hình ảnh bên phải
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                workout.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}