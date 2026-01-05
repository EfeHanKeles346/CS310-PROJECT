import 'package:cloud_firestore/cloud_firestore.dart';

/// Workout Log model for storing completed workouts
/// Step 3 requirement: id, createdBy, createdAt fields + app-specific fields
class WorkoutLogModel {
  final String id;
  final String workoutName;
  final String workoutType; // e.g., "Cardio", "Strength", "Flexibility"
  final int duration; // minutes
  final int caloriesBurned;
  final String createdBy; // user ID (Step 3 requirement)
  final DateTime createdAt; // timestamp (Step 3 requirement)
  final String? notes;
  final List<ExerciseLog>? exercises;

  WorkoutLogModel({
    required this.id,
    required this.workoutName,
    required this.workoutType,
    required this.duration,
    required this.caloriesBurned,
    required this.createdBy,
    required this.createdAt,
    this.notes,
    this.exercises,
  });

  /// Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workoutName': workoutName,
      'workoutType': workoutType,
      'duration': duration,
      'caloriesBurned': caloriesBurned,
      'createdBy': createdBy, // Step 3 requirement
      'createdAt': Timestamp.fromDate(createdAt), // Step 3 requirement
      'notes': notes,
      'exercises': exercises?.map((e) => e.toMap()).toList(),
    };
  }

  /// Create from Firestore Map
  factory WorkoutLogModel.fromMap(Map<String, dynamic> map) {
    return WorkoutLogModel(
      id: map['id'] ?? '',
      workoutName: map['workoutName'] ?? '',
      workoutType: map['workoutType'] ?? '',
      duration: map['duration'] ?? 0,
      caloriesBurned: map['caloriesBurned'] ?? 0,
      createdBy: map['createdBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      notes: map['notes'],
      exercises: (map['exercises'] as List?)
          ?.map((e) => ExerciseLog.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Create from Firestore DocumentSnapshot
  factory WorkoutLogModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WorkoutLogModel.fromMap(data);
  }

  WorkoutLogModel copyWith({
    String? id,
    String? workoutName,
    String? workoutType,
    int? duration,
    int? caloriesBurned,
    String? createdBy,
    DateTime? createdAt,
    String? notes,
    List<ExerciseLog>? exercises,
  }) {
    return WorkoutLogModel(
      id: id ?? this.id,
      workoutName: workoutName ?? this.workoutName,
      workoutType: workoutType ?? this.workoutType,
      duration: duration ?? this.duration,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
      exercises: exercises ?? this.exercises,
    );
  }
}

/// Individual exercise within a workout
class ExerciseLog {
  final String exerciseName;
  final int sets;
  final int reps;
  final double? weight; // kg

  ExerciseLog({
    required this.exerciseName,
    required this.sets,
    required this.reps,
    this.weight,
  });

  Map<String, dynamic> toMap() {
    return {
      'exerciseName': exerciseName,
      'sets': sets,
      'reps': reps,
      'weight': weight,
    };
  }

  factory ExerciseLog.fromMap(Map<String, dynamic> map) {
    return ExerciseLog(
      exerciseName: map['exerciseName'] ?? '',
      sets: map['sets'] ?? 0,
      reps: map['reps'] ?? 0,
      weight: map['weight']?.toDouble(),
    );
  }
}



