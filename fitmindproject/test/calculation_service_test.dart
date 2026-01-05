import 'package:flutter_test/flutter_test.dart';
import 'package:fitmind_app/services/calculation_service.dart';
import 'package:fitmind_app/models/user_data.dart';

/// Unit Tests for CalculationService
/// Tests BMR calculation, TDEE calculation, macro calculations, and progress tracking
void main() {
  group('CalculationService', () {
    // Test user data for male
    late UserData maleUser;
    // Test user data for female
    late UserData femaleUser;

    setUp(() {
      // Setup test data before each test
      maleUser = UserData(
        name: 'Test User',
        age: 25,
        height: 180, // cm
        weight: 80, // kg
        gender: 'Male',
        primaryGoal: 'build_muscle',
        trainingExperience: 'intermediate',
      );

      femaleUser = UserData(
        name: 'Test User',
        age: 25,
        height: 165, // cm
        weight: 60, // kg
        gender: 'Female',
        primaryGoal: 'lose_weight',
        trainingExperience: 'beginner',
      );
    });

    group('BMR Calculation', () {
      test('should calculate BMR correctly for male user', () {
        // Male BMR = 10 * weight + 6.25 * height - 5 * age + 5
        // = 10 * 80 + 6.25 * 180 - 5 * 25 + 5
        // = 800 + 1125 - 125 + 5 = 1805
        final bmr = CalculationService.calculateBMR(maleUser);
        expect(bmr, equals(1805.0));
      });

      test('should calculate BMR correctly for female user', () {
        // Female BMR = 10 * weight + 6.25 * height - 5 * age - 161
        // = 10 * 60 + 6.25 * 165 - 5 * 25 - 161
        // = 600 + 1031.25 - 125 - 161 = 1345.25
        final bmr = CalculationService.calculateBMR(femaleUser);
        expect(bmr, equals(1345.25));
      });
    });

    group('Activity Factor', () {
      test('should return correct factor for beginner', () {
        final factor = CalculationService.getActivityFactor('beginner');
        expect(factor, equals(1.375));
      });

      test('should return correct factor for intermediate', () {
        final factor = CalculationService.getActivityFactor('intermediate');
        expect(factor, equals(1.55));
      });

      test('should return correct factor for advanced', () {
        final factor = CalculationService.getActivityFactor('advanced');
        expect(factor, equals(1.725));
      });

      test('should return default factor for unknown experience', () {
        final factor = CalculationService.getActivityFactor('unknown');
        expect(factor, equals(1.2));
      });
    });

    group('TDEE Calculation', () {
      test('should calculate TDEE correctly for intermediate male', () {
        // TDEE = BMR * activityFactor = 1805 * 1.55 = 2797.75
        final tdee = CalculationService.calculateTDEE(maleUser);
        expect(tdee, equals(2797.75));
      });

      test('should calculate TDEE correctly for beginner female', () {
        // TDEE = BMR * activityFactor = 1345.25 * 1.375 = 1849.71875
        final tdee = CalculationService.calculateTDEE(femaleUser);
        expect(tdee, closeTo(1849.72, 0.01));
      });
    });

    group('Target Calories', () {
      test('should add 300 calories for muscle building goal', () {
        // TDEE = 2797.75, Target = 2797.75 + 300 = 3097.75
        final targetCalories = CalculationService.calculateTargetCalories(maleUser);
        expect(targetCalories, equals(3097.75));
      });

      test('should subtract 400 calories for weight loss goal', () {
        // TDEE = 1849.71875, Target = 1849.71875 - 400 = 1449.71875
        final targetCalories = CalculationService.calculateTargetCalories(femaleUser);
        expect(targetCalories, closeTo(1449.72, 0.01));
      });

      test('should maintain TDEE for maintenance goal', () {
        final maintainUser = maleUser.copyWith(primaryGoal: 'maintain');
        final targetCalories = CalculationService.calculateTargetCalories(maintainUser);
        expect(targetCalories, equals(2797.75)); // Same as TDEE
      });
    });

    group('Macro Calculation', () {
      test('should calculate protein as 2g per kg bodyweight', () {
        final macros = CalculationService.calculateMacros(maleUser);
        // Protein = 2.0 * 80 = 160g
        expect(macros.protein, equals(160.0));
      });

      test('should calculate fat as 0.9g per kg bodyweight', () {
        final macros = CalculationService.calculateMacros(maleUser);
        // Fat = 0.9 * 80 = 72g
        expect(macros.fats, equals(72.0));
      });

      test('should calculate carbs from remaining calories', () {
        final macros = CalculationService.calculateMacros(maleUser);
        // Target calories = 3097.75
        // Protein calories = 160 * 4 = 640
        // Fat calories = 72 * 9 = 648
        // Remaining = 3097.75 - 640 - 648 = 1809.75
        // Carbs = 1809.75 / 4 = 452.4375 ≈ 452.4
        expect(macros.carbs, closeTo(452.4, 0.1));
      });
    });

    group('Progress Calculation', () {
      test('should return 0 when no initial weight is set', () {
        final user = maleUser.copyWith(targetWeight: 75.0);
        final progress = CalculationService.calculateProgressPercentage(user);
        expect(progress, equals(0.0));
      });

      test('should return 100 when current weight equals target', () {
        final user = maleUser.copyWith(
          initialWeight: 85.0,
          weight: 75.0,
          targetWeight: 75.0,
        );
        final progress = CalculationService.calculateProgressPercentage(user);
        expect(progress, equals(100.0));
      });

      test('should calculate correct progress for weight loss', () {
        // Start: 85kg, Current: 80kg, Target: 75kg
        // Lost 5kg out of 10kg = 50%
        final user = maleUser.copyWith(
          initialWeight: 85.0,
          weight: 80.0,
          targetWeight: 75.0,
        );
        final progress = CalculationService.calculateProgressPercentage(user);
        expect(progress, equals(50.0));
      });

      test('should calculate correct progress for weight gain', () {
        // Start: 70kg, Current: 75kg, Target: 80kg
        // Gained 5kg out of 10kg = 50%
        final user = maleUser.copyWith(
          initialWeight: 70.0,
          weight: 75.0,
          targetWeight: 80.0,
        );
        final progress = CalculationService.calculateProgressPercentage(user);
        expect(progress, equals(50.0));
      });
    });

    group('Workout Program Recommendation', () {
      test('should recommend full body for beginners', () {
        final user = maleUser.copyWith(trainingExperience: 'beginner');
        final program = CalculationService.getWorkoutProgram(user);
        expect(program, equals('3x/week Full Body'));
      });

      test('should recommend upper/lower split for intermediate with muscle goal', () {
        final user = maleUser.copyWith(
          trainingExperience: 'intermediate',
          primaryGoal: 'build_muscle',
        );
        final program = CalculationService.getWorkoutProgram(user);
        expect(program, equals('4-5x/week Upper/Lower Split'));
      });

      test('should recommend PPL for advanced users', () {
        final user = maleUser.copyWith(trainingExperience: 'advanced');
        final program = CalculationService.getWorkoutProgram(user);
        expect(program, equals('5-6x/week Push/Pull/Legs Split'));
      });
    });
  });
}

