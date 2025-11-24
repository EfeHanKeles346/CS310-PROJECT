class Exercise {
  final String id;
  final String name;
  final int sets;
  final String reps; // e.g., "8-10", "12-15"
  final int restSeconds;
  final String? rpe; // e.g., "7-8", "8-9"
  final String? notes;
  final String muscleGroup;
  
  Exercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.restSeconds,
    this.rpe,
    this.notes,
    required this.muscleGroup,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sets': sets,
      'reps': reps,
      'restSeconds': restSeconds,
      'rpe': rpe,
      'notes': notes,
      'muscleGroup': muscleGroup,
    };
  }
  
  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      name: map['name'],
      sets: map['sets'],
      reps: map['reps'],
      restSeconds: map['restSeconds'],
      rpe: map['rpe'],
      notes: map['notes'],
      muscleGroup: map['muscleGroup'],
    );
  }
}

// Workout session tracking - kullanıcının yaptığı set ve kilo kayıtları
class ExerciseSet {
  int setNumber;
  double? weight; // kg
  int? reps;
  bool completed;
  String? notes;
  
  ExerciseSet({
    required this.setNumber,
    this.weight,
    this.reps,
    this.completed = false,
    this.notes,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'setNumber': setNumber,
      'weight': weight,
      'reps': reps,
      'completed': completed,
      'notes': notes,
    };
  }
  
  factory ExerciseSet.fromMap(Map<String, dynamic> map) {
    return ExerciseSet(
      setNumber: map['setNumber'],
      weight: map['weight']?.toDouble(),
      reps: map['reps'],
      completed: map['completed'] ?? false,
      notes: map['notes'],
    );
  }
}

