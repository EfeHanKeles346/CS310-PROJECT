import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_model.dart';
import '../models/user_data.dart';
import '../services/user_data_service.dart';
import '../services/calculation_service.dart';

class MealTrackingService extends ChangeNotifier {
  static final MealTrackingService _instance = MealTrackingService._internal();
  factory MealTrackingService() => _instance;
  MealTrackingService._internal() {
    _loadMealEntries();
  }
  
  List<MealEntry> _mealEntries = [];
  static const String _mealEntriesKey = 'meal_entries';
  
  List<MealEntry> get mealEntries => _mealEntries;
  
  // Get today's meal entries
  List<MealEntry> getTodayMeals() {
    final today = DateTime.now();
    return _mealEntries.where((entry) => 
      entry.date.year == today.year &&
      entry.date.month == today.month &&
      entry.date.day == today.day
    ).toList();
  }
  
  // Get meals by type for today
  List<MealEntry> getMealsByType(String mealType) {
    final todayMeals = getTodayMeals();
    return todayMeals.where((entry) => entry.mealType == mealType).toList();
  }
  
  // Get total calories for today
  double getTodayCalories() {
    return getTodayMeals().fold(0.0, (sum, entry) => sum + entry.calories);
  }
  
  // Get total macros for today
  MacroNutrients getTodayMacros() {
    final todayMeals = getTodayMeals();
    double protein = todayMeals.fold(0.0, (sum, entry) => sum + entry.protein);
    double carbs = todayMeals.fold(0.0, (sum, entry) => sum + entry.carbs);
    double fats = todayMeals.fold(0.0, (sum, entry) => sum + entry.fats);
    
    return MacroNutrients(
      protein: protein,
      carbs: carbs,
      fats: fats,
    );
  }
  
  // Get target macros from user data
  MacroNutrients? getTargetMacros() {
    final userData = UserDataService().userData;
    if (userData == null) return null;
    return CalculationService.calculateMacros(userData);
  }
  
  // Get target calories from user data
  double? getTargetCalories() {
    final userData = UserDataService().userData;
    if (userData == null) return null;
    return CalculationService.calculateTargetCalories(userData);
  }
  
  // Add meal entry
  Future<void> addMealEntry(MealEntry entry) async {
    _mealEntries.add(entry);
    notifyListeners();
    await _saveMealEntries();
  }
  
  // Remove meal entry
  Future<void> removeMealEntry(String id) async {
    _mealEntries.removeWhere((entry) => entry.id == id);
    notifyListeners();
    await _saveMealEntries();
  }
  
  // Load meal entries from SharedPreferences
  Future<void> _loadMealEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final entriesString = prefs.getString(_mealEntriesKey);
      
      if (entriesString != null) {
        final List<dynamic> entriesList = jsonDecode(entriesString);
        _mealEntries = entriesList.map((e) => MealEntry.fromMap(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading meal entries: $e');
    }
  }
  
  // Save meal entries to SharedPreferences
  Future<void> _saveMealEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final entriesString = jsonEncode(
        _mealEntries.map((e) => e.toMap()).toList()
      );
      await prefs.setString(_mealEntriesKey, entriesString);
    } catch (e) {
      debugPrint('Error saving meal entries: $e');
    }
  }
  
  // Clear all meal entries (for testing)
  Future<void> clearAllEntries() async {
    _mealEntries.clear();
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_mealEntriesKey);
    } catch (e) {
      debugPrint('Error clearing meal entries: $e');
    }
  }
}

