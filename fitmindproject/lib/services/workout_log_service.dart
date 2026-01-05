import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Model for exercise set data
class ExerciseSetLog {
  final int setNumber;
  final double? weight;
  final int? reps;
  final bool completed;

  ExerciseSetLog({
    required this.setNumber,
    this.weight,
    this.reps,
    this.completed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'setNumber': setNumber,
      'weight': weight,
      'reps': reps,
      'completed': completed,
    };
  }

  factory ExerciseSetLog.fromMap(Map<String, dynamic> map) {
    return ExerciseSetLog(
      setNumber: map['setNumber'] ?? 1,
      weight: map['weight']?.toDouble(),
      reps: map['reps']?.toInt(),
      completed: map['completed'] ?? false,
    );
  }
}

// Model for exercise log
class ExerciseLog {
  final String exerciseId;
  final String exerciseName;
  final List<ExerciseSetLog> sets;
  final String? notes;

  ExerciseLog({
    required this.exerciseId,
    required this.exerciseName,
    required this.sets,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'sets': sets.map((s) => s.toMap()).toList(),
      'notes': notes,
    };
  }

  factory ExerciseLog.fromMap(Map<String, dynamic> map) {
    return ExerciseLog(
      exerciseId: map['exerciseId'] ?? '',
      exerciseName: map['exerciseName'] ?? '',
      sets: (map['sets'] as List?)
          ?.map((s) => ExerciseSetLog.fromMap(s as Map<String, dynamic>))
          .toList() ?? [],
      notes: map['notes'],
    );
  }
}

// Model for workout log
class WorkoutLog {
  final String workoutDayId;
  final String workoutName;
  final List<ExerciseLog> exercises;
  final DateTime lastPerformed;

  WorkoutLog({
    required this.workoutDayId,
    required this.workoutName,
    required this.exercises,
    required this.lastPerformed,
  });

  Map<String, dynamic> toMap() {
    return {
      'workoutDayId': workoutDayId,
      'workoutName': workoutName,
      'exercises': exercises.map((e) => e.toMap()).toList(),
      'lastPerformed': lastPerformed.toIso8601String(),
    };
  }

  factory WorkoutLog.fromMap(Map<String, dynamic> map) {
    return WorkoutLog(
      workoutDayId: map['workoutDayId'] ?? '',
      workoutName: map['workoutName'] ?? '',
      exercises: (map['exercises'] as List?)
          ?.map((e) => ExerciseLog.fromMap(e as Map<String, dynamic>))
          .toList() ?? [],
      lastPerformed: DateTime.parse(map['lastPerformed'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class WorkoutLogService extends ChangeNotifier {
  static final WorkoutLogService _instance = WorkoutLogService._internal();
  factory WorkoutLogService() => _instance;
  WorkoutLogService._internal() {
    _loadWorkoutLogs();
  }

  Map<String, WorkoutLog> _workoutLogs = {}; // workoutDayId -> WorkoutLog
  static const String _workoutLogsKey = 'workout_logs';

  // Get log for specific workout
  WorkoutLog? getWorkoutLog(String workoutDayId) {
    return _workoutLogs[workoutDayId];
  }

  // Load all workout logs
  Future<void> _loadWorkoutLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final logsString = prefs.getString(_workoutLogsKey);

      if (logsString != null) {
        final Map<String, dynamic> logsMap = jsonDecode(logsString);
        _workoutLogs = logsMap.map(
          (key, value) => MapEntry(
            key,
            WorkoutLog.fromMap(value as Map<String, dynamic>),
          ),
        );
        debugPrint('WorkoutLogService: Loaded ${_workoutLogs.length} workout logs');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading workout logs: $e');
    }
  }

  // Save workout log
  Future<void> saveWorkoutLog(WorkoutLog log) async {
    _workoutLogs[log.workoutDayId] = log;
    debugPrint('WorkoutLogService: Saving log for ${log.workoutName}');
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final logsMap = _workoutLogs.map(
        (key, value) => MapEntry(key, value.toMap()),
      );
      final logsString = jsonEncode(logsMap);
      await prefs.setString(_workoutLogsKey, logsString);
      debugPrint('WorkoutLogService: Saved successfully');
    } catch (e) {
      debugPrint('Error saving workout log: $e');
    }
  }

  // Clear all logs
  Future<void> clearAllLogs() async {
    _workoutLogs.clear();
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_workoutLogsKey);
    } catch (e) {
      debugPrint('Error clearing workout logs: $e');
    }
  }

  // Refresh logs from storage
  Future<void> refresh() async {
    await _loadWorkoutLogs();
  }
}

