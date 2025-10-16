// lib/models/workout_model.dart

class Workout {
  final String title;
  final String exercises;
  final String minutes;
  final String imageUrl;
  final int currentProgress;
  final int totalProgress;

  Workout({
    required this.title,
    required this.exercises,
    required this.minutes,
    required this.imageUrl,
    required this.currentProgress,
    required this.totalProgress,
  });
}