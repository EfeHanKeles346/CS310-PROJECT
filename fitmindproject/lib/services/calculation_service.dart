import 'package:flutter/foundation.dart';
import '../models/user_data.dart';

class CalculationService {
  // Calculate BMR using Mifflin-St Jeor Equation
  static double calculateBMR(UserData user) {
    bool isMale = user.gender == 'Male';
    
    if (isMale) {
      // Erkek: BMR = 10 * kilo_kg + 6.25 * boy_cm - 5 * yaş + 5
      return 10 * user.weight + 6.25 * user.height - 5 * user.age + 5;
    } else {
      // Kadın: BMR = 10 * kilo_kg + 6.25 * boy_cm - 5 * yaş - 161
      return 10 * user.weight + 6.25 * user.height - 5 * user.age - 161;
    }
  }
  
  // Get activity factor based on training experience
  static double getActivityFactor(String trainingExperience) {
    switch (trainingExperience) {
      case 'beginner':
        return 1.375; // Hafif aktif
      case 'intermediate':
        return 1.55;  // Orta aktif
      case 'advanced':
        return 1.725; // Çok aktif
      default:
        return 1.2;   // Sedanter (default)
    }
  }
  
  // Calculate TDEE (Total Daily Energy Expenditure)
  // TDEE = BMR * activityFactor
  static double calculateTDEE(UserData user) {
    double bmr = calculateBMR(user);
    double activityFactor = getActivityFactor(user.trainingExperience);
    return bmr * activityFactor;
  }
  
  // Calculate target calories based on goal
  // Bulk: TDEE + 300
  // Cut: TDEE - 400
  // Maintain: TDEE
  static double calculateTargetCalories(UserData user) {
    double tdee = calculateTDEE(user);
    
    switch (user.primaryGoal) {
      case 'lose_weight': // cut
        return tdee - 400;
      case 'build_muscle': // bulk
        return tdee + 300;
      case 'maintain':
      default:
        return tdee;
    }
  }
  
  // Calculate macros based on standardized formula
  // Protein: 2.0g per kg (all goals)
  // Fat: 0.9g per kg (all goals)
  // Carbs: Remaining calories / 4
  static MacroNutrients calculateMacros(UserData user) {
    double targetCalories = calculateTargetCalories(user);
    
    // Protein: 2.0g per kg bodyweight
    final proteinGrams = 2.0 * user.weight;
    
    // Fat: 0.9g per kg bodyweight
    final fatGrams = 0.9 * user.weight;
    
    // Calculate calories from protein and fat
    final caloriesFromProtein = proteinGrams * 4; // 4 kcal per gram
    final caloriesFromFat = fatGrams * 9; // 9 kcal per gram
    
    // Remaining calories for carbs
    final carbCalories = targetCalories - caloriesFromProtein - caloriesFromFat;
    final carbGrams = carbCalories / 4; // 4 kcal per gram
    
    return MacroNutrients(
      protein: (proteinGrams * 10).round() / 10,
      carbs: (carbGrams * 10).round() / 10,
      fats: (fatGrams * 10).round() / 10,
    );
  }
  
  // Calculate progress percentage to goal weight
  static double calculateProgressPercentage(UserData user) {
    if (user.targetWeight == null || user.targetWeight == 0) return 0;
    
    // Use initialWeight, or fall back to current weight if not set
    double startWeight = user.initialWeight ?? user.weight;
    double currentWeight = user.weight;
    double targetWeight = user.targetWeight!;
    
    debugPrint('CalculationService: Progress calc - Initial: $startWeight, Current: $currentWeight, Target: $targetWeight');
    
    // If already at target
    if (currentWeight == targetWeight) return 100;
    
    // If no initial weight set (first measurement), progress is 0
    if (user.initialWeight == null) {
      debugPrint('CalculationService: No initial weight set, returning 0%');
      return 0;
    }
    
    // Determine direction based on target vs initial weight
    bool isLosingWeight = targetWeight < startWeight;
    
    if (isLosingWeight) {
      // Losing weight: progress = (start - current) / (start - target) * 100
      debugPrint('CalculationService: Losing weight mode');
      if (currentWeight <= targetWeight) {
        debugPrint('CalculationService: Target reached! Returning 100%');
        return 100; // Reached or exceeded target
      }
      if (currentWeight >= startWeight) {
        debugPrint('CalculationService: No progress yet, returning 0%');
        return 0; // No progress yet
      }
      
      double totalToLose = startWeight - targetWeight;
      double lostSoFar = startWeight - currentWeight;
      double progress = (lostSoFar / totalToLose * 100).clamp(0.0, 100.0);
      debugPrint('CalculationService: Progress = ${progress.toStringAsFixed(1)}% (Lost $lostSoFar kg of $totalToLose kg)');
      return progress;
      
    } else if (targetWeight > startWeight) {
      // Gaining weight: progress = (current - start) / (target - start) * 100
      debugPrint('CalculationService: Gaining weight mode');
      if (currentWeight >= targetWeight) {
        debugPrint('CalculationService: Target reached! Returning 100%');
        return 100; // Reached or exceeded target
      }
      if (currentWeight <= startWeight) {
        debugPrint('CalculationService: No progress yet, returning 0%');
        return 0; // No progress yet
      }
      
      double totalToGain = targetWeight - startWeight;
      double gainedSoFar = currentWeight - startWeight;
      double progress = (gainedSoFar / totalToGain * 100).clamp(0.0, 100.0);
      debugPrint('CalculationService: Progress = ${progress.toStringAsFixed(1)}% (Gained $gainedSoFar kg of $totalToGain kg)');
      return progress;
    }
    
    // If target equals start weight, no progress needed
    debugPrint('CalculationService: Target equals start, returning 0%');
    return 0;
  }
  
  // Get workout program recommendation based on experience and goal
  static String getWorkoutProgram(UserData user) {
    if (user.trainingExperience == 'beginner') {
      return '3x/week Full Body';
    } else if (user.trainingExperience == 'intermediate') {
      if (user.primaryGoal == 'build_muscle') {
        return '4-5x/week Upper/Lower Split';
      } else {
        return '4x/week Push/Pull/Legs';
      }
    } else { // advanced
      return '5-6x/week Push/Pull/Legs Split';
    }
  }
}

class MacroNutrients {
  final double protein;
  final double carbs;
  final double fats;
  
  MacroNutrients({
    required this.protein,
    required this.carbs,
    required this.fats,
  });
  
  double get totalCalories => (protein * 4) + (carbs * 4) + (fats * 9);
}