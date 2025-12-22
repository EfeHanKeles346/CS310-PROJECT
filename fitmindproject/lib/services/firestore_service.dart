import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout_log_model.dart';
import '../models/meal_log_model.dart';
import '../models/measurement_model.dart';

/// Firestore Service for CRUD operations
/// Step 3 requirement: Full CRUD operations with real-time updates
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== WORKOUT LOGS ====================

  /// Create workout log (Step 3: CREATE requirement)
  Future<void> addWorkoutLog(WorkoutLogModel workout) async {
    try {
      await _firestore
          .collection('workout_logs')
          .doc(workout.id)
          .set(workout.toMap());
    } catch (e) {
      throw 'Failed to add workout: $e';
    }
  }

  /// Read workout logs with real-time updates (Step 3: READ + Real-time requirement)
  Stream<List<WorkoutLogModel>> getWorkoutLogs(String userId) {
    // Note: Using client-side sorting to avoid index requirement
    return _firestore
        .collection('workout_logs')
        .where('createdBy', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final workouts = snapshot.docs
          .map((doc) => WorkoutLogModel.fromMap(doc.data()))
          .toList();
      // Sort client-side by createdAt descending
      workouts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return workouts;
    });
  }

  /// Get single workout log
  Future<WorkoutLogModel?> getWorkoutLog(String workoutId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('workout_logs').doc(workoutId).get();
      if (doc.exists) {
        return WorkoutLogModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      throw 'Failed to get workout: $e';
    }
    return null;
  }

  /// Update workout log (Step 3: UPDATE requirement)
  Future<void> updateWorkoutLog(WorkoutLogModel workout) async {
    try {
      await _firestore
          .collection('workout_logs')
          .doc(workout.id)
          .update(workout.toMap());
    } catch (e) {
      throw 'Failed to update workout: $e';
    }
  }

  /// Delete workout log (Step 3: DELETE requirement)
  Future<void> deleteWorkoutLog(String workoutId) async {
    try {
      await _firestore.collection('workout_logs').doc(workoutId).delete();
    } catch (e) {
      throw 'Failed to delete workout: $e';
    }
  }

  // ==================== MEAL LOGS ====================

  /// Create meal log (Step 3: CREATE requirement)
  Future<void> addMealLog(MealLogModel meal) async {
    try {
      await _firestore
          .collection('meal_logs')
          .doc(meal.id)
          .set(meal.toMap());
    } catch (e) {
      throw 'Failed to add meal: $e';
    }
  }

  /// Read meal logs with real-time updates (Step 3: READ + Real-time requirement)
  Stream<List<MealLogModel>> getMealLogs(String userId) {
    // Note: Using client-side sorting to avoid index requirement
    return _firestore
        .collection('meal_logs')
        .where('createdBy', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final meals = snapshot.docs
          .map((doc) => MealLogModel.fromMap(doc.data()))
          .toList();
      // Sort client-side by createdAt descending
      meals.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return meals;
    });
  }

  /// Get meals for a specific date
  Stream<List<MealLogModel>> getMealLogsByDate(String userId, DateTime date) {
    DateTime startOfDay = DateTime(date.year, date.month, date.day);
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    // Note: Using client-side filtering to avoid complex index requirement
    return _firestore
        .collection('meal_logs')
        .where('createdBy', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final allMeals = snapshot.docs
          .map((doc) => MealLogModel.fromMap(doc.data()))
          .toList();
      // Filter by date client-side
      final filteredMeals = allMeals.where((meal) =>
          meal.createdAt.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
          meal.createdAt.isBefore(endOfDay.add(const Duration(seconds: 1)))).toList();
      // Sort by createdAt ascending
      filteredMeals.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return filteredMeals;
    });
  }

  /// Update meal log (Step 3: UPDATE requirement)
  Future<void> updateMealLog(MealLogModel meal) async {
    try {
      await _firestore
          .collection('meal_logs')
          .doc(meal.id)
          .update(meal.toMap());
    } catch (e) {
      throw 'Failed to update meal: $e';
    }
  }

  /// Delete meal log (Step 3: DELETE requirement)
  Future<void> deleteMealLog(String mealId) async {
    try {
      await _firestore.collection('meal_logs').doc(mealId).delete();
    } catch (e) {
      throw 'Failed to delete meal: $e';
    }
  }

  // ==================== MEASUREMENTS ====================

  /// Create measurement (Step 3: CREATE requirement)
  Future<void> addMeasurement(MeasurementModel measurement) async {
    try {
      await _firestore
          .collection('measurements')
          .doc(measurement.id)
          .set(measurement.toMap());
    } catch (e) {
      throw 'Failed to add measurement: $e';
    }
  }

  /// Read measurements with real-time updates (Step 3: READ + Real-time requirement)
  Stream<List<MeasurementModel>> getMeasurements(String userId) {
    // Note: Using client-side sorting to avoid index requirement
    // For production, create composite index: createdBy (ASC) + createdAt (DESC)
    return _firestore
        .collection('measurements')
        .where('createdBy', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final measurements = snapshot.docs
          .map((doc) => MeasurementModel.fromMap(doc.data()))
          .toList();
      // Sort client-side by createdAt descending
      measurements.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return measurements;
    });
  }

  /// Get latest measurement
  Future<MeasurementModel?> getLatestMeasurement(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('measurements')
          .where('createdBy', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return MeasurementModel.fromMap(
            snapshot.docs.first.data() as Map<String, dynamic>);
      }
    } catch (e) {
      throw 'Failed to get latest measurement: $e';
    }
    return null;
  }

  /// Update measurement (Step 3: UPDATE requirement)
  Future<void> updateMeasurement(MeasurementModel measurement) async {
    try {
      await _firestore
          .collection('measurements')
          .doc(measurement.id)
          .update(measurement.toMap());
    } catch (e) {
      throw 'Failed to update measurement: $e';
    }
  }

  /// Delete measurement (Step 3: DELETE requirement)
  Future<void> deleteMeasurement(String measurementId) async {
    try {
      await _firestore.collection('measurements').doc(measurementId).delete();
    } catch (e) {
      throw 'Failed to delete measurement: $e';
    }
  }

  // ==================== STATISTICS ====================

  /// Get total workouts count
  Future<int> getTotalWorkoutsCount(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('workout_logs')
          .where('createdBy', isEqualTo: userId)
          .get();
      return snapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  /// Get total calories burned
  Future<int> getTotalCaloriesBurned(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('workout_logs')
          .where('createdBy', isEqualTo: userId)
          .get();

      int total = 0;
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        total += (data['caloriesBurned'] ?? 0) as int;
      }
      return total;
    } catch (e) {
      return 0;
    }
  }

  /// Get workouts for date range
  Future<List<WorkoutLogModel>> getWorkoutsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('workout_logs')
          .where('createdBy', isEqualTo: userId)
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => WorkoutLogModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw 'Failed to get workouts by date range: $e';
    }
  }

  /// Delete all user data (for account deletion)
  Future<void> deleteAllUserData(String userId) async {
    try {
      // Delete all workout logs
      final workouts = await _firestore
          .collection('workout_logs')
          .where('createdBy', isEqualTo: userId)
          .get();
      for (var doc in workouts.docs) {
        await doc.reference.delete();
      }

      // Delete all meal logs
      final meals = await _firestore
          .collection('meal_logs')
          .where('createdBy', isEqualTo: userId)
          .get();
      for (var doc in meals.docs) {
        await doc.reference.delete();
      }

      // Delete all measurements
      final measurements = await _firestore
          .collection('measurements')
          .where('createdBy', isEqualTo: userId)
          .get();
      for (var doc in measurements.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw 'Failed to delete user data: $e';
    }
  }
}



