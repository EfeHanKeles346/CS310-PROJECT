import 'package:flutter/material.dart';
import '../models/workout_log_model.dart';
import '../services/firestore_service.dart';

/// Workout Provider using ChangeNotifier
/// Step 3 requirement: Core app data state management with Provider
class WorkoutProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  List<WorkoutLogModel> _workouts = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<WorkoutLogModel> get workouts => _workouts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Listen to real-time workout updates (Step 3 requirement: Real-time updates)
  void listenToWorkouts(String userId) {
    _isLoading = true;
    notifyListeners();

    _firestoreService.getWorkoutLogs(userId).listen(
      (workouts) {
        _workouts = workouts;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners(); // Step 3: React automatically when data changes
      },
      onError: (error) {
        _errorMessage = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Add new workout (Step 3 requirement: CREATE)
  Future<bool> addWorkout(WorkoutLogModel workout) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestoreService.addWorkoutLog(workout);
      // Stream will automatically update the list
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update workout (Step 3 requirement: UPDATE)
  Future<bool> updateWorkout(WorkoutLogModel workout) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestoreService.updateWorkoutLog(workout);
      // Stream will automatically update the list
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete workout (Step 3 requirement: DELETE)
  Future<bool> deleteWorkout(String workoutId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestoreService.deleteWorkoutLog(workoutId);
      // Stream will automatically update the list
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get total workouts count
  int get totalWorkouts => _workouts.length;

  /// Get total calories burned
  int get totalCaloriesBurned {
    return _workouts.fold(0, (sum, workout) => sum + workout.caloriesBurned);
  }

  /// Get total workout duration (minutes)
  int get totalDuration {
    return _workouts.fold(0, (sum, workout) => sum + workout.duration);
  }

  /// Get workouts by date
  List<WorkoutLogModel> getWorkoutsByDate(DateTime date) {
    return _workouts.where((workout) {
      return workout.createdAt.year == date.year &&
          workout.createdAt.month == date.month &&
          workout.createdAt.day == date.day;
    }).toList();
  }

  /// Get workouts for current week
  List<WorkoutLogModel> getThisWeekWorkouts() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    return _workouts.where((workout) {
      return workout.createdAt.isAfter(weekStart) &&
          workout.createdAt.isBefore(weekEnd.add(const Duration(days: 1)));
    }).toList();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Stop listening to updates
  void dispose() {
    super.dispose();
  }
}



