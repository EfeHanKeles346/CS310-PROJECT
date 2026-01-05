import 'package:flutter/material.dart';
import '../models/meal_log_model.dart';
import '../services/firestore_service.dart';

/// Meal Provider using ChangeNotifier
/// Step 3 requirement: Core app data state management with Provider
class MealProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  List<MealLogModel> _meals = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<MealLogModel> get meals => _meals;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Listen to real-time meal updates (Step 3 requirement: Real-time updates)
  void listenToMeals(String userId) {
    _isLoading = true;
    notifyListeners();

    _firestoreService.getMealLogs(userId).listen(
      (meals) {
        _meals = meals;
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

  /// Add new meal (Step 3 requirement: CREATE)
  Future<bool> addMeal(MealLogModel meal) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestoreService.addMealLog(meal);
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

  /// Update meal (Step 3 requirement: UPDATE)
  Future<bool> updateMeal(MealLogModel meal) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestoreService.updateMealLog(meal);
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

  /// Delete meal (Step 3 requirement: DELETE)
  Future<bool> deleteMeal(String mealId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestoreService.deleteMealLog(mealId);
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

  /// Get meals by date
  List<MealLogModel> getMealsByDate(DateTime date) {
    return _meals.where((meal) {
      return meal.createdAt.year == date.year &&
          meal.createdAt.month == date.month &&
          meal.createdAt.day == date.day;
    }).toList();
  }

  /// Get today's total calories
  double getTodayCalories() {
    final today = DateTime.now();
    final todayMeals = getMealsByDate(today);
    return todayMeals.fold(0.0, (sum, meal) => sum + meal.calories);
  }

  /// Get today's macros
  Map<String, double> getTodayMacros() {
    final today = DateTime.now();
    final todayMeals = getMealsByDate(today);
    
    double protein = 0;
    double carbs = 0;
    double fats = 0;

    for (var meal in todayMeals) {
      protein += meal.protein;
      carbs += meal.carbs;
      fats += meal.fats;
    }

    return {
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
    };
  }

  /// Get meals by type (Breakfast, Lunch, Dinner, Snack)
  List<MealLogModel> getMealsByType(String mealType) {
    return _meals.where((meal) => meal.mealType == mealType).toList();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Stop listening to updates
  @override
  void dispose() {
    super.dispose();
  }
}



