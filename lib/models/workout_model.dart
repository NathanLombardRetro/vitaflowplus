class Workout {
  final DateTime date;
  final List<String> exercises;
  final String timeTrained;
  final String userId;
  final String workoutDescription;
  final String workoutName;

  Workout({
    required this.date,
    required this.exercises,
    required this.timeTrained,
    required this.userId,
    required this.workoutDescription,
    required this.workoutName,
  });
}