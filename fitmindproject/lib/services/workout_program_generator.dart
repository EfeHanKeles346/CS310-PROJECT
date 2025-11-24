import '../models/user_data.dart';
import '../models/workout_program_model.dart';
import '../models/exercise_model.dart';

class WorkoutProgramGenerator {
  // Generate personalized workout program based on user data
  static WorkoutProgram generateProgram(UserData user) {
    // Determine training split
    String trainingSplit = _getTrainingSplit(user.trainingExperience, user.primaryGoal);
    int daysPerWeek = _getDaysPerWeek(user.trainingExperience);
    String goalFocus = _getGoalFocus(user.primaryGoal);
    
    // Generate workout days
    List<WorkoutDay> workoutDays = _generateWorkoutDays(
      user,
      trainingSplit,
      daysPerWeek,
    );
    
    // Generate weekly progression
    Map<int, String> weeklyProgression = _generateWeeklyProgression(user.primaryGoal);
    
    return WorkoutProgram(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      trainingSplit: trainingSplit,
      daysPerWeek: daysPerWeek,
      goalFocus: goalFocus,
      workoutDays: workoutDays,
      weeklyProgression: weeklyProgression,
    );
  }
  
  static String _getTrainingSplit(String experience, String goal) {
    switch (experience) {
      case 'beginner':
        return 'Full Body';
      case 'intermediate':
        if (goal == 'build_muscle') {
          return 'Upper/Lower Split';
        }
        return 'Push/Pull/Legs';
      case 'advanced':
        return 'Push/Pull/Legs Split';
      default:
        return 'Full Body';
    }
  }
  
  static int _getDaysPerWeek(String experience) {
    switch (experience) {
      case 'beginner':
        return 3;
      case 'intermediate':
        return 4;
      case 'advanced':
        return 5;
      default:
        return 3;
    }
  }
  
  static String _getGoalFocus(String goal) {
    switch (goal) {
      case 'build_muscle':
        return 'Hypertrophy & Volume';
      case 'lose_weight':
        return 'Fat Loss & Metabolic Training';
      case 'maintain':
        return 'Maintenance & Sustainability';
      default:
        return 'General Fitness';
    }
  }
  
  static List<WorkoutDay> _generateWorkoutDays(
    UserData user,
    String split,
    int daysPerWeek,
  ) {
    List<WorkoutDay> days = [];
    
    if (split == 'Full Body') {
      days = _generateFullBodyDays(user, daysPerWeek);
    } else if (split == 'Upper/Lower Split') {
      days = _generateUpperLowerDays(user);
    } else if (split == 'Push/Pull/Legs' || split == 'Push/Pull/Legs Split') {
      days = _generatePPLDays(user, daysPerWeek);
    }
    
    return days;
  }
  
  static List<WorkoutDay> _generateFullBodyDays(UserData user, int daysPerWeek) {
    bool isFemale = user.gender == 'Female';
    bool isLoseWeight = user.primaryGoal == 'lose_weight';
    
    List<Exercise> exercises = [
      // Compound movements
      Exercise(
        id: '1',
        name: isFemale && !isLoseWeight ? 'Barbell Squats' : 'Goblet Squats',
        sets: isLoseWeight ? 3 : 4,
        reps: isLoseWeight ? '12-15' : '8-10',
        restSeconds: isLoseWeight ? 60 : 90,
        rpe: isLoseWeight ? '7-8' : '8-9',
        muscleGroup: 'Legs',
        notes: 'Focus on depth and form',
      ),
      Exercise(
        id: '2',
        name: isFemale ? 'Romanian Deadlifts' : 'Deadlifts',
        sets: 3,
        reps: isLoseWeight ? '10-12' : '6-8',
        restSeconds: isLoseWeight ? 60 : 120,
        rpe: '8-9',
        muscleGroup: 'Back',
      ),
      Exercise(
        id: '3',
        name: 'Bench Press',
        sets: 3,
        reps: isLoseWeight ? '10-12' : '8-10',
        restSeconds: 90,
        rpe: '8-9',
        muscleGroup: 'Chest',
      ),
      Exercise(
        id: '4',
        name: 'Barbell Rows',
        sets: 3,
        reps: isLoseWeight ? '12-15' : '8-10',
        restSeconds: 90,
        rpe: '8-9',
        muscleGroup: 'Back',
      ),
      Exercise(
        id: '5',
        name: 'Overhead Press',
        sets: 3,
        reps: isLoseWeight ? '10-12' : '8-10',
        restSeconds: 90,
        rpe: '7-8',
        muscleGroup: 'Shoulders',
      ),
      if (isFemale && !isLoseWeight)
        Exercise(
          id: '6',
          name: 'Hip Thrusts',
          sets: 4,
          reps: '10-12',
          restSeconds: 90,
          rpe: '8-9',
          muscleGroup: 'Glutes',
          notes: 'Focus on glute activation',
        ),
      if (isLoseWeight)
        Exercise(
          id: '6',
          name: 'Burpees',
          sets: 3,
          reps: '10-12',
          restSeconds: 45,
          rpe: '7-8',
          muscleGroup: 'Full Body',
        ),
    ];
    
    List<String> dayNames = ['Monday', 'Wednesday', 'Friday'];
    if (daysPerWeek == 4) {
      dayNames.add('Saturday');
    }
    
    return dayNames.asMap().entries.map((entry) {
      return WorkoutDay(
        id: 'day_${entry.key + 1}',
        name: 'Full Body',
        exercises: exercises,
        estimatedDuration: _calculateDuration(exercises),
        dayOfWeek: entry.value,
      );
    }).toList();
  }
  
  static List<WorkoutDay> _generateUpperLowerDays(UserData user) {
    bool isLoseWeight = user.primaryGoal == 'lose_weight';
    
    // Upper Body Day
    List<Exercise> upperExercises = [
      Exercise(
        id: '1',
        name: 'Bench Press',
        sets: isLoseWeight ? 3 : 4,
        reps: isLoseWeight ? '10-12' : '6-8',
        restSeconds: 90,
        rpe: '8-9',
        muscleGroup: 'Chest',
      ),
      Exercise(
        id: '2',
        name: 'Barbell Rows',
        sets: isLoseWeight ? 3 : 4,
        reps: isLoseWeight ? '12-15' : '8-10',
        restSeconds: 90,
        rpe: '8-9',
        muscleGroup: 'Back',
      ),
      Exercise(
        id: '3',
        name: 'Overhead Press',
        sets: 3,
        reps: isLoseWeight ? '10-12' : '8-10',
        restSeconds: 90,
        rpe: '8-9',
        muscleGroup: 'Shoulders',
      ),
      Exercise(
        id: '4',
        name: 'Pull-Ups / Lat Pulldowns',
        sets: 3,
        reps: isLoseWeight ? '10-12' : '8-10',
        restSeconds: 90,
        rpe: '7-8',
        muscleGroup: 'Back',
      ),
      Exercise(
        id: '5',
        name: 'Tricep Dips',
        sets: 3,
        reps: isLoseWeight ? '12-15' : '8-10',
        restSeconds: 60,
        rpe: '7-8',
        muscleGroup: 'Triceps',
      ),
      Exercise(
        id: '6',
        name: 'Bicep Curls',
        sets: 3,
        reps: isLoseWeight ? '12-15' : '10-12',
        restSeconds: 60,
        rpe: '7-8',
        muscleGroup: 'Biceps',
      ),
    ];
    
    // Lower Body Day
    List<Exercise> lowerExercises = [
      Exercise(
        id: '1',
        name: 'Barbell Squats',
        sets: isLoseWeight ? 3 : 4,
        reps: isLoseWeight ? '12-15' : '6-8',
        restSeconds: isLoseWeight ? 60 : 120,
        rpe: '8-9',
        muscleGroup: 'Legs',
      ),
      Exercise(
        id: '2',
        name: 'Romanian Deadlifts',
        sets: isLoseWeight ? 3 : 4,
        reps: isLoseWeight ? '10-12' : '6-8',
        restSeconds: isLoseWeight ? 60 : 120,
        rpe: '8-9',
        muscleGroup: 'Hamstrings',
      ),
      Exercise(
        id: '3',
        name: 'Leg Press',
        sets: 3,
        reps: isLoseWeight ? '15-20' : '10-12',
        restSeconds: 90,
        rpe: '7-8',
        muscleGroup: 'Legs',
      ),
      Exercise(
        id: '4',
        name: 'Walking Lunges',
        sets: 3,
        reps: isLoseWeight ? '12-15 each' : '10-12 each',
        restSeconds: 60,
        rpe: '7-8',
        muscleGroup: 'Legs',
      ),
      Exercise(
        id: '5',
        name: 'Leg Curls',
        sets: 3,
        reps: isLoseWeight ? '12-15' : '10-12',
        restSeconds: 60,
        rpe: '7-8',
        muscleGroup: 'Hamstrings',
      ),
      Exercise(
        id: '6',
        name: 'Calf Raises',
        sets: 3,
        reps: '15-20',
        restSeconds: 45,
        rpe: '7-8',
        muscleGroup: 'Calves',
      ),
    ];
    
    return [
      WorkoutDay(
        id: 'upper_1',
        name: 'Upper Body',
        exercises: upperExercises,
        estimatedDuration: _calculateDuration(upperExercises),
        dayOfWeek: 'Monday',
      ),
      WorkoutDay(
        id: 'lower_1',
        name: 'Lower Body',
        exercises: lowerExercises,
        estimatedDuration: _calculateDuration(lowerExercises),
        dayOfWeek: 'Tuesday',
      ),
      WorkoutDay(
        id: 'upper_2',
        name: 'Upper Body',
        exercises: upperExercises,
        estimatedDuration: _calculateDuration(upperExercises),
        dayOfWeek: 'Thursday',
      ),
      WorkoutDay(
        id: 'lower_2',
        name: 'Lower Body',
        exercises: lowerExercises,
        estimatedDuration: _calculateDuration(lowerExercises),
        dayOfWeek: 'Friday',
      ),
    ];
  }
  
  static List<WorkoutDay> _generatePPLDays(UserData user, int daysPerWeek) {
    bool isLoseWeight = user.primaryGoal == 'lose_weight';
    
    // Push Day
    List<Exercise> pushExercises = [
      Exercise(
        id: '1',
        name: 'Bench Press',
        sets: isLoseWeight ? 3 : 4,
        reps: isLoseWeight ? '10-12' : '6-8',
        restSeconds: 90,
        rpe: '8-9',
        muscleGroup: 'Chest',
      ),
      Exercise(
        id: '2',
        name: 'Overhead Press',
        sets: 3,
        reps: isLoseWeight ? '10-12' : '8-10',
        restSeconds: 90,
        rpe: '8-9',
        muscleGroup: 'Shoulders',
      ),
      Exercise(
        id: '3',
        name: 'Incline Dumbbell Press',
        sets: 3,
        reps: isLoseWeight ? '12-15' : '8-10',
        restSeconds: 90,
        rpe: '8-9',
        muscleGroup: 'Chest',
      ),
      Exercise(
        id: '4',
        name: 'Lateral Raises',
        sets: 3,
        reps: isLoseWeight ? '12-15' : '10-12',
        restSeconds: 60,
        rpe: '7-8',
        muscleGroup: 'Shoulders',
      ),
      Exercise(
        id: '5',
        name: 'Tricep Dips',
        sets: 3,
        reps: isLoseWeight ? '12-15' : '8-10',
        restSeconds: 60,
        rpe: '7-8',
        muscleGroup: 'Triceps',
      ),
      Exercise(
        id: '6',
        name: 'Overhead Tricep Extension',
        sets: 3,
        reps: isLoseWeight ? '12-15' : '10-12',
        restSeconds: 60,
        rpe: '7-8',
        muscleGroup: 'Triceps',
      ),
    ];
    
    // Pull Day
    List<Exercise> pullExercises = [
      Exercise(
        id: '1',
        name: 'Deadlifts',
        sets: isLoseWeight ? 3 : 4,
        reps: isLoseWeight ? '8-10' : '5-6',
        restSeconds: isLoseWeight ? 90 : 120,
        rpe: '8-9',
        muscleGroup: 'Back',
      ),
      Exercise(
        id: '2',
        name: 'Pull-Ups / Lat Pulldowns',
        sets: 4,
        reps: isLoseWeight ? '10-12' : '8-10',
        restSeconds: 90,
        rpe: '8-9',
        muscleGroup: 'Back',
      ),
      Exercise(
        id: '3',
        name: 'Barbell Rows',
        sets: 3,
        reps: isLoseWeight ? '12-15' : '8-10',
        restSeconds: 90,
        rpe: '8-9',
        muscleGroup: 'Back',
      ),
      Exercise(
        id: '4',
        name: 'Face Pulls',
        sets: 3,
        reps: isLoseWeight ? '12-15' : '12-15',
        restSeconds: 60,
        rpe: '7-8',
        muscleGroup: 'Rear Delts',
      ),
      Exercise(
        id: '5',
        name: 'Barbell Curls',
        sets: 3,
        reps: isLoseWeight ? '12-15' : '10-12',
        restSeconds: 60,
        rpe: '7-8',
        muscleGroup: 'Biceps',
      ),
      Exercise(
        id: '6',
        name: 'Hammer Curls',
        sets: 3,
        reps: isLoseWeight ? '12-15' : '10-12',
        restSeconds: 60,
        rpe: '7-8',
        muscleGroup: 'Biceps',
      ),
    ];
    
    // Legs Day
    List<Exercise> legExercises = [
      Exercise(
        id: '1',
        name: 'Barbell Squats',
        sets: isLoseWeight ? 3 : 5,
        reps: isLoseWeight ? '12-15' : '6-8',
        restSeconds: isLoseWeight ? 60 : 120,
        rpe: '8-9',
        muscleGroup: 'Legs',
      ),
      Exercise(
        id: '2',
        name: 'Romanian Deadlifts',
        sets: isLoseWeight ? 3 : 4,
        reps: isLoseWeight ? '10-12' : '6-8',
        restSeconds: isLoseWeight ? 90 : 120,
        rpe: '8-9',
        muscleGroup: 'Hamstrings',
      ),
      Exercise(
        id: '3',
        name: 'Leg Press',
        sets: 3,
        reps: isLoseWeight ? '15-20' : '10-12',
        restSeconds: 90,
        rpe: '7-8',
        muscleGroup: 'Legs',
      ),
      Exercise(
        id: '4',
        name: 'Walking Lunges',
        sets: 3,
        reps: isLoseWeight ? '12-15 each' : '10-12 each',
        restSeconds: 60,
        rpe: '7-8',
        muscleGroup: 'Legs',
      ),
      Exercise(
        id: '5',
        name: 'Leg Curls',
        sets: 3,
        reps: isLoseWeight ? '12-15' : '10-12',
        restSeconds: 60,
        rpe: '7-8',
        muscleGroup: 'Hamstrings',
      ),
      Exercise(
        id: '6',
        name: 'Calf Raises',
        sets: 4,
        reps: '15-20',
        restSeconds: 45,
        rpe: '7-8',
        muscleGroup: 'Calves',
      ),
    ];
    
    // Only 3 days per week for Push/Pull/Legs
    List<WorkoutDay> days = [
      WorkoutDay(
        id: 'push_1',
        name: 'Push Day',
        exercises: pushExercises,
        estimatedDuration: _calculateDuration(pushExercises),
        dayOfWeek: 'Monday',
      ),
      WorkoutDay(
        id: 'pull_1',
        name: 'Pull Day',
        exercises: pullExercises,
        estimatedDuration: _calculateDuration(pullExercises),
        dayOfWeek: 'Tuesday',
      ),
      WorkoutDay(
        id: 'legs_1',
        name: 'Legs Day',
        exercises: legExercises,
        estimatedDuration: _calculateDuration(legExercises),
        dayOfWeek: 'Wednesday',
      ),
    ];
    
    return days;
  }
  
  static int _calculateDuration(List<Exercise> exercises) {
    int totalSeconds = 0;
    for (var exercise in exercises) {
      totalSeconds += exercise.sets * (exercise.restSeconds + 60); // 60s per set average
    }
    return (totalSeconds / 60).round();
  }
  
  static Map<int, String> _generateWeeklyProgression(String goal) {
    switch (goal) {
      case 'build_muscle':
        return {
          1: 'Week 1: Establish baseline weights, focus on form',
          2: 'Week 2: Add 2.5-5kg to compound lifts, increase volume if feeling strong',
          3: 'Week 3: Progressive overload - add reps or weight where possible',
          4: 'Week 4: Peak week - push intensity, then deload week 5',
        };
      case 'lose_weight':
        return {
          1: 'Week 1: Establish routine, focus on movement quality',
          2: 'Week 2: Increase volume slightly, reduce rest times by 10-15s',
          3: 'Week 3: Add 1-2 sets or increase reps by 2-3 per exercise',
          4: 'Week 4: Maintain intensity, focus on consistency',
        };
      default:
        return {
          1: 'Week 1: Establish baseline',
          2: 'Week 2: Slight progression',
          3: 'Week 3: Maintain intensity',
          4: 'Week 4: Review and adjust',
        };
    }
  }
}

