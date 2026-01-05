import 'exercise_model.dart';

class WorkoutDay {
  final String id;
  final String name; // e.g., "Push Day", "Pull Day", "Leg Day"
  final List<Exercise> exercises;
  final int estimatedDuration; // minutes
  final String dayOfWeek; // e.g., "Monday", "Wednesday"
  
  WorkoutDay({
    required this.id,
    required this.name,
    required this.exercises,
    required this.estimatedDuration,
    required this.dayOfWeek,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'exercises': exercises.map((e) => e.toMap()).toList(),
      'estimatedDuration': estimatedDuration,
      'dayOfWeek': dayOfWeek,
    };
  }
  
  factory WorkoutDay.fromMap(Map<String, dynamic> map) {
    return WorkoutDay(
      id: map['id'],
      name: map['name'],
      exercises: (map['exercises'] as List).map((e) => Exercise.fromMap(e)).toList(),
      estimatedDuration: map['estimatedDuration'],
      dayOfWeek: map['dayOfWeek'],
    );
  }
}

class WorkoutProgram {
  final String id;
  final String trainingSplit; // e.g., "Push/Pull/Legs", "Upper/Lower"
  final int daysPerWeek;
  final String goalFocus;
  final List<WorkoutDay> workoutDays;
  final Map<int, String> weeklyProgression; // Week number -> progression description
  
  WorkoutProgram({
    required this.id,
    required this.trainingSplit,
    required this.daysPerWeek,
    required this.goalFocus,
    required this.workoutDays,
    required this.weeklyProgression,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trainingSplit': trainingSplit,
      'daysPerWeek': daysPerWeek,
      'goalFocus': goalFocus,
      'workoutDays': workoutDays.map((d) => d.toMap()).toList(),
      'weeklyProgression': weeklyProgression.map((k, v) => MapEntry(k.toString(), v)),
    };
  }
  
  factory WorkoutProgram.fromMap(Map<String, dynamic> map) {
    return WorkoutProgram(
      id: map['id'],
      trainingSplit: map['trainingSplit'],
      daysPerWeek: map['daysPerWeek'],
      goalFocus: map['goalFocus'],
      workoutDays: (map['workoutDays'] as List).map((d) => WorkoutDay.fromMap(d)).toList(),
      weeklyProgression: (map['weeklyProgression'] as Map).map((k, v) => MapEntry(int.parse(k), v as String)),
    );
  }
}

